function gaussianCoefs = GaussIntegrationPoints(elementType,order)
%%%page 324 and page 158 for quadliteral and hex integration 
if strcmp(elementType, 'Quad4')
    if order == 2
        a =  -5.7735026918962576450914878050196e-01;
        gaussianCoefs.ksi = [-a  a  a  -a];  
        gaussianCoefs.eta = [-a -a  a  a];
        gaussianCoefs.weights = [1.0 1.0 1.0 1.0];
    elseif order == 3
        W = [0.555555555 0.888888889 0.555555555];
        ksi1d = [-0.7745966692 0.0 0.7745966692];
        ksi = zeros([order^2 1]);
        eta = zeros([order^2 1]);
        weights = zeros([order^2 1]);
        for j = 1 : order
            for i = 1 : order
                I = i+(j-1)*order;
                ksi(I) = ksi1d(i);
                eta(I) = ksi1d(j);
                weights(I) = W(i)*W(j);
            end
        end
        gaussianCoefs.ksi = ksi;
        gaussianCoefs.eta = eta;
        gaussianCoefs.weights = weights;
        
    else
        disp('wrong gaussian integration order! using default order');
        gaussianCoefs.ksi = [-0.577 0.577 0-.577 0.577];  
        gaussianCoefs.eta = [-0.577 -0.577 0.577 0.577];
        gaussianCoefs.weights = [1.0 1.0 1.0 1.0];
    end
    
elseif strcmp(elementType, 'Tri3')
    if order == 2 %%also the default order
       gaussianCoefs.ksi = [2/3 1/6 1/6];  
       gaussianCoefs.eta = [1/6 2/3 1/6];
       gaussianCoefs.weights = [1.0/6 1.0/6 1.0/6]; 
    else
       disp('wrong gaussian integration order! using default order');
       gaussianCoefs.ksi = [0.5 0.5 0.0];  
       gaussianCoefs.eta = [0.0 0.5 0.5];
       gaussianCoefs.weights = [1.0/6 1.0/6 1.0/6];
    end
 
    %%%linear line element 
elseif strcmp(elementType, 'Line2')
    if order == 5 %%also the default order
       gaussianCoefs.ksi = [-7.7459666924148337703585307995648e-01 0.0 7.7459666924148337703585307995648e-01];  
       gaussianCoefs.weights = [ 5.5555555555555555555555555555556e-01 8.8888888888888888888888888888889e-01  5.5555555555555555555555555555556e-01]; 
    else
       disp('wrong gaussian integration order! using default order');
       gaussianCoefs.ksi = [-7.7459666924148337703585307995648e-01 0.0 7.7459666924148337703585307995648e-01];  
       gaussianCoefs.weights = [ 5.5555555555555555555555555555556e-01 8.8888888888888888888888888888889e-01  5.5555555555555555555555555555556e-01]; 
    end  
    
    %%%Hex8 element 
elseif strcmp(elementType, 'Hex8')
    if order == 2 %%also the default order
       gc = 1.0/sqrt(3);
       gpcoor=[-gc -gc -gc;
                gc -gc -gc;
                gc  gc -gc;
                -gc  gc -gc;
                -gc -gc  gc;
                gc -gc  gc;
                gc  gc  gc;
                -gc  gc  gc];
       gaussianCoefs.ksi = gpcoor(:,1);
       gaussianCoefs.eta = gpcoor(:,2);
       gaussianCoefs.zeta = gpcoor(:,3);
       gaussianCoefs.weights =[1.0; 1.0; 1.0; 1.0; ...
                               1.0; 1.0; 1.0; 1.0]; 
    else
       disp('wrong gaussian integration order! using default order: 2');
       gc = 1.0/sqrt(3);
       gpcoor=[-gc -gc -gc;
                gc -gc -gc;
                gc  gc -gc;
                -gc  gc -gc;
                -gc -gc  gc;
                gc -gc  gc;
                gc  gc  gc;
                -gc  gc  gc];
       gaussianCoefs.ksi = gpcoor(:,1);
       gaussianCoefs.eta = gpcoor(:,2);
       gaussianCoefs.zeta = gpcoor(:,3);
       gaussianCoefs.weights =[1.0; 1.0; 1.0; 1.0; ...
                               1.0; 1.0; 1.0; 1.0]; 
    end    
    
    
    
end

