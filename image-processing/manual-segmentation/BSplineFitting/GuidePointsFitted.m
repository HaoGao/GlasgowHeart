function [XYZEndoFitted, XYZApexEndoFitted, XYZEndoApexT] = GuidePointsFitted(XYZEndo, ...
          XYZEndoApex, nptsu, nptsv, uknot, vknot, kS, alpha0, AH, resultDir)

XYZEndoFitted = XYZEndo;
% XYZEndoApexFitted = XYZEndoApex;
minU = pi/2;

for sliceIndex = 1 : size(XYZEndoFitted,2)
    xcoor = XYZEndoFitted(1,sliceIndex).xcoor;
    ycoor = XYZEndoFitted(1,sliceIndex).ycoor;
    zcoor = XYZEndoFitted(1,sliceIndex).zcoor;
    
    for nodeIndex = 1 : length(xcoor)
        pT = [xcoor(nodeIndex);  ycoor(nodeIndex); zcoor(nodeIndex)];
        pT_pro = getProlateCoordinate(pT, alpha0);
        p_w = FitFuncArbitary(pT_pro(1),pT_pro(2), nptsu, nptsv, uknot, vknot, kS, AH);
        
        u = pT_pro(1);
        v = pT_pro(2);
        w = p_w;
        
        cw=alpha0*cosh(w);
	    sw=alpha0*sinh(w);         	  
		cu=cos(u);
		su=sin(u);
		cv=cos(v);
		sv=sin(v);
		x=sw*cu*cv;
		y=sw*cu*sv;
		z=cw*su;
        
        xcoor(nodeIndex) = x;
        ycoor(nodeIndex) = y;
        zcoor(nodeIndex) = z;
        uvw_u(nodeIndex) = u;
        uvw_v(nodeIndex) = v;
        uvw_w(nodeIndex) = w;
        
        
        if u<minU
            minU = u;
        end
        
    end
    XYZEndoFitted(1,sliceIndex).xcoor = xcoor;
    XYZEndoFitted(1,sliceIndex).ycoor = ycoor;
    XYZEndoFitted(1,sliceIndex).zcoor = zcoor;
    
    XYZEndoFitted(1,sliceIndex).u = uvw_u;
    XYZEndoFitted(1,sliceIndex).v = uvw_v;
    XYZEndoFitted(1,sliceIndex).w = uvw_w;
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
minUP = abs(minU)*180/pi; %%therefore the maximum UP is 90
%%%the output curves will be 4 curves until 85degree
uDivisions = 3;
dU = (80-minUP)/uDivisions;

for apexIndex = 1 : uDivisions
    xcoor = [];
    ycoor = [];
    zcoor = [];
    
    u = -dU*apexIndex - minUP;
    u = u*pi/180;
    vSequence = 0 :0.4: 2*pi-0.3;
    for nodeIndex = 1 : length(vSequence)
        v = vSequence(nodeIndex);
        w = FitFuncArbitary(u,v, nptsu, nptsv, uknot, vknot, kS, AH);
        
        cw=alpha0*cosh(w);
	    sw=alpha0*sinh(w);         	  
		cu=cos(u);
		su=sin(u);
		cv=cos(v);
		sv=sin(v);
		x=sw*cu*cv;
		y=sw*cu*sv;
		z=cw*su;
        
        xcoor(nodeIndex) = x;
        ycoor(nodeIndex) = y;
        zcoor(nodeIndex) = z;
    end
    XYZApexEndoFitted(apexIndex).xcoor = xcoor;
    XYZApexEndoFitted(apexIndex).ycoor = ycoor;
    XYZApexEndoFitted(apexIndex).zcoor = zcoor;
    
    
end




%%%this is for showing the fitted and unfitted boundaries
h3D = figure(); hold on; title('fitted and guided curves'); 

for sliceIndex = 1 : size(XYZEndoFitted,2)
    xcoorFit = XYZEndoFitted(1,sliceIndex).xcoor;
    ycoorFit = XYZEndoFitted(1,sliceIndex).ycoor;
    zcoorFit = XYZEndoFitted(1,sliceIndex).zcoor;
    
    xcoor = XYZEndo(1,sliceIndex).xcoor;
    ycoor = XYZEndo(1,sliceIndex).ycoor;
    zcoor = XYZEndo(1,sliceIndex).zcoor;
    
    figure(h3D); hold on;
    plot3(xcoorFit, ycoorFit, zcoorFit, 'LineStyle', '-', 'LineWidth', 2, 'Color', 'r'); hold on
    plot3(xcoor, ycoor, zcoor, 'LineStyle', '-', 'LineWidth', 2, 'Color', 'b'); hold on;
   
end


% %%%%plot the apex region 
% for ApexIndex = 1 : size(XYZApexEndoFitted,2)
% 
%     xcoor = XYZApexEndoFitted(ApexIndex).xcoor ;
%     ycoor = XYZApexEndoFitted(ApexIndex).ycoor ;
%     zcoor = XYZApexEndoFitted(ApexIndex).zcoor ;
%     
%     figure(h3D); hold on;
%     plot3(xcoor, ycoor, zcoor, 'LineStyle', '-', 'LineWidth', 2, 'Color', 'r'); hold on;
% end


%%%the apex point 
u = -pi/2; v=0.0;
w = FitFuncArbitary(u,v, nptsu, nptsv, uknot, vknot, kS, AH);
cw=alpha0*cosh(w);
sw=alpha0*sinh(w);         	  
cu=cos(u);
su=sin(u);
cv=cos(v);
sv=sin(v);
x=sw*cu*cv;
y=sw*cu*sv;
z=cw*su;

XYZEndoApex.apexFitted(1) = x; 
XYZEndoApex.apexFitted(2) = y; 
XYZEndoApex.apexFitted(3) = z; 

% XYZEndoApex.apexFitted(1) = XYZEndoApex.apex(1); %x; %Chen
% XYZEndoApex.apexFitted(2) = XYZEndoApex.apex(2); %y; %Chen
% XYZEndoApex.apexFitted(3) = XYZEndoApex.apex(3);% z; %Chen


plot3(XYZEndoApex.apex(1),XYZEndoApex.apex(2),XYZEndoApex.apex(3), 'Marker', '*', 'MarkerSize', 4, 'Color', 'b');
plot3(XYZEndoApex.apexFitted(1),XYZEndoApex.apexFitted(2),XYZEndoApex.apexFitted(3), 'Marker', 'o', 'MarkerSize', 4, 'Color', 'r');

axis 'equal';
legend('red: fitted', 'blue: original');

XYZEndoApexT = XYZEndoApex;


