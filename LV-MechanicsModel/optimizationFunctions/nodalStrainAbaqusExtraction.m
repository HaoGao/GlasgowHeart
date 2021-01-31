function nodalStrainAbaqus = nodalStrainAbaqusExtraction(abaqus_strain_out_filename,abaqusDir)

workingDir = pwd();
cd(abaqusDir);
strainT = load(abaqus_strain_out_filename);
cd(workingDir);

maxNodeNumber = max(strainT(:,1));

for i = 1 : maxNodeNumber
    nodalNumber = i;
    nodalStrainAbaqus(i).nodalNumber = nodalNumber;
    nodalStrainAbaqus(i).strainNodal = [];
end


for i = 1 : length(strainT(:,1))
    noNumber = strainT(i,1);
    strainNodal = strainT(i,2:7);
    
    size_strainSequence = length(nodalStrainAbaqus(noNumber).strainNodal);
    nodalStrainAbaqus(noNumber).strainNodal(size_strainSequence+1).strain = strainNodal;
end

    
       
        
   
    
    
    
    
end








% nodalStrainAbaqus = strainT;