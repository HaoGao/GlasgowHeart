function showStrainCurvesOnDifferenceSectionsForOneMiddleSlice(InfSept,AntSept,  Ant,  AntLat,  InfLat, Inf,h)

figure(h); hold on;

plot(InfSept,'r-*');
plot(AntSept,'r-+');
plot(Ant,'b-+');
plot(AntLat,'k-+');
plot(InfLat,'k-*');
plot(Inf,'b-*');
legend('InfSept', 'AntSept',  'Ant',  'AntLat',  'InfLat', 'Inf');

