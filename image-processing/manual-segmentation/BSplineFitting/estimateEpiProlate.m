function [alpha0, w2] = estimateEpiProlate(P)


N = size(P,2);

z0 = P(3,N);
r0 = 0.0;

for i = 1 : N
    x1 = P(1,i);
    y1 = P(2,i);
    for j = 1 : N
        x2 = P(1,j);
        y2 = P(2,j);
        r = sqrt( (x1-x2)^2 + (y1-y2)^2 );
        if r>r0
            r0 = r;
        end
    end
end

r0 = r0/2;


alpha0 = sqrt(z0*z0 - r0*r0);
t = r0/alpha0;
w2 = log(t + sqrt(1+t*t));
