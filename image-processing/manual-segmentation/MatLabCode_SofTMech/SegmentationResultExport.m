function SegmentationResultExport()

workingDir = pwd();

%% output directory
export_root_dir = 'E:\HaoGao\owncloud\clientsync\Projects\segmentations_mi_HGShare\example_images\exported_AI';
if ~exist(export_root_dir, 'dir')
    mkdir(export_root_dir)
end


%% subjects to be exported
SegmentationResultExport_SubjectLists;
%% this will load the subject list

%%then we will need to extract one subject
total_subjects = size(SubjectList,1);
subject_phase = 'earlyDiastole'; 

for subject_index = 1 : total_subjects
    subject_name = SubjectList(subject_index,1).name;
    subject_root_dir = fullfile(SubjectList(subject_index,1).dir, subject_name);
    
    str_msg = sprintf('exporting %s', subject_name);
    disp(str_msg);
    
    cd(subject_root_dir)
    %%looking for the config file for early diastole
    fstruct = dir('*EarlyDia.m');
    if size(fstruct, 1) < 1
        fstruct = dir('MI_confERD_*.m');
    end
    
    cd(workingDir);
    
    %%decide whether this file exist or not, if not , stop running and
    %%needs to find out why 
    if size(fstruct,1) == 1
        filename = fstruct(1,1).name;
        time_selected = extractSelectedTime(subject_root_dir, filename);
        subject_segmentation_dir = fullfile(subject_root_dir, subject_phase);
                  
        
        %%set up the export dir
        export_segmentation_dir = fullfile(export_root_dir, subject_name);
        if ~exist(export_segmentation_dir, 'dir')
            mkdir(export_segmentation_dir);
        end 
        cd(export_segmentation_dir);
        export_segmentation_dir = pwd();
        cd(workingDir);
        export_data(subject_segmentation_dir, export_segmentation_dir, time_selected); 
    else
        if isempty(fstruct)
            err_msg = sprintf('can not find a file name as *EarlyDia.m in %s\n', subject_root_dir);
        elseif size(fstruct,1) > 1
            err_msg = sprintf('find more than one name as *EarlyDia.m in %s\n', subject_root_dir);
        end
        
        error(err_msg);
    end
    
    
end


% % time_selected_seg = 'TimeEarlyOfDiastole';
% timeSelected = 16; %% this has to be manually corrected
% 
% subject_segmentation_dir = fullfile(subject_root_dir, subject_name, ...
%              subject_phase);
% %convert into a global path 
% cd(subject_segmentation_dir);
% subject_segmentation_dir = pwd();
% cd(workingDir);
% 
% %%set up the export dir
% export_segmentation_dir = fullfile(export_root_dir, subject_name, ...
%                 subject_phase);
% if ~exist(export_segmentation_dir, 'dir')
%     mkdir(export_segmentation_dir);
% end 
% cd(export_segmentation_dir);
% export_segmentation_dir = pwd();
% cd(workingDir);




%  export_data(subject_segmentation_dir, export_segmentation_dir, timeSelected)



function time_selected = extractSelectedTime(subject_root_dir, filename)
workingDir = pwd();
cd(subject_root_dir);
fid = fopen(filename, 'r');
tline = fgetl(fid);
while ischar(tline)
   C = strsplit(tline,' ');
   str1  = C{1};
   if strcmp('patientConfigs(patientIndex,1).TimeEarlyOfDiastole', str1)
       patientIndex = 1; 
       eval(tline);
       time_selected = patientConfigs(patientIndex,1).TimeEarlyOfDiastole; 
       break;
   end
   tline = fgetl(fid);
end

time_selected = patientConfigs(1,1).TimeEarlyOfDiastole;
cd(workingDir);




function export_data(subject_segmentation_dir, export_segmentation_dir, timeSelected)

workingDir = pwd();
%%load the image and the segmentation results for the short axis and long
%%axis
cd(subject_segmentation_dir);
load DataSegSAOri.mat;
load DataSegLAOri.mat;
load imDesired.mat;
cd(workingDir);

% if isfield(imDesired, time_selected_seg)
%    timeSelected = extractfield(imDesired, time_selected_seg);
% else
%     error('Error, selected time phase (%s) for segmenation does not existed'...
%         , time_selected_seg);
% end

%%now delete all other unneeded dicom images to save space 

total_SA_slices = size(imDesired.SXSlice, 2);
total_SA_phases = size(imDesired.SXSlice(1).SXSlice, 1);

SXSlice = [];
for slice_index = 1 : total_SA_slices
    SXSlice = imDesired.SXSlice(slice_index).SXSlice(timeSelected);
    
    %%% plot the bcs for showing the images
    bc_seg = DataSegSA(1,slice_index);
    endo_c = bc_seg.endo_c;
    epi_c =  bc_seg.epi_c;
    
    h = figure('visible','off'); hold on;
    imshow(SXSlice.imData, []); hold on;
    plot(endo_c(1,:), endo_c(2,:), 'r', 'LineWidth', 1); 
    plot(epi_c(1,:), epi_c(2,:), 'b', 'LineWidth', 1);
    
    %%save the file 
    cd(export_segmentation_dir);
    file_name = sprintf('SA_%d.png', slice_index);
    print(h, file_name, '-dpng');
    close(h);
    cd(workingDir);
    
    imdesiredExported.SXSlice(slice_index).SXSlice  = SXSlice;
    imdesiredExported.SXSlice(slice_index).PixelSpacing = SXSlice.imInfo.PixelSpacing;
    imdesiredExported.SXSlice(slice_index).imData = SXSlice.imData;
end


%%now export the long-axis images
LVOTSlice = imDesired.LVOTSlice.LVOTSlice(timeSelected, 1);
FourCHSlice = imDesired.FourCHSlice.FourCHSlice(timeSelected, 1);
OneCHSlice = imDesired.OneCHSlice.OneCHSlice(timeSelected,1);
imdesiredExported.LVOTSlice = LVOTSlice;
imdesiredExported.LVOT_imdata = LVOTSlice.imData;
imdesiredExported.LVOT_PixelSpacing = LVOTSlice.imInfo.PixelSpacing;

imdesiredExported.FourCHSlice = FourCHSlice;
imdesiredExported.FourCH_imdata = FourCHSlice.imData;
imdesiredExported.FourCH_PixelSpacing = FourCHSlice.imInfo.PixelSpacing;

imdesiredExported.OneCHSlice = OneCHSlice;
imdesiredExported.OneCH_imdata = OneCHSlice.imData;
imdesiredExported.OneCH_PixelSpacing = OneCHSlice.imInfo.PixelSpacing;

%% also print out the overlaped BC with images for long-axis data 
h = figure('visible','off'); hold on;
imshow(LVOTSlice.imData, []); hold on;
plot(DataSegLA(1).endo_c(1,:), DataSegLA(1).endo_c(2,:), 'r', 'LineWidth', 1); 
plot(DataSegLA(1).epi_c(1,:), DataSegLA(1).epi_c(2,:), 'b', 'LineWidth', 1);
%%save the file 
cd(export_segmentation_dir);
file_name = sprintf('LVOTSlice.png');
print(h, file_name, '-dpng');
close(h);
cd(workingDir);


h = figure('visible','off'); hold on;
imshow(FourCHSlice.imData, []); hold on;
plot(DataSegLA(2).endo_c(1,:), DataSegLA(2).endo_c(2,:), 'r', 'LineWidth', 1); 
plot(DataSegLA(2).epi_c(1,:), DataSegLA(2).epi_c(2,:), 'b', 'LineWidth', 1);
%%save the file 
cd(export_segmentation_dir);
file_name = sprintf('FourCHSlice.png');
print(h, file_name, '-dpng');
close(h);
cd(workingDir);

h = figure('visible','off'); hold on;
imshow(OneCHSlice.imData, []); hold on;
plot(DataSegLA(3).endo_c(1,:), DataSegLA(3).endo_c(2,:), 'r', 'LineWidth', 1); 
plot(DataSegLA(3).epi_c(1,:), DataSegLA(3).epi_c(2,:), 'b', 'LineWidth', 1);
%%save the file 
cd(export_segmentation_dir);
file_name = sprintf('OneCHSlice.png');
print(h, file_name, '-dpng');
close(h);
cd(workingDir);

cd(export_segmentation_dir)
save img_seg_data imdesiredExported DataSegSA DataSegLA;
cd(workingDir);




