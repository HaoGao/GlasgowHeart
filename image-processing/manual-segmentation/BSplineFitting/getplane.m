%Get Plane equation from three points p1 p2 p3: ax+by+cz+d=0;   
function [a, b, c, d] = getplane(p1,p2,p3)  
 
    a = ( (p2(2)-p1(2))*(p3(3)-p1(3))-(p2(3)-p1(3))*(p3(2)-p1(2)) );  
  
    b = ( (p2(3)-p1(3))*(p3(1)-p1(1))-(p2(1)-p1(1))*(p3(3)-p1(3)) );  
  
    c = ( (p2(1)-p1(1))*(p3(2)-p1(2))-(p2(2)-p1(2))*(p3(1)-p1(1)) );  
  
    d = ( 0-(a*p1(1)+b*p1(2)+c*p1(3)) );  
 
  
