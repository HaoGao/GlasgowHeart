function [fiberStrain, disT]= strainCalculationFromNodalDisplacements(abaqus_dis_out_filename,abaqusDir,node,elem, fiberDir, sheetDir, using_fsn)

workingDir = pwd();
cd(abaqusDir);
dis = load(abaqus_dis_out_filename); 
cd(workingDir);

disT(:,1:3) = dis(:, 2:4); 

nodeDef = node + disT;
fiberStrain = zeros([size(elem,1) 1]);

I = [1 0 0; 0 1 0 ; 0 0 1];
for elemIndex = 1 : size(elem,1)
    nodeSequence = elem(elemIndex,:);
    node_0 =  node(nodeSequence,:);
    node_1 =  nodeDef(nodeSequence,:);
    
    f = fiberDir(elemIndex,2:4);
    s = sheetDir(elemIndex,2:4);
    
    f = NormalizationVec(f);
    s = NormalizationVec(s);
    n = cross(f,s);
    
    if ~using_fsn
        node_0_c = mean(node_0);
        node_1_c = mean(node_1);

        v_r = node_1_c - [0 0 node_1_c(3)];
        v_r = NormalizationVec(v_r);
        v_c = cross([0 0 -1], v_r);


        f = v_c;
        s = v_r; 
        n = cross(f,s);
    end
    
    
%     Ux =    disT(nodeSequence,1);
%     Uy =    disT(nodeSequence,2);
%     Uz =    disT(nodeSequence,3);
%    
%     xcoor = nodeDef(nodeSequence, 1);
%     ycoor = nodeDef(nodeSequence, 2);
%     zcoor = nodeDef(nodeSequence, 3);
%     
%     if size(xcoor,1)>1
%             xcoor = xcoor'; %%%row vector
%             ycoor = ycoor';
%             zcoor = zcoor';
%             Ux = -Ux';
%             Uy = -Uy';
%             Uz = -Uz';
%     end
% 
%     EfsnQp= calculate_gradient(xcoor, ycoor, zcoor,Ux, Uy, Uz, f, s, n);
%     
%     Efsn = zeros([3 3]);
%     for i = 1 : length(nodeSequence)
%         Efsn = Efsn + EfsnQp(i,1).Efsn;
%     end
    
    %%%now define the F is based on node_1,
    node_0(:,1) = node_0(:,1) - node_0(1,1);
    node_0(:,2) = node_0(:,2) - node_0(1,2);
    node_0(:,3) = node_0(:,3) - node_0(1,3);
    node_0 = node_0';
    
    node_1(:,1) = node_1(:,1) - node_1(1,1);
    node_1(:,2) = node_1(:,2) - node_1(1,2);
    node_1(:,3) = node_1(:,3) - node_1(1,3);
    node_1 = node_1';
    
    F = node_0/node_1;
    E = 1/2*(F'*F-I);
    
    
    
    R = [f(1) f(2) f(3); 
         s(1) s(2) s(3);
         n(1) n(2) n(3)];
     
     Efsn = R*E*R';
     
     fiberStrain(elemIndex) = Efsn(1,1);
     
    
%      if(Efsn(1,1) > 0)
%          hf = figure;
%          cube_plot( node_0, f, 'b', hf);
%          cube_plot( node_1, f, 'r', hf)
%          pause;
%          close(hf);
%      end
     
     
    
end


% %%%output strain for check
% if 1
%     
%     
% end
