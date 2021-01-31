function LVStrain = FiniteStrainForRect(LVMesh,CurP,RefP,shapex,shapey)

totalMesh = size(LVMesh,1);

for i = 1 : totalMesh
    for pindex = 1 : 4
        x(1,pindex)=CurP(LVMesh(i,pindex),1);
        x(2,pindex)=CurP(LVMesh(i,pindex),2);
        X(1,pindex)=RefP(LVMesh(i,pindex),1);
        X(2,pindex)=RefP(LVMesh(i,pindex),2);
    end
    xt = mean(X(1,:));
    yt = mean(X(2,:));
    
    x(1,:)=x(1,:)-x(1,1);
    x(2,:)=x(2,:)-x(2,1);
    X(1,:)=X(1,:)-X(1,1);
    X(2,:)=X(2,:)-X(2,1);
    
    F = x/X;
%     Eulr = (1/2)*([1 0;0 1]-(F')*F);
    
    Eulr=(1/2)*((F')*F-[1 0;0 1]);
    
    %%%get the circumferential and radial directons 
    
    
    
    rvect = NormalizationGH([xt-shapex, yt-shapey]);
    cvect = [-rvect(2) rvect(1)];
    Rot = [rvect(1) rvect(2);
           cvect(1) cvect(2)];
             
    EulRotated = Rot*Eulr*(Rot');
                  
%     EulRotated = Rot*Eulr*(Rot');
    
    LVStrain(i).strain = Eulr;
    LVStrain(i).crstrain = EulRotated;
end


