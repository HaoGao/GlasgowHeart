function [alpha0, w0, umax] = readGeometry_Epi(resultDir, prolateParametersFileName)

% fid = fopen('ProlateParameters.dat','r');
workingDir = pwd();
cd(resultDir);
fid = fopen(prolateParametersFileName,'r');
cd(workingDir);

tline = fgetl(fid);
alpha0 = sscanf(tline, '%f');

tline = fgetl(fid);
w1 = sscanf(tline, '%f');

tline = fgetl(fid);
w2 = sscanf(tline, '%f');

tline = fgetl(fid);
umax = sscanf(tline, '%f');

w0 = w2;
umax = umax*pi/180;

sline = sprintf('alpha0: \tw0(w1):\t w2: \tumax:');
disp(sline);

sline = sprintf('%f \t%f   \t%f  \t%f', alpha0, w0, w2, umax);
disp(sline);


fclose(fid);