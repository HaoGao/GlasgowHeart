function [Tx, Ty, M] = demon_extendedForce(S, M, opt)
I1 = M;
Tx=zeros(size(M)); Ty=zeros(size(M));


Hsmooth = opt.Hsmooth ;
alpha = opt.alpha;
itern = opt.itern ;


[Sy,Sx] = gradient(S);
for itt=1:itern
	    % Difference image between moving and static image
        Idiff=M-S;

        % Default demon force, (Thirion 1998)
        %Ux = -(Idiff.*Sx)./((Sx.^2+Sy.^2)+Idiff.^2);
        %Uy = -(Idiff.*Sy)./((Sx.^2+Sy.^2)+Idiff.^2);

        % Extended demon force. With forces from the gradients from both
        % moving as static image. (Cachier 1999, He Wang 2005)
        [My,Mx] = gradient(M);
        Ux = -Idiff.*  ((Sx./((Sx.^2+Sy.^2)+alpha^2*Idiff.^2))+(Mx./((Mx.^2+My.^2)+alpha^2*Idiff.^2)));
        Uy = -Idiff.*  ((Sy./((Sx.^2+Sy.^2)+alpha^2*Idiff.^2))+(My./((Mx.^2+My.^2)+alpha^2*Idiff.^2)));
 
        %%%itk symmetry in the force calculation during each iteration
        Gx = Sx + Mx;
        Gy = Sy + My;
%         Ux = -Idiff.*  ((Sx./((Gx.^2+Gy.^2)+alpha^2*Idiff.^2))+(Mx./((Gx.^2+Gy.^2)+alpha^2*Idiff.^2)));
%         Uy = -Idiff.*  ((Sy./((Gx.^2+Gy.^2)+alpha^2*Idiff.^2))+(My./((Gx.^2+Gy.^2)+alpha^2*Idiff.^2)));
        
        
        % When divided by zero
        Ux(isnan(Ux))=0; Uy(isnan(Uy))=0;

        % Smooth the transformation field%%% this is the fluid like
        % regularizations u<-- K_fluid * u where K_fluid is a Gaussian conv
        Uxs=3*imfilter(Ux,Hsmooth);
        Uys=3*imfilter(Uy,Hsmooth);

        % Add the new transformation field to the total transformation field.
        Tx=Tx+Uxs;
        Ty=Ty+Uys;
%         M=movepixels(I1,Tx,Ty); 
        M = iminterpolate(I1,Tx,Ty);
end


