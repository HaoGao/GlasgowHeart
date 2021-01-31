function [Tx Ty] =BsplineDeformHG(I1, I2, options, Spacing)

%%%bspline function
        [O_trans]=make_init_grid(Spacing,size(I1));
        I1=double(I1); I2=double(I2); O_trans=double(O_trans);
        I1s=imfilter(I1,fspecial('gaussian',[3 3],0.5))+0.001;
        I2s=imfilter(I2,fspecial('gaussian',[3 3],0.5))+0.001;
        optim=struct('Display','iter','GradObj','on','HessUpdate','lbfgs','MaxIter',30,'DiffMinChange',0.03,'DiffMaxChange',1,'TolFun',1e-14,'StoreN',5,'GoalsExactAchieve',0);
        sizes=size(O_trans); O_trans=O_trans(:);

        O_trans = fminlbfgs(@(x)bspline_registration_gradient(x,sizes,Spacing,I1s,I2s,options),O_trans,optim);
        O_trans=reshape(O_trans,sizes);
        Icor=bspline_transform(O_trans,I1,Spacing,3);
        Igrid=make_grid_image(Spacing,size(I1));
        [Igrid,T]=bspline_transform(O_trans,Igrid,Spacing); 
        Tx=T(:,:,1);
        Ty=T(:,:,2);
        
        