clear all; close all; clc;
path(path, '../B_slpineRelated');
nptsu = 10;
nptsv = 10;
kS = 4;
kC = kS -1;
Nvs = nptsu-(kS-1);
Nus = nptsu-(kS-1);
yi = 1.0;


u = -pi/2;
uknot = knot_clamped(nptsu, kS, -pi/2, 0.0);
[nbasis, d1, d2] = DbasisFunctions(kS, u, nptsu, uknot);
% [nbasis1] = basisFunction(kS, u, nptsu, uknot);
for i = 1 : kC
    Bu(1,i) = nbasis(i);
    Bu(2,i) = d1(i);
    Bu(3,i) = d2(i);
end
BuINV = inv(Bu);

vknot = knot_Closed(nptsv,kS,0,2*pi);
%%%Bv and BvINV
hv = 2*pi/Nvs;
for k = 1: Nvs
    v = (k-1)*hv;
    Nv = basisFunction(kS, v, nptsv, vknot);
    for j = 1 : Nvs
        Bv(k,j) = Nv(j);
    end
    for j = 1 : kC
        Bv(k,j) = Bv(k,j)+Nv(Nvs+j);
    end
    
    cv = cos(v);
    sv = sin(v);
    CS(1,1) = 1;
    CS(2,2) = cv;
    CS(2,3) = sv;
    CS(3,4) = cv*cv/2;
    CS(3,5) = cv*sv;
    CS(3,6) = sv*sv/2;
    
    tF = BuINV*CS;
    
    for i = 1: kC
        for j = 1 : 6
            FkMat(i,j,k) = tF(i,j);
        end
    end
 
end

BvINV = inv(Bv);


for k = 1 : nptsu
    i0 = (k-1)*nptsu;
    j0 = (k-1)*Nvs;
    for i = 1:Nvs
        j = i;
        ConY(i+i0,j+j0) = yi;
    end
    for j = 1:kC
        i = j + Nvs;
        ConY(i+i0,j+j0) = yi;
    end
end

Trans = [];
for i = 1: Nvs
    k0 = 3*(i-1);
    Trans(i,k0+1) = yi;
    Trans(i+Nvs,k0+2) = yi;
    Trans(i+2*Nvs, k0+3) = yi;
end



%%%BVINVMat
k0 = Nvs;
k1 = 2*Nvs;
for i = 1 : Nvs
    for j = 1 : Nvs
        s = BvINV(i,j);
        BvINVMat(i,j) = s;
        BvINVMat(i+k0,j+k0) = s;
        BvINVMat(i+k1, j+k1) = s;
    end
end

%%%F mat
for i = 1 : kC
    for j = 1 : 6
        for k = 1 : Nvs
            i0 = (k-1)*kC;
            FMat(i+i0,j) = FkMat(i,j,k);
        end
    end
end

tempQ = Trans*FMat;
QS = BvINVMat*tempQ;            


%%GUF matrix
for i = 1 : Nvs*kC
    for j = 1 : 6
        GUF(i,j) = QS(i,j);
    end
end

i0 = Nvs*kC;
j0 = 6;
for i = 1 : Nus*Nvs
    GUF(i+i0,i+j0) = yi;
end

QCon = ConY*GUF;


QCon_fortran = load('QCon.dat');





