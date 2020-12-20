function w2 = estimateEpiProlateUsingGlobalAlpha0(P,alpha0_global)


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

if isempty(alpha0_global) || alpha0_global == 0
    alpha0_global = sqrt(z0*z0 - r0*r0);
    disp('alpha0_global is not defined yet');
    stop;
end
t = r0/alpha0_global;
w2 = log(t + sqrt(1+t*t));