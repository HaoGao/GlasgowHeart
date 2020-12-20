% clear all; close all; clc;

function [xycoor, hpts]=defineBoundaryByimpoint(imData, bc_data, closeB)

% im = imread('Screen Shot 2017-08-16 at 11.03.16 PM.png');

fig = figure;
imshow(imData,[]); 
%%then we can plot bc_data 
if ~isempty(bc_data)
    hold on;
    plot(bc_data(1,:), bc_data(2,:), 'r-', 'LineWidth', 2);
end


pos_fig = get(gcf,'Position');

%imSize = size(im);
pos_tb1 = [20, pos_fig(2)+pos_fig(4)/2, 60, 20];
tb1 = uicontrol(fig, 'Style', 'togglebutton', 'String', 'Stop', ...
                 'Position', pos_tb1, 'BackgroundColor','green');
pos_tb1 = tb1.Position;
pos_tb2 = [pos_tb1(1), pos_tb1(2)-2*pos_tb1(4), pos_tb1(3),  pos_tb1(4)];

tb2 = uicontrol(fig, 'Style', 'pushbutton', 'String', 're-plot', ...
                'Position', pos_tb2, 'BackgroundColor','green',...
                'Callback', @replot);
            

pIndex = 0;
while tb1.Value==0
  pIndex = pIndex + 1;  
  hpts(pIndex).h = impoint(gca);
end

xycoor = zeros([2, pIndex]);

figData.ptlist = hpts;
figData.hfig = fig;
figData.pIndex = pIndex;
%figData.hcurve = hfig;


%%press anykey twice to return to the main function
      w = waitforbuttonpress;
      while w==0
          w = waitforbuttonpress;
      end
      %%update the xycoor
      xycoor(1,:) = xcoor';
      xycoor(2,:) = ycoor';
      hpts = hptsT;
      close(fig);

    % Create Nested Callback Functions (Programmatic Apps)
    function replot(hObject,eventdata)
        
        %%delete the old curve
        if isfield(figData, 'hcurve')
            delete(figData.hcurve);
        end
        
        %plot the new curve
        hptsT = figData.ptlist ;
        pIndexT = figData.pIndex;
        
        xcoor = [];
        ycoor = [];
        
        for i = 1 : pIndexT
            pos = getPosition(hptsT(i).h);
            xcoor(i,1) = pos(1);
            ycoor(i,1) = pos(2);
        end
        
        %%reinterpolate with spline to have a better curve
        if closeB 
            tt = 1:0.1:pIndexT+1;
            t = 1 : pIndexT+1;
            xx = spline(t, [xcoor' xcoor(1)], tt);
            yy = spline(t, [ycoor', ycoor(1)], tt);
        else
            tt = 1:0.1:pIndexT;
            t = 1 : pIndexT;
            xx = spline(t, xcoor', tt);
            yy = spline(t, ycoor', tt);
            
        end

        figure(figData.hfig); hold on;
        %hcurve = plot([xcoor' xcoor(1)], [ycoor', ycoor(1)], 'g-', ...
        %    'LineWidth',2);
        
        hcurve = plot(xx, yy, 'g-', ...
            'LineWidth',2);

        % for i = 1 : pIndex
        %     uistack(hpts(i).h, 'top');
        % end


         uistack(hcurve,'bottom');
         uistack(hcurve,'up',1);
         figData.hcurve = hcurve;
         figData.ptlist = hptsT;
        % uistack(fig, 'bottom');
        
        
        %%update the xycoor
        xycoor(1,:) = xcoor';
        xycoor(2,:) = ycoor';
        
    end

end





%  delete(hcurve)


