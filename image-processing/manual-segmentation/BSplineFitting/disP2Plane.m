  
%distance between distance and plane 
  
function [dis] = disP2Plane( pt, a, b, c, d)  
  
 dis = abs(a*pt(1)+b*pt(2)+c*pt(3)+d)/sqrt(a*a+b*b+c*c);  
 