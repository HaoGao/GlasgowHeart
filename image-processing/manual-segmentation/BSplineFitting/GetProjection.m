function p = GetProjection(pt, a, b, c, d)
t = (-d - a*pt(1)-b*pt(2)- c*pt(3))/(a*a+b*b+c*c);
p(1)=a*t+pt(1);
p(2)=b*t+pt(2);
p(3)=c*t+pt(3);
