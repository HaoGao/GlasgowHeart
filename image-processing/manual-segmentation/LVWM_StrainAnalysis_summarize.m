clear all; close all; clc;
%%this will post-processing the strain data in order to decide which we
%%should use and which we should not 
% LVWM_config;
LVWM_config;
NoiseB = 1; %%add noise with 1 SD 


cd(resultDir);
fid = fopen('deformRes.dat', 'r');
fidS = fopen('deformResAllSlices.dat', 'w');
fidES = fopen('systolicStrain.dat', 'w');
cd(workingDir);

%%%in the sequence of infsetpal antseptal, ant, antlat, inflat, inf
%%%currently only consider circumferential
tline = fgetl(fid);
while ~feof(fid)
    cd(resultDir);
    cd(tline(1:end-1));
    tline = fgetl(fid);
    sliceNo = sscanf(tline, '%d');
    load BsplineResult_slice;
    cd(workingDir);
    
    index_cirInfSeptTotal = find_next_index_near_min_strain(cirInfSeptTotal);
    index_cirAntSeptTotal = find_next_index_near_min_strain(cirAntSeptTotal);

    index_cirAntTotal = find_next_index_near_min_strain(cirAntTotal);
    index_cirAntLatTotal = find_next_index_near_min_strain(cirAntLatTotal);
    
    index_cirInfLatTotal = find_next_index_near_min_strain(cirInfLatTotal);
    index_cirInfTotal = find_next_index_near_min_strain(cirInfTotal);
    
    
    
%     fprintf(fidS, '%d,\t %f,\t %f,\t %f,\t %f,\t %f,\t %f,\t\n', sliceNo, min(cirInfSeptTotal), min(cirAntSeptTotal), ...
%                     min(cirAntTotal), min(cirAntLatTotal), min(cirInfLatTotal), min(cirInfTotal));
    fprintf(fidS, '%d,\t %f,\t %f,\t %f,\t %f,\t %f,\t %f,\t\n', sliceNo, mean(cirInfSeptTotal(index_cirInfSeptTotal)), mean(cirAntSeptTotal(index_cirAntSeptTotal)), ...
                    mean(cirAntTotal(index_cirAntTotal)), mean(cirAntLatTotal(index_cirAntLatTotal)), mean(cirInfLatTotal(index_cirInfLatTotal)), mean(cirInfTotal(index_cirInfTotal)));
    fprintf(fidS, '%d,\t %f,\t %f,\t %f,\t %f,\t %f,\t %f,\t\n', sliceNo, 1,1,1,1,1,1);
    fprintf(fidS, '\n');
    fprintf(fidS, '\n');
    
    %%for end-systolic strain estimation 
    fprintf(fidES, '%d,\t %f,\t %f,\t %f,\t %f,\t %f,\t %f,\t\n', sliceNo, min(cirInfSeptTotal), min(cirAntSeptTotal), ...
                    min(cirAntTotal), min(cirAntLatTotal), min(cirInfLatTotal), min(cirInfTotal));
    fprintf(fidES, '%d,\t %f,\t %f,\t %f,\t %f,\t %f,\t %f,\t\n', sliceNo, 1,1,1,1,1,1);
    fprintf(fidES, '\n');
    fprintf(fidES, '\n');
    
    
    tline = fgetl(fid);
end

fclose(fidS);
fclose(fidES);
fclose(fid);



%%%summarize the average peak ES strain
cd(resultDir);
data_strain_ori = load('systolicStrain.dat');
cd(workingDir);

N = size(data_strain_ori,1)/2;
SegN = size(data_strain_ori,2);

strainES = [];
for i = 1 : N
    for j =  2 : SegN
        if data_strain_ori(2*i,j) > 0.9 %&& data_strain(2*i-1,j) < -0.1
            strainES = [strainES; data_strain_ori(2*i-1,j)];
        end
    end
end

aveStrainEs = mean(strainES)

