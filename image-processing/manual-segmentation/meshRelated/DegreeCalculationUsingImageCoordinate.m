function v = DegreeCalculationUsingImageCoordinate(p_centre,p_start)

% s=y/(sinh(w)*cos(u));
% c=x/(sinh(w)*cos(u));

s0 = p_start(2) - p_centre(2);
c0 = p_start(1) - p_centre(1);
%%normalization
s = s0/(s0^2+c0^2)^0.5;
c = c0/(s0^2+c0^2)^0.5;
if abs(s)<0.00001
    if c>0.1
        v = 0;
    else
        v = pi;
    end
else
    if s >0 
        v = acos(c);
    else
        v = 2*pi - acos(c);
    end
end
