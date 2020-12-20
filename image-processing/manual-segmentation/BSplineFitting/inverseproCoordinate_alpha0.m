function [u, v, w] = inverseproCoordinate_alpha0(alpha0, x, y, z)

Pi = acos(-1);

    x=x/alpha0;
	y=y/alpha0;
	z=z/alpha0;
	
        a=(1-x*x-y*y-z*z)/2;
	  t=-a+sqrt(a*a+(x*x+y*y));
	  s=sqrt(t);
	  t=s+sqrt(s*s+1);
	  w=log(t);

	  s=z/(cosh(w));
	  if(abs(z)< 0.000001)
	     u=0.0;
      else
	     if(z>0)
             u=asin(s);
         end
	     if(z<0)
             u=asin(s);
         end
      end

        
	  s=y/(sinh(w)*cos(u));
	  c=x/(sinh(w)*cos(u));

        if(abs(s)<0.000001)
	     if(c>0.1)
             v=0.0;
         end
	     if(c<0.1)
             v=Pi;
         end
        else
	     if(s>0)
             v=acos(c);
         end
	     if(s<0)
             v=2*Pi-acos(c);
         end
        end