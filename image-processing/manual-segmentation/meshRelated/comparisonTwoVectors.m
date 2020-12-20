function diffST = comparisonTwoVectors(v1, v2)

diffST.lenV1 = length(v1);
diffST.lenV2 = length(v2);

v1 = sort(unique(v1));
v2 = sort(unique(v2));

diff_v1 = [];
for i = 1 : length(v1)
    diff_v1(i) = 1;
    for j = 1 : length(v2)
        if v1(i) == v2(j)
            diff_v1(i) = 0;
        end
    end
end

diff_v1_sum = sum(diff_v1);
diffST.diff_v1_sum = diff_v1_sum;
diffST.diff_v1 = diff_v1;
