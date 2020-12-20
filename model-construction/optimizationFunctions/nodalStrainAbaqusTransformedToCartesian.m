function [nodalStrainAbaqusCartesian, fiberStrainTotal,LogfiberStrainTotal] = nodalStrainAbaqusTransformedToCartesian(fiberDir, sheetDir, nodalStrainAbaqus)

fiberStrainTotal = zeros([ size(nodalStrainAbaqus,2),1]);
LogfiberStrainTotal = zeros([ size(nodalStrainAbaqus,2),1]);
I = [1 0 0; 0 1 0; 0 0 1];
for i = 1 : size(nodalStrainAbaqus,2)
    strainNodal_Abaqus = nodalStrainAbaqus(i);
    
    nodalNumber =  strainNodal_Abaqus.nodalNumber;
    assert(i==nodalNumber);
    
    strainNodal =  strainNodal_Abaqus.strainNodal;
    NoOfNodesRepeated = size(strainNodal,2);
    
    fiberStrain = [];
    logFiberStrain = [];
    for localIndex = 1 : NoOfNodesRepeated
        strainT = strainNodal(localIndex).strain;
        ksiL = zeros([3 3]);
        ksiL(1,1) = strainT(1);
        ksiL(2,2) = strainT(2);
        ksiL(3,3) = strainT(3);
        ksiL(1,2) = strainT(4)/2;
        ksiL(1,3) = strainT(5)/2;
        ksiL(2,3) = strainT(6)/2;
        ksiL(2,1) = ksiL(1,2);
        ksiL(3,1) = ksiL(1,3);
        ksiL(3,2) = ksiL(2,3);
        
        [n, lambda2] = eig(ksiL);
        lambda(1) = lambda2(1,1);
        lambda(2) = lambda2(2,2);
        lambda(3) = lambda2(3,3);
        
        U = exp(lambda(1))*n(:,1)*n(:,1)' + exp(lambda(2))*n(:,2)*n(:,2)' + exp(lambda(3))*n(:,3)*n(:,3)';
        
        C = U*U;
        Cinv = inv(C);
        
        ksi_car = 1/2*(Cinv-I);
        
        %%%now need to rotate to normal x y z direction 
        f = fiberDir(nodalNumber, 1:3);
        s = sheetDir(nodalNumber, 1:3);
        n = cross(f,s);
        
        %%%
        R = [f(1) f(2) f(3);
             s(1) s(2) s(3);
             n(1) n(2) n(3)];
%          ksi_car = R*ksi_car_xyz*R'
        %%%inv R = R'
        
        ksi_car_xyz = R'*ksi_car*R;
        ksi_car_fsn = R*ksi_car_xyz*R';
        
        
        
        fiberStrain = [fiberStrain ksi_car_fsn(1,1)];
        logFiberStrain = [logFiberStrain 1/exp(ksiL(1,1))-1];
        
        nodalStrainAbaqusCartesian(i).nodalNumber = nodalNumber;
        nodalStrainAbaqusCartesian(i).strainNodal(localIndex).strain = ksi_car;
        nodalStrainAbaqusCartesian(i).strainNodal(localIndex).strain_xyz = ksi_car_xyz;
        nodalStrainAbaqusCartesian(i).strainNodal(localIndex).strain_fsn = ksi_car_fsn;
         
    end
    
    nodalStrainAbaqusCartesian(i).fiberStrain = mean(fiberStrain);
%     nodalStrainAbaqusCartesian(i).fiberStrain = mean(fiberStrain);  
    fiberStrainTotal(i) = mean(fiberStrain);
    LogfiberStrainTotal(i) = mean(logFiberStrain);
end


