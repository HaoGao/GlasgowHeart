function [compress_thetas, compress_IDs] = degree_finding_byIDx(degree_idealized,ID_mid_sept_plus_1,ID_rv_anterior_ref)

N = length(degree_idealized);

if (ID_mid_sept_plus_1) > N
    ID_start = ID_mid_sept_plus_1-N;
elseif ID_mid_sept_plus_1<=0
    ID_start = ID_mid_sept_plus_1+N;
else
    ID_start = ID_mid_sept_plus_1;
end

if ID_rv_anterior_ref > N
    ID_end = ID_rv_anterior_ref -N;
elseif ID_rv_anterior_ref <= 0
    ID_end = ID_rv_anterior_ref+N;
else
    ID_end = ID_rv_anterior_ref;
end
    

if ID_end > ID_start %%not cross the first
    compress_IDs = ID_start :1 : ID_end;
elseif ID_end < ID_start
    compress_IDs = [ ID_start:1:N, 1:1:ID_end];
end


compress_thetas  = degree_idealized(compress_IDs);


theta_start = degree_idealized(ID_start);
theta_end = degree_idealized(ID_end);


