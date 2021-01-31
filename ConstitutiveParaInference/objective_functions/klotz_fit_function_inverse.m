function EDV_norm = klotz_fit_function_inverse(press_mmHg)



% press_mmHg = 97*EDV_norm^4 - 135*EDV_norm^3 + 72*EDV_norm^2 - 5*EDV_norm + 0.31;

%since we know EDV_norm is in [0 1], then we should be able to find out for
%a specific pressure, what the EDV_norm will be. 

edvn = 0.01:0.001:1;
for i = 1 : length(edvn)
   edv_t = edvn(i);
   press_p(i) =  97*edv_t^4 - 135*edv_t^3 + 72*edv_t^2 - 5*edv_t + 0.31;
    
end


press_p_diff = abs(press_p - press_mmHg);
[~, k] = min(press_p_diff);
EDV_norm = edvn(k);