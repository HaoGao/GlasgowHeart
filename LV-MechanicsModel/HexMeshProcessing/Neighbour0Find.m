function [neighbour0 meshNeighbour] =Neighbour0Find(verInd,endoSurf)
NoEndoM = size(endoSurf,1);
neighbour0=verInd;
meshNeighbour = [];

for mInd = 1 : NoEndoM
    recm = endoSurf(mInd,:);
    bf = find(recm==verInd);
    if length(bf) >=1 
        meshNeighbour = [meshNeighbour; recm];
        for i = 1 : length(recm)
            bfn = find(neighbour0==recm(i));
            if length(bfn) == 0
                neighbour0 = [neighbour0 recm(i)];
            end
        end
    end
end