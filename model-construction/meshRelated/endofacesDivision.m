function endofacesT = endofacesDivision(endofaces)

endofacesT.S1 = 'S1';
endofacesT.S1faces =[];

endofacesT.S2 = 'S2';
endofacesT.S2faces =[];

endofacesT.S3 = 'S3';
endofacesT.S3faces =[];

endofacesT.S4 = 'S4';
endofacesT.S4faces =[];

endofacesT.S5 = 'S5';
endofacesT.S5faces =[];

endofacesT.S6 = 'S6';
endofacesT.S6faces =[];


for i = 1 : size(endofaces,1)
    if endofaces(i,2) == 1
       endofacesT.S1faces = [endofacesT.S1faces endofaces(i,1)];
    elseif endofaces(i,2) == 2
       endofacesT.S2faces = [endofacesT.S2faces endofaces(i,1)];
    elseif endofaces(i,2) == 3
       endofacesT.S3faces = [endofacesT.S3faces endofaces(i,1)];
    elseif endofaces(i,2) == 4
       endofacesT.S4faces = [endofacesT.S4faces endofaces(i,1)];
    elseif endofaces(i,2) == 5
       endofacesT.S5faces = [endofacesT.S5faces endofaces(i,1)];
    elseif endofaces(i,2) == 6
       endofacesT.S6faces = [endofacesT.S6faces endofaces(i,1)];
    end
end
