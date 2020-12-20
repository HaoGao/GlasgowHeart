function [ID_rv_anterior_ref, ID_rv_inferior_ref] = adjust_rv_interstion_symmetric(ID_rv_anterior_ref,...
                                                     ID_rv_inferior_ref,ID_mid_sept_ref)

if ID_rv_anterior_ref < ID_rv_inferior_ref
    temp = ID_rv_inferior_ref;
    ID_rv_inferior_ref = ID_rv_anterior_ref;
    ID_rv_anterior_ref = temp;
    disp('ID_rv_anterior is less than ID_rv_inferior, be caution!!!')
end
if ID_rv_anterior_ref > ID_rv_inferior_ref
    if ID_rv_anterior_ref - ID_mid_sept_ref > ID_mid_sept_ref - ID_rv_inferior_ref
       ID_rv_inferior_ref = ID_mid_sept_ref - (ID_rv_anterior_ref - ID_mid_sept_ref);
    elseif ID_rv_anterior_ref - ID_mid_sept_ref < ID_mid_sept_ref - ID_rv_inferior_ref
        ID_rv_anterior_ref = ID_mid_sept_ref + (ID_mid_sept_ref - ID_rv_inferior_ref);
    end
        
end