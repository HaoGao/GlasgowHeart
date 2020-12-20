  
% get normal vector of plane using three points
function [v] = getNormal(p1,p2,p3)  
 
    a = (p2(2)-p1(2))*(p3(3)-p1(3))-(p2(3)-p1(3))*(p3(2)-p1(2));  
  
    b =  (p2(3)-p1(3))*(p3(1)-p1(1))-(p2(1)-p1(1))*(p3(3)-p1(3)) ;  
  
    c =  (p2(1)-p1(1))*(p3(2)-p1(2))-(p2(2)-p1(2))*(p3(1)-p1(1)) ;  
  
    v =[a b c];  
  

