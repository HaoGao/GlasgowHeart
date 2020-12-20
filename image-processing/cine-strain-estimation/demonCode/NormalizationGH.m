%%%%normalization

function v=NormalizationGH(v)

t = length(v);
d = 0;
for i = 1 : t
    d = d + v(i)^2;
end
d = d^0.5;
v=v./d;
