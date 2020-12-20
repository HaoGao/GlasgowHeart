%%%%select the proper dicom images for short axis and long axis
clear all; 
close all;
clc;

LVWM_config;

totalPatientNo = size(patientConfigs,1); %%%currently only cosidering one patient in 
if totalPatientNo > 1
    errordlg('load only one patient only');
end

SASlicePosition = 0;
LVOTSlicePosition = 0;
FourChSlicePosition = 0;
OneChSlicePosition = 0;
LGESASlicePosition = 0;

for patientIndex = 1 : 1 
       patientT = patientConfigs(patientIndex,1);
       patientName = patientT.name;
    
       totalStudyNo = size(patientT.studyName,1);
       for studyIndex = 1 : totalStudyNo
          studyName_sel = patientConfigs(patientIndex,1).studyName(studyIndex,1).studyName;
          studyDir_sel = patientConfigs(patientIndex,1).dir(studyIndex,1).studyDir;
          ImgDir_sel = patientConfigs(patientIndex,1).dirMidSA(studyIndex,1).ImgDir;
          spec_sel = patientConfigs(patientIndex,1).SliceSpec(studyIndex,1).spec;
          
          %%%now decide it is SA or LA, or LAG   
          if strcmp(spec_sel, 'SAcine')
             %%%load the image into SASlice 
              SASlicePosition = SASlicePosition + 1;
              dicomDir = sprintf('%s\\%s',studyDir_sel, ImgDir_sel);
              if ismac
                  dicomDir = sprintf('%s/%s',studyDir_sel, ImgDir_sel);
              end
              SXSliceT = loadAllDicomSAOrLAFromOneDir(dicomDir);
              SXSlice(SASlicePosition).SXSlice= SXSliceT;
              imDesired.SXSlice = SXSlice;
              imDesired.TimeEndOfSystole = patientT.TimeEndOfSystole;
              imDesired.TimeEndOfDiastole = patientT.TimeEndOfDiastole;
              imDesired.TimeEarlyOfDiastole = patientT.TimeEarlyOfDiastole;
          elseif  strcmp(spec_sel, 'LAcine_LVOT')
              LVOTSlicePosition = LVOTSlicePosition + 1;
              dicomDir = sprintf('%s\\%s',studyDir_sel, ImgDir_sel);
              if ismac
                  dicomDir = sprintf('%s/%s',studyDir_sel, ImgDir_sel);
              end
              LVOTSliceT = loadAllDicomSAOrLAFromOneDir(dicomDir);
              LVOTSlice(LVOTSlicePosition).LVOTSlice= LVOTSliceT;
              imDesired.LVOTSlice = LVOTSlice;
              
          elseif  strcmp(spec_sel, 'LAcine_4CH')
              FourChSlicePosition = FourChSlicePosition + 1;
              dicomDir = sprintf('%s\\%s',studyDir_sel, ImgDir_sel);
              if ismac
                  dicomDir = sprintf('%s/%s',studyDir_sel, ImgDir_sel);
              end
              FourCHSliceT = loadAllDicomSAOrLAFromOneDir(dicomDir);
              FourCHSlice(LVOTSlicePosition).FourCHSlice= FourCHSliceT;
              imDesired.FourCHSlice = FourCHSlice;
              
         elseif  strcmp(spec_sel, 'LAcine_1CH')
              OneChSlicePosition = OneChSlicePosition + 1;
              dicomDir = sprintf('%s\\%s',studyDir_sel, ImgDir_sel);
              if ismac
                  dicomDir = sprintf('%s/%s',studyDir_sel, ImgDir_sel);
              end
              
              OneCHSliceT = loadAllDicomSAOrLAFromOneDir(dicomDir);
              OneCHSlice(OneChSlicePosition).OneCHSlice= OneCHSliceT;
              imDesired.OneCHSlice = OneCHSlice;
         
        %%%adding SA series of LGE images
          elseif strcmp(spec_sel, 'LGE_SA')
              LGESASlicePosition = LGESASlicePosition + 1;
              dicomDir = sprintf('%s\\%s',studyDir_sel, ImgDir_sel);
              if ismac
                  dicomDir = sprintf('%s/%s',studyDir_sel, ImgDir_sel);
              end
              
              LGESASliceT = loadAllDicomLGEImage(dicomDir);
%               LGESASliceT(LGESASlicePosition).LGESASlice= LGESASliceT;
              imDesired.LGESASlice = LGESASliceT;
              
          end
       end
       
%         imData =  SXSliceSorted(1,imIndex).SXSlice(timeInstanceSelected).imData;
%         imInfo1 = SXSliceSorted(1,imIndex).SXSlice(timeInstanceSelected).imInfo;
%        SXSlice(SASlicePosition).SXSlice= SXSliceT;
         for studyIndex = 1 : SASlicePosition
             for timeInstIndex = 1 : patientConfigs(patientIndex,1).totalTimeInstance   
                 SXSliceSorted(1,studyIndex).SXSlice(1,timeInstIndex).imData = SXSlice(studyIndex).SXSlice(timeInstIndex).imData;
                 SXSliceSorted(1,studyIndex).SXSlice(1,timeInstIndex).imInfo = SXSlice(studyIndex).SXSlice(timeInstIndex).imInfo;
             end
         end

         %LVOTSliceSorted
         %%now combine all the long axial image together into
         %%LVOTSliceSorted
         LATotalNo = 0;
         for LAIndex = 1 : LVOTSlicePosition
             LATotalNo = LATotalNo + 1;
              for timeInstIndex = 1 : patientConfigs(patientIndex,1).totalTimeInstance   
                    LVOTSliceSorted(1,LATotalNo).LXSlice(timeInstIndex).imData = LVOTSlice(LAIndex).LVOTSlice(timeInstIndex).imData;
                    LVOTSliceSorted(1,LATotalNo).LXSlice(timeInstIndex).imInfo = LVOTSlice(LAIndex).LVOTSlice(timeInstIndex).imInfo;
              end
         end
         
         for LAIndex = 1 : FourChSlicePosition
             LATotalNo = LATotalNo + 1;
              for timeInstIndex = 1 : patientConfigs(patientIndex,1).totalTimeInstance   
                    LVOTSliceSorted(1,LATotalNo).LXSlice(timeInstIndex).imData = FourCHSlice(LAIndex).FourCHSlice(timeInstIndex).imData;
                    LVOTSliceSorted(1,LATotalNo).LXSlice(timeInstIndex).imInfo = FourCHSlice(LAIndex).FourCHSlice(timeInstIndex).imInfo;
              end
         end
         
         for LAIndex = 1 : OneChSlicePosition
             LATotalNo = LATotalNo + 1;
              for timeInstIndex = 1 : patientConfigs(patientIndex,1).totalTimeInstance   
                    LVOTSliceSorted(1,LATotalNo).LXSlice(timeInstIndex).imData = OneCHSlice(LAIndex).OneCHSlice(timeInstIndex).imData;
                    LVOTSliceSorted(1,LATotalNo).LXSlice(timeInstIndex).imInfo = OneCHSlice(LAIndex).OneCHSlice(timeInstIndex).imInfo;
              end
         end


       %%%save all the data
           cd(resultDir);
           save imDesired imDesired SXSliceSorted LVOTSliceSorted;
           cd(workingDir);
          
end