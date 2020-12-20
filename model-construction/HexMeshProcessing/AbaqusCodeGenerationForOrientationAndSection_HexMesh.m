function AbaqusCodeGenerationForOrientationAndSection_HexMesh(abaqusInputDir, workingDir, dataResult, abaqusDir)

cd(abaqusInputDir);
heart_face = load('heart_real.1.face');
heart_node = load('heart_real.1.node');
heart_ele = load('heart_real.1.ele');
cd(workingDir);
cd(dataResult);
load localCorSys;
load helixAngle;
load nodeDistance;
load FiberDirection;
fidFiberData = load('fiberDir.txt');
fidSheetData = load('sheetDir.txt');
cd(workingDir);

%%%% orientation generation
% cd(dataResult);
% fidOri = fopen('ori-elements.txt','w');
% fidSolidSectionGeneration = fopen('solidsectiongeneration.txt','w');
% fidSectionAssignment = fopen('solidsectionassignment.txt','w');
% cd(workingDir);
% for i = 1 : size(fidFiberData(:,1))
%     fprintf(fidOri, '*orientation,name=ori-%d,local directions=2\n',fidFiberData(i,1));
%     fprintf(fidOri,'1.0,0.0,0.0,0.0,1.0,0.0\n');
%     fprintf(fidOri,'3,0.0\n');
%     fprintf(fidOri,'%f, %f, %f\n', fidFiberData(i,2),fidFiberData(i,3),fidFiberData(i,4));
%     fprintf(fidOri,'%f, %f, %f\n', fidSheetData(i,2),fidSheetData(i,3),fidSheetData(i,4));
%     
%     fprintf(fidSolidSectionGeneration, '*Elset, elset=strip-%d, internal\n',fidFiberData(i,1));
%     fprintf(fidSolidSectionGeneration, '%d\n',fidFiberData(i,1));
%     
%     fprintf(fidSectionAssignment,'*Solid Section, elset=strip-%d, material=IliacAdventitia, orientation=ori-%d\n',fidFiberData(i,1),fidFiberData(i,1));
%     fprintf(fidSectionAssignment,'1.,\n');
%     
% end
% fclose(fidOri);
% fclose(fidSolidSectionGeneration);
% fclose(fidSectionAssignment);

cd(dataResult);
fibTot = fopen('fibTotal.inp','w');
cd(workingDir);
fprintf(fibTot,' ,\t%f,\t %f,\t %f,\t %f,\t %f,\t %f,\n', fidFiberData(end,2),fidFiberData(end,3),fidFiberData(end,4), fidSheetData(end,2),fidSheetData(end,3),fidSheetData(end,4));
 for i = 1 : size(fidFiberData(:,1))
%     fprintf(fibTot, '*Elset, elset=strip-%d, internal\n',fidFiberData(i,1));
%     fprintf(fibTot, '%d\n',fidFiberData(i,1));
%     
%     fprintf(fibTot, '*orientation,name=ori-%d,local directions=2\n',fidFiberData(i,1));
%     fprintf(fibTot,'1.0,0.0,0.0,0.0,1.0,0.0\n');
%     fprintf(fibTot,'3,0.0\n');
    fprintf(fibTot,'%d,\t%f,\t %f,\t %f,\t %f,\t %f,\t %f,\n', fidFiberData(i,1), fidFiberData(i,2),fidFiberData(i,3),fidFiberData(i,4), fidSheetData(i,2),fidSheetData(i,3),fidSheetData(i,4));
    
%     fprintf(fibTot,'*Solid Section, elset=strip-%d, material=IliacAdventitia, orientation=ori-%d\n',fidFiberData(i,1),fidFiberData(i,1));
%     fprintf(fibTot,'1.,\n');
    
 end
fclose(fibTot);

%%this file will be directly used by abaqus program
cd(abaqusDir);
fibTot = fopen('hexdirfibersheetF60S45.inp','w');
cd(workingDir);
fprintf(fibTot, ' *DISTRIBUTION, NAME=dist1, LOCATION=element, TABLE=Fiberdir\n');
fprintf(fibTot, ' , 1.0,0.0,0.0,0.0,1.0,0.0\n');
 for i = 1 : size(fidFiberData(:,1))
    fprintf(fibTot,'%d,\t%f,\t %f,\t %f,\t %f,\t %f,\t %f,\n', fidFiberData(i,1), fidFiberData(i,2),fidFiberData(i,3),fidFiberData(i,4), fidSheetData(i,2),fidSheetData(i,3),fidSheetData(i,4));
 end
fclose(fibTot);






