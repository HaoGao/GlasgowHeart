function [Mesh Points] = EndoEpiMeshGeneration(EndoS,EpiS,sampleN)

Mesh = [];
Points = [];

Points = [EndoS; EpiS];

meshIndex = 0;
for i = 1 : sampleN-1
    I = i; 
    J = i+sampleN;
    K = i+sampleN+1;
    L = i+1;
    
    meshIndex = meshIndex + 1;
    Mesh(meshIndex,:) = [I J K L];
end
i = sampleN;
I = i; 
J = i+sampleN;
K = sampleN + 1;
L = 1;
meshIndex = meshIndex + 1;
Mesh(meshIndex,:) = [I J K L];