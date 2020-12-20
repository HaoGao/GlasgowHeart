function StrainMapTotal = strainMapCalculation(imData, imgDeformed, endoT, epiT)

totalImageNo = size(imgDeformed,1);
I1Crop = imcrop(imData,imgDeformed(1,1).rect);

LVRoi = roipoly(I1Crop,epiT(:,1),epiT(:,2))-roipoly(I1Crop,endoT(:,1),endoT(:,2));
shapex = mean(endoT(:,1));
shapey = mean(endoT(:,2));

%%%initialization for the first time step
Tx = zeros(size(LVRoi));
Ty = zeros(size(LVRoi));
Displace(1).Tx = Tx;
Displace(1).Ty = Ty;

for i = 1 : size(LVRoi,1)
    for j = 1 : size(LVRoi,2)
        mapij(i,j).i = i;
        mapij(i,j).j = j;
    end
end


for imIndex = 1 : totalImageNo-1
     Tx = imgDeformed(imIndex,1).Tx;
     Ty = imgDeformed(imIndex,1).Ty;

        for i = 1 : size(LVRoi,1)
               for j = 1 : size(LVRoi,2)
                    PreI = mapij(i,j).i;
                    PreJ = mapij(i,j).j;
                    
                    %%%bounds check
                    if round(PreI)<=0 
                        rPreI = 1;
                    elseif round(PreI)>size(LVRoi,1)
                        rPreI = size(LVRoi,1);
                    else
                        %rPreI = round(PreI);
                        rPreI = PreI;
                    end

                    if round(PreJ)<=0 
                        rPreJ = 1;
                    elseif round(PreJ)>size(LVRoi,2)
                        rPreJ = size(LVRoi,2);
                    else
                        %rPreJ = round(PreJ);
                        rPreJ  = PreJ;
                    end    

                   %%%now need to deal with rPreI and rPreJ are not itegers
                   
                   I = floor(rPreI);
                   J = floor(rPreJ);
                   
                   dI = rPreI - I;
                   dJ = rPreJ - J;
                   
                   dI = 2*dI - 1; 
                   dJ = 2*dJ - 1; %%change to be -1 to 1
                   
                   I1 = I+1; 
                   J1 = J+1;
                   
                   %%%bound check
                   if I <1
                       I = 1;
                   end
                   if J<1
                       J = 1;
                   end
                   if I1 > size(LVRoi,1)
                       I1 = size(LVRoi,1);
                   end
                   if J1 > size(LVRoi,2)
                       J1 = size(LVRoi,2);
                   end
                   
                    dxIJ = Tx(I,J);
                    dyIJ = Ty(I,J);

                    dxI1J = Tx(I1,J);
                    dyI1J = Ty(I1,J);

                    dxIJ1 = Tx(I,J1);
                    dyIJ1 = Ty(I,J1);

                    dxI1J1 = Tx(I1,J1);
                    dyI1J1 = Ty(I1,J1);


                   %%%using linear interpolation
                   fIJ  =   1/4.0*(1+dI)*(1+dJ);
                   fI1J =   1/4.0*(1-dI)*(1+dJ);
                   fI1J1 =  1/4.0*(1-dI)*(1-dJ);
                   fIJ1  =  1/4.0*(1+dI)*(1-dJ);

                %     dx = -Ty(i,j);
                %     dy = -Tx(i,j);

                    dx = dxIJ*fIJ + dxI1J*fI1J + fI1J1*dxI1J1 + fIJ1*dxIJ1;
                    dy = dyIJ*fIJ + dyI1J*fI1J + fI1J1*dyI1J1 + fIJ1*dyIJ1;
                   
                   
                   
                   

                    %NowI = PreI - Tx(rPreI, rPreJ);
                    %NowJ = PreJ - Ty(rPreI, rPreJ);
                    NowI = PreI - dx;
                    NowJ = PreJ - dy;
                    Displace(imIndex+1).Tx(i,j)=Displace(imIndex).Tx(i,j)+ dx; %Tx(rPreI, rPreJ);
                    Displace(imIndex+1).Ty(i,j)=Displace(imIndex).Ty(i,j)+ dy; %Ty(rPreI, rPreJ);


                    mapijN(i,j).i = NowI;
                    mapijN(i,j).j = NowJ;
               end
        end
        mapij = mapijN;


        [CirStrainLV RadStrainLV]=strianCalculaton(Displace(imIndex+1).Tx,Displace(imIndex+1).Ty,LVRoi,shapex,shapey);  

        StrainMapTotal(imIndex).CirStrainLV = CirStrainLV;
        StrainMapTotal(imIndex).RadStrainLV = RadStrainLV;
      
end