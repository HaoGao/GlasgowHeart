function  [CirStrainLV RadStrainLV] = strianCalculaton(Tx,Ty,LVRoi,shapex,shapey)
[E ~]=strainHG(Tx,Ty);
for i = 1 : size(LVRoi,1)
        for j = 1 : size(LVRoi,2)
              if LVRoi(i,j)>0.5
                  xt = j;
                  yt = i;
                  rvect = NormalizationGH([xt-shapex, yt-shapey]);
                  cvect = [-rvect(2) rvect(1)];
                  Rot = [rvect(1) rvect(2);
                         cvect(1) cvect(2)];
                  Eulr = [E(i,j,1,1), E(i,j,1,2);
                          E(i,j,2,1), E(i,j,2,2)];
                  EulRotated = Rot'*Eulr*(Rot);
                  CirStrainLV(i,j)=(EulRotated(2,2));
                  RadStrainLV(i,j)=EulRotated(1,1);
              else
                  CirStrainLV(i,j)=0;
                  RadStrainLV(i,j)=0;
              end
        end
end