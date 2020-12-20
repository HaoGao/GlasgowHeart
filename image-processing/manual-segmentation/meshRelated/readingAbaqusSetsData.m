function readlist=readingAbaqusSetsData(fid)
%%each line with 16 data entries
% fid = fopen(filename,'r');
EndoS1=[];
while ~feof(fid)
    tline=fgetl(fid);
    faces=sscanf(tline,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
    if ~isempty(faces)
       EndoS1=[EndoS1 faces'];
    end
end
readlist=EndoS1;
fclose(fid);
