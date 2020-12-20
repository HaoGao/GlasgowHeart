function AbaqusInputToTetGen_HexMesh(abaqusInputDir)

DirConfig;
% workingDir = pwd();
cd(abaqusInputDir);

epiB = -2; endoB = 2;innerB = 0;
Ver=load('Node.txt');
TMesh=load('Element.txt');
domainID = load('domainID.txt');

% EndoS1=load('./AbaqusInput/Endos1.txt');
%  filenameEndoS2='EndoS2.txt';
endofaceS1=[]; endofaceS2=[]; endofaceS3=[];
endofaceS4=[]; endofaceS5=[]; endofaceS6=[];
filenameEndoS1 = 'EndoS1.txt';
% endofaceS1_t = load(filenameEndoS1);
% endofaceS1 = endofaceS1_t(1):endofaceS1_t(3):endofaceS1_t(2);
endofaceS1 = readingFaces(filenameEndoS1);
endofaceS1 = endofaceS1';

filenameEndoS3 = 'EndoS3.txt';
% endofaceS3_t = load(filenameEndoS3);
% endofaceS3 = endofaceS3_t(1):endofaceS3_t(3):endofaceS3_t(2);
endofaceS3 = readingFaces(filenameEndoS3);
endofaceS3 = endofaceS3';

% endofaceS2_t=load(filenameEndoS2);
% endofaceS2 = endofaceS2_t(1):endofaceS2_t(3):endofaceS2_t(2);
% endofaceS2 = endofaceS2';
% endofaceS2 = readingFaces(filenameEndoS2);

%%%%base
basefaceS1=[]; basefaceS2=[]; basefaceS3=[];
basefaceS4=[]; basefaceS5=[]; basefaceS6=[];
filenameBaseS1='BaseS1.txt';
% basefaceS1_t = load(filenameBaseS1);
% basefaceS1 = basefaceS1_t(1):basefaceS1_t(3):basefaceS1_t(2);
basefaceS1 = readingFaces(filenameBaseS1);
basefaceS1 = basefaceS1';

%%%epi
epifaceS1=[]; epifaceS2=[]; epifaceS3=[];
epifaceS4=[]; epifaceS5=[]; epifaceS6=[];
filenameEpiS2='EpiS2.txt';
% epifaceS2_t = load(filenameEpiS2);
% epifaceS2 = epifaceS2_t(1):epifaceS2_t(3):epifaceS2_t(2);
epifaceS2 = readingFaces(filenameEpiS2);
epifaceS2 = epifaceS2';

filenameEpiS5='EpiS5.txt';
% epifaceS5_t = load(filenameEpiS5);
% epifaceS5 = epifaceS5_t(1):epifaceS5_t(3):epifaceS5_t(2);
epifaceS5 = readingFaces(filenameEpiS5);
epifaceS5 = epifaceS5';



TMeshLibmesh = TMesh;
epiID = 4096; endoID = 4097; baseID = 4098;
%%%the node number will be 1-9, and 6 faces(10 11 12 13 14 15), 6
%%%boundaries(16 17 18 19 20 21)
%%%map from abaqus to libmesh
%%s1--> 10(16)
%%s2--> 15(21)
%%s3--> 11(17)
%%s4--> 12(18)
%%s5--> 13(19)
%%s6--> 14(20)
%%%%%%%%%%%%%%%%for endo
if ~isempty(endofaceS1)
    for i = 1 : length(endofaceS1)
        TMeshLibmesh(endofaceS1(i),10) = 1;
        TMeshLibmesh(endofaceS1(i),16) = endoID;
    end
end
if ~isempty(endofaceS2)
    for i = 1 : length(endofaceS2)
        TMeshLibmesh(endofaceS2(i),15) = 1;
        TMeshLibmesh(endofaceS2(i),21) = endoID;
    end
end
if ~isempty(endofaceS3)
    for i = 1 : length(endofaceS3)
        TMeshLibmesh(endofaceS3(i),11) = 1;
        TMeshLibmesh(endofaceS3(i),17) = endoID;
    end
end
if ~isempty(endofaceS4)
    for i = 1 : length(endofaceS4)
        TMeshLibmesh(endofaceS4(i),12) = 1;
        TMeshLibmesh(endofaceS4(i),18) = endoID;
    end
end
if ~isempty(endofaceS5)
    for i = 1 : length(endofaceS5)
        TMeshLibmesh(endofaceS5(i),13) = 1;
        TMeshLibmesh(endofaceS5(i),19) = endoID;
    end
end
if ~isempty(endofaceS6)
    for i = 1 : length(endofaceS6)
        TMeshLibmesh(endofaceS6(i),14) = 1;
        TMeshLibmesh(endofaceS6(i),20) = endoID;
    end
end
%%%%%%%%%%%for base
if ~isempty(basefaceS1)
    for i = 1 : length(basefaceS1)
        TMeshLibmesh(basefaceS1(i),10) = 1;
        TMeshLibmesh(basefaceS1(i),16) = baseID;
    end
end
if ~isempty(basefaceS2)
    for i = 1 : length(basefaceS2)
        TMeshLibmesh(basefaceS2(i),15) = 1;
        TMeshLibmesh(basefaceS2(i),21) = baseID;
    end
end
if ~isempty(basefaceS3)
    for i = 1 : length(basefaceS3)
        TMeshLibmesh(basefaceS3(i),11) = 1;
        TMeshLibmesh(basefaceS3(i),17) = baseID;
    end
end
if ~isempty(basefaceS4)
    for i = 1 : length(basefaceS4)
        TMeshLibmesh(basefaceS4(i),12) = 1;
        TMeshLibmesh(basefaceS4(i),18) = baseID;
    end
end
if ~isempty(basefaceS5)
    for i = 1 : length(basefaceS5)
        TMeshLibmesh(basefaceS5(i),13) = 1;
        TMeshLibmesh(basefaceS5(i),19) = baseID;
    end
end
if ~isempty(basefaceS6)
    for i = 1 : length(basefaceS6)
        TMeshLibmesh(basefaceS6(i),14) = 1;
        TMeshLibmesh(basefaceS6(i),20) = baseID;
    end
end

%%%%%%for epi
if ~isempty(epifaceS1)
    for i = 1 : length(epifaceS1)
        TMeshLibmesh(epifaceS1(i),10) = 1;
        TMeshLibmesh(epifaceS1(i),16) = epiID;
    end
end
if ~isempty(epifaceS2)
    for i = 1 : length(epifaceS2)
        TMeshLibmesh(epifaceS2(i),15) = 1;
        TMeshLibmesh(epifaceS2(i),21) = epiID;
    end
end
if ~isempty(epifaceS3)
    for i = 1 : length(epifaceS3)
        TMeshLibmesh(epifaceS3(i),11) = 1;
        TMeshLibmesh(epifaceS3(i),17) = epiID;
    end
end
if ~isempty(epifaceS4)
    for i = 1 : length(epifaceS4)
        TMeshLibmesh(epifaceS4(i),12) = 1;
        TMeshLibmesh(epifaceS4(i),18) = epiID;
    end
end
if ~isempty(epifaceS5)
    for i = 1 : length(epifaceS5)
        TMeshLibmesh(epifaceS5(i),13) = 1;
        TMeshLibmesh(epifaceS5(i),19) = epiID;
    end
end
if ~isempty(epifaceS6)
    for i = 1 : length(epifaceS6)
        TMeshLibmesh(epifaceS6(i),14) = 1;
        TMeshLibmesh(epifaceS6(i),20) = epiID;
    end
end


%%%output to tecplot for check 
fid = fopen('TecPlot_endoepiSurface.dat','w');
fprintf(fid, 'TITLE = "endo surface plot" \n');
fprintf(fid, 'VARIABLES = "x", "y", "z", "u", "v", "w" \n');
totalEleQ = length(endofaceS1)+length(endofaceS3)+length(epifaceS2)+length(epifaceS5);
fprintf(fid, 'ZONE T="Endo Mesh", N = %d, E=%d, F=FEPOINT, ET=QUADRILATERAL\n', size(Ver, 1), totalEleQ);
for i = 1 : size(Ver,1)
    fprintf(fid,'%f\t%f\t%f\t%f\t%f\t%f\n',Ver(i,2),Ver(i,3),Ver(i,4),0,0,0);
end
for i = 1 : length(endofaceS1)
    fprintf(fid, '%d\t%d\t%d\t%d\n', TMesh(endofaceS1(i),2), TMesh(endofaceS1(i),3),TMesh(endofaceS1(i),4),TMesh(endofaceS1(i),5));
end
for i = 1 : length(endofaceS3)
    fprintf(fid, '%d\t%d\t%d\t%d\n', TMesh(endofaceS3(i),2), TMesh(endofaceS3(i),6),TMesh(endofaceS3(i),7),TMesh(endofaceS3(i),3));
end
for i = 1 : length(epifaceS2)
    fprintf(fid, '%d\t%d\t%d\t%d\n', TMesh(epifaceS2(i),6), TMesh(epifaceS2(i),9),TMesh(epifaceS2(i),8),TMesh(epifaceS2(i),7));
end
for i = 1 : length(epifaceS5)
    fprintf(fid, '%d\t%d\t%d\t%d\n', TMesh(epifaceS5(i),4), TMesh(epifaceS5(i),8),TMesh(epifaceS5(i),9),TMesh(epifaceS5(i),5));
end
fclose(fid);




%%%%generage tetgen file 
fid=fopen('heart_real.1.node','w');
for i = 1 : size(Ver,1)
    fprintf(fid, '%d\t%f\t%f\t%f\n', Ver(i,1), Ver(i,2), Ver(i,3), Ver(i,4));
end
fclose(fid);

fid=fopen('heart_real.1.ele','w');
fidLibmesh = fopen('heart_real.1.ele.Libmesh_HEX8.dat','w');
fprintf(fidLibmesh,'%d\t4\t0\n',size(TMesh,1));
for i = 1 : size(TMesh,1)
    fprintf(fid,'%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n', TMesh(i,1),TMesh(i,2),TMesh(i,3),TMesh(i,4),TMesh(i,5), ...
                                                                   TMesh(i,6),TMesh(i,7),TMesh(i,8),TMesh(i,9));
    fprintf(fidLibmesh,'%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n', ...
                        TMeshLibmesh(i,1),TMeshLibmesh(i,2),TMeshLibmesh(i,3),TMeshLibmesh(i,4),TMeshLibmesh(i,5),TMeshLibmesh(i,6),TMeshLibmesh(i,7),TMeshLibmesh(i,8),TMeshLibmesh(i,9), ...
                        TMeshLibmesh(i,10),TMeshLibmesh(i,11),TMeshLibmesh(i,12),TMeshLibmesh(i,13),TMeshLibmesh(i,14),TMeshLibmesh(i,15),...
                        TMeshLibmesh(i,16),TMeshLibmesh(i,17),TMeshLibmesh(i,18),TMeshLibmesh(i,19),TMeshLibmesh(i,20),TMeshLibmesh(i,21));
end
fclose(fid);
fclose(fidLibmesh);




index = 0;
fid = fopen('heart_real.1.face','w');
for i = 1 : length(endofaceS1)
    index = index+1;
    fprintf(fid,'%d\t%d\t%d\t%d\t%d\t%d\n', index, TMesh(endofaceS1(i),2), TMesh(endofaceS1(i),3),TMesh(endofaceS1(i),4),TMesh(endofaceS1(i),5),endoB);
end
for i = 1 : length(endofaceS3)
    index = index+1;
    fprintf(fid,'%d\t%d\t%d\t%d\t%d\t%d\n', index, TMesh(endofaceS3(i),2), TMesh(endofaceS3(i),6),TMesh(endofaceS3(i),7),TMesh(endofaceS3(i),3),endoB);
end

%%%base
for i = 1 : length(basefaceS1)
    index = index+1;
    fprintf(fid,'%d\t%d\t%d\t%d\t%d\t%d\n', index, TMesh(basefaceS1(i),2),TMesh(basefaceS1(i),3), TMesh(basefaceS1(i),4),TMesh(basefaceS1(i),5),innerB);
end

%%%%epi
for i = 1 : length(epifaceS2)
    index = index+1;
    fprintf(fid,'%d\t%d\t%d\t%d\t%d\t%d\n', index, TMesh(epifaceS2(i),6),TMesh(epifaceS2(i),9), TMesh(epifaceS2(i),8),TMesh(epifaceS2(i),7),epiB);
end

for i = 1 : length(epifaceS5)
    index = index+1;
    fprintf(fid,'%d\t%d\t%d\t%d\t%d\t%d\n', index, TMesh(epifaceS5(i),4),TMesh(epifaceS5(i),8), TMesh(epifaceS5(i),9),TMesh(epifaceS5(i),5),epiB);
end

fclose(fid);


cd(workingDir);


function facelist=readingFaces(filename)
fid = fopen(filename);
EndoS1=[];
while ~feof(fid)
    tline=fgetl(fid);
    faces=sscanf(tline,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
    if ~isempty(faces)
       EndoS1=[EndoS1 faces'];
    end
end
facelist=EndoS1;
fclose(fid);





