function [C_aArray,C_bArrya,objksivol, ind, Ca, Cb] = PostSweepCaCb(ResRecord,endDiastole)

CaSize = size(ResRecord,1);
CbSize = size(ResRecord,2);

for ca_ind = 1 :  CaSize
    for cb_ind = 1 : CbSize
        C_aArray(ca_ind,cb_ind) = ResRecord(ca_ind, cb_ind).C_a;
        C_bArrya(ca_ind,cb_ind) = ResRecord(ca_ind, cb_ind).C_b;
        vol(ca_ind, cb_ind) = ResRecord(ca_ind, cb_ind).vol;
        objksivol(ca_ind, cb_ind) = ResRecord(ca_ind, cb_ind).objksivol;
        objksivol_nonnorm(ca_ind, cb_ind) = abs(endDiastole-vol(ca_ind, cb_ind))^2 + ...
            objksivol(ca_ind, cb_ind)^2 ;
        %- ((endDiastole-vol(ca_ind, cb_ind))/endDiastole)^2
    end
end


%%will not use the most boundary values
maxObj = max(max(objksivol_nonnorm));
for ca_ind = 2 :  CaSize-1
    for cb_ind = 2 : CbSize-1
        if objksivol_nonnorm(ca_ind, cb_ind) < maxObj
%             maxObj_t = objksivol_nonnorm(ca_ind, cb_ind);
            ind = [ca_ind cb_ind];
            Ca_t = ResRecord(ca_ind, cb_ind).C_a;
            Cb_t = ResRecord(ca_ind, cb_ind).C_b;
                 if Ca_t <= Cb_t
                    maxObj = objksivol_nonnorm(ca_ind, cb_ind);
                    Ca = Ca_t;
                    Cb = Cb_t;
                 end
        end
        
    end
end




figure;
hold on;
surf(C_aArray,C_bArrya,objksivol_nonnorm);
% xlabel('C_b', 'FontSize', 18);
% ylabel('C_a', 'FontSize', 18);
% title('volume + strain');


 hold on;
contour(C_aArray,C_bArrya,objksivol_nonnorm,20);
xlabel('C_b', 'FontSize', 18);
ylabel('C_a', 'FontSize', 18);
title('volume + strain');


% figure; hold on;
% contour(C_aArray,C_bArrya,objksivol,20);
% xlabel('C_b', 'FontSize', 18);
% ylabel('C_a', 'FontSize', 18);
% title('strain');





