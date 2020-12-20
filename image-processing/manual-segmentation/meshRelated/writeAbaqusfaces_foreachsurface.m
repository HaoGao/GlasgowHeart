function writeAbaqusfaces_foreachsurface(abaqusFiberDir,workingDir, fileExeMid,  str, faces)
%%%this is for function code
    cd(abaqusFiberDir);
    fileName = sprintf('%s%s.txt', fileExeMid,str);
    fid = fopen(fileName,'w');
    cd(workingDir);
    
%     for i = 1 : length(faces)
%         if i< length(faces)
%             fprintf(fid, '%d,\t', faces(i));
%             if mod(i,16) == 0
%                 fseek(fid, 1, 'cof');
%                 fprintf(fid, '\n');
%             end
%             
%         else
%             fprintf(fid,'%d\n', faces(i));
%         end
%     end
      facesLength = length(faces);
      rows = floor(facesLength/16);
    %   facesIndex = 0;
      for i = 1 : rows
         for j = 1 : 15
             facesIndex = (i-1)*16 + j; 
             fprintf(fid, '%d,\t', faces(facesIndex));
         end
            facesIndex = (i-1)*16 + 16;
            fprintf(fid, '%d\n', faces(facesIndex));
      end
      %%%the last row
      if facesIndex < facesLength
          if facesLength-facesIndex>1
              for i = facesIndex+1: facesLength-1
                  fprintf(fid, '%d,\t', faces(i));
              end
                 i = i+1;
                 fprintf(fid, '%d\n', faces(i));
          else
              fprintf(fid, '%d\n', faces(facesIndex+1));
          end
      end


    
    fclose(fid);
    
    
    %%%need to get rid of the ',' in each line at the end