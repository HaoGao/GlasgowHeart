function WriteAbaqusFaces(endofacesT,fileExeMid,abaqusFiberDir,workingDir)

if ~isempty(endofacesT.S1faces)
    str = endofacesT.S1;
    faces = endofacesT.S1faces;
    writeAbaqusfaces_foreachsurface(abaqusFiberDir,workingDir, fileExeMid,  str, faces);
end

if ~isempty(endofacesT.S2faces)
    str = endofacesT.S2;
    faces = endofacesT.S2faces;
    writeAbaqusfaces_foreachsurface(abaqusFiberDir,workingDir, fileExeMid,  str, faces);
end
   
if ~isempty(endofacesT.S3faces)
    str = endofacesT.S3;
    faces = endofacesT.S3faces;
    writeAbaqusfaces_foreachsurface(abaqusFiberDir,workingDir, fileExeMid,  str, faces);
end

if ~isempty(endofacesT.S4faces)
    str = endofacesT.S4;
    faces = endofacesT.S4faces;
    writeAbaqusfaces_foreachsurface(abaqusFiberDir,workingDir, fileExeMid,  str, faces);
end

if ~isempty(endofacesT.S5faces)
    str = endofacesT.S5;
    faces = endofacesT.S5faces;
    writeAbaqusfaces_foreachsurface(abaqusFiberDir,workingDir, fileExeMid,  str, faces);
end

if ~isempty(endofacesT.S6faces)
    str = endofacesT.S6;
    faces = endofacesT.S6faces;
    writeAbaqusfaces_foreachsurface(abaqusFiberDir,workingDir, fileExeMid,  str, faces);
end