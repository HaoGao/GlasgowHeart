function [n, d1, d2]= DbasisFunctions(c, t, npts, x)
% c Subroutine to generate B-spline basis functions and their derivatives for uniform open knot vectors.
% c
% c	C code for An Introduction to NURBS
% c	by David F. Rogers. Copyright (C) 2000 David F. Rogers,
% c	All rights reserved.
% c	
% c	Name: dbasisu.c
% c	Language: C
% c	Subroutines called: none
% c	Book reference: Section 3.10
% c
% c    b1        = first term of the basis function recursion relation
% c    b2        = second term of the basis function recursion relation
% c    c         = degree of the B-spline basis function (order=c-1)
% c    n[p1]       = array containing the basis functions
% c    d1[p1]      = array containing the derivative of the basis functions
% c    d2[p1]      = array containing the derivative of the basis functions
% c    f1        = first term of the first derivative of the basis function recursion relation
% c    f2        = second term of the first derivative of the basis function recursion relation
% c    f3        = third term of the first derivative of the basis function recursion relation
% c    f4        = fourth term of the first derivative of the basis function recursion relation
% c    npts        = number of defining polygon vertices (including overlapping control points for closed b-spline)
% c    nplusc    = constant -- npts + c -- maximum knot value
% c    s1        = first term of the second derivative of the basis function recursion relation
% c    s2        = second term of the second derivative of the basis function recursion relation
% c    s3        = third term of the second derivative of the basis function recursion relation
% c    s4        = fourth term of the second derivative of the basis function recursion relation
% c    t         = parameter value (sometimes it is u)
% c    temp[]    = temporary array
% c    x[]       = knot vector




% 	integer c,npts, nplusc,i,k
% 	Real*8  x(npts+c),t,n(npts), d1(npts), d2(npts)
    n(1:npts) = 0.0; 
    d1(1:npts) = 0.0;
    d2(1:npts) = 0.0;
% 	Real*8  d,e, b1,b2,f1,f2,f3,f4,s1,s2,s3,s4
% 	Real*8 temp(npts+c), temp1(npts+c),temp2(npts+c)
% 	Real*8 x1,x2,w1,w2,error,ling
% 	Real*8 g1,g2,g11,g12,g21,g22

	ling=0.0;
	error=0.00000001;
	nplusc = npts + c;
    
    
    

% c    zero the temporary arrays 
% 	temp=Dfloat(0)
% 	temp1=Dfloat(0)
% 	temp2=Dfloat(0)
    temp(1:npts+c) = 0.0;
    temp1(1:npts+c) = 0.0;
    temp2(1:npts+c) = 0.0;

% c calculate the first order basis functions n(i) 

% 	Do i=1,nplusc-1
% 	   if(t.ge.x(i). and. t.lt.x(i+1))temp(i)=Dfloat(1)
% 	enddo	
for i=1: nplusc-1
    if t >=x(i) && t < x(i+1)
          temp(i)=1.0;
    end
end
    
    
% c: pick up last point	
% 	if(dabs(t-x(nplusc)).lt.error)then
% 	       temp(npts) = Dfloat(1)
% 	endif	
if abs(t-x(nplusc)) < error
	       temp(npts) = 1.0;
end	

% calculate the higher order basis functions	
% 	Do 1000 k = 2, c
for k = 2 : c
% 	Do 2000 i=1, nplusc-k
    for i = 1 : nplusc-k
    
% c:      if the lower order basis function is zero skip the calculation  
         x1=1/(x(i+k-1)-x(i));
         x2=1/(x(i+k)-x(i+1));
         
         w1=(t-x(i))*x1;
         w2=(x(i+k)-t)*x2;
         
         b1=ling;
         b2=ling;
         f1=ling;
         f2=ling;
         f3=ling;
         f4=ling;
         s1=ling;
         s2=ling;
         s3=ling;
         s4=ling; 
         
         g1=temp(i);
         g2=temp(i+1);
         
         g11=temp1(i);
         g12=temp1(i+1); 
         
         g21=temp2(i);
         g22=temp2(i+1);	
	
	
	
       	    if (abs(g1) >= error)
	        	b1 = w1*g1;
	        	f1 = g1*x1;
            end
            
            
            if (abs(g2) >= error)
	    	    b2 = w2*g2;
	    	    f2 =-g2*x2;
            end
    	    


            if (abs(g11)>= error)
		        f3 = w1*g11;
			    s1 = 2*g11*x1;
            end
		
            if (abs(g12)>= error)
		        f4 = w2*g12;
		        s2 =-2*g12*x2;
            end

            if (abs(g21) >= error) 
                s3 = w1*g21;
            end
            if (abs(g22)>= error) 
                s4 = w2*g22;
            end
	        	
            temp(i)  = b1 + b2;
	        temp1(i) = f1 + f2 + f3 + f4;
	        temp2(i) = s1 + s2 + s3 + s4;
    end %for second 
end %for first
		
% 1000     Continue

% c  put in n array

    	 n(1:npts) = temp(1:npts);
	    d1(1:npts) = temp1(1:npts);
    	d2(1:npts) = temp2(1:npts);
       

            	