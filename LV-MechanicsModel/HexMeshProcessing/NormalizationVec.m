%%% Normalization of a vector
function v=NormalizationVec(v)
d=0;
for i = 1 : length(v)
    d = d + v(i)^2;
end
d = d^0.5;
v=v./d;