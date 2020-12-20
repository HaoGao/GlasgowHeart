function [u, v, w] =  inverseproCoordinate(x, y, z)

a=(1-x*x-y*y-z*z)/2;
t=-a+sqrt(a*a+(x*x+y*y));
s=sqrt(t);
t=s+sqrt(s*s+1);
w=log(t);

s=z/(cosh(w));

if abs(z)<0.00001
    u = 0;
else
    u = asin(s);
end


s=y/(sinh(w)*cos(u));
c=x/(sinh(w)*cos(u));

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
