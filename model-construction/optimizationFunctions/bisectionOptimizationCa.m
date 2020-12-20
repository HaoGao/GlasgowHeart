function ResRecord = bisectionOptimizationCa(C_a0, C_a1, C_b, options)

endDiastoleLVVolumeObj = options.endDiastoleLVVolumeObj;
eplsion = options.eplsion;
maxIteration = options.maxIterationBisection;

iter = 1;
while iter<maxIteration
      C_a = (C_a0 + C_a1)/2;
      
      %%%call abaqus 
      %%%call once abaqus with lower bound C_a
      ResRecord_iter = LVVolumeObj_CaCb(C_a, C_b, options);
      C_a = ResRecord_iter.C_a; 
      C_b = ResRecord_iter.C_b;
      vol_changes = ResRecord_iter.vol;
      SuccessB = ResRecord_iter.SuccessB;
        %%%done with abaqus calling
        %%disp the result
      iter = iter + 1;
      strDisp = sprintf('iter:  %d;  C_b:  %f; C_a:  %f; vol_ED:  %f', iter, C_b, C_a, vol_changes(2));
      disp('.............bisection..........................\n');
      disp(strDisp);
      disp('................................................\n');
      %%%output the result for each time step
      ResRecord.C_a(iter) = C_a;
      ResRecord.C_b(iter) = C_b;
      ResRecord.vol(iter,:) = vol_changes;
      ResRecord.SuccessB(iter) = SuccessB;
      
      targetDiffIter = abs(vol_changes(2)-endDiastoleLVVolumeObj)/endDiastoleLVVolumeObj;
      if targetDiffIter < eplsion
          ResRecord.FoundCaB(iter) = 1;
          break;
      else
          if vol_changes(2) > endDiastoleLVVolumeObj
              C_a0 = C_a;
          else
              C_a1 = C_a;
          end
        ResRecord.FoundCaB(iter) = 0;
      end    
end



