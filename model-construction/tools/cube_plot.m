function cube_plot( node, f, colorspec, hf)
figure(hf); hold on;

line( [node(1,1) node(1,2)], [node(2,1) node(2,2)],[node(3,1) node(3,2)], 'Color', colorspec);
line( [node(1,2) node(1,3)], [node(2,2) node(2,3)],[node(3,2) node(3,3)], 'Color', colorspec);
line( [node(1,3) node(1,4)], [node(2,3) node(2,4)],[node(3,3) node(3,4)], 'Color', colorspec);
line( [node(1,1) node(1,4)], [node(2,1) node(2,4)],[node(3,1) node(3,4)], 'Color', colorspec);


line( [node(1,5) node(1,6)], [node(2,5) node(2,6)],[node(3,5) node(3,6)], 'Color', colorspec);
line( [node(1,6) node(1,7)], [node(2,6) node(2,7)],[node(3,6) node(3,7)], 'Color', colorspec);
line( [node(1,7) node(1,8)], [node(2,7) node(2,8)],[node(3,7) node(3,8)], 'Color', colorspec);
line( [node(1,5) node(1,8)], [node(2,5) node(2,8)],[node(3,5) node(3,8)], 'Color', colorspec);


line( [node(1,1) node(1,5)], [node(2,1) node(2,5)],[node(3,1) node(3,5)], 'Color', colorspec);
line( [node(1,2) node(1,6)], [node(2,2) node(2,6)],[node(3,2) node(3,6)], 'Color', colorspec);
line( [node(1,3) node(1,7)], [node(2,3) node(2,7)],[node(3,3) node(3,7)], 'Color', colorspec);
line( [node(1,4) node(1,8)], [node(2,4) node(2,8)],[node(3,4) node(3,8)], 'Color', colorspec);


line([0 0], [0 0], [0 -1]);

if ~isempty(f)
   line([0 f(1)], [0 f(2)], [0 f(3)], 'Color', 'k');
end
   