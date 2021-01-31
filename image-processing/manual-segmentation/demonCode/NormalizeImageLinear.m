%%%%normalize image for I1 and I2 range from 0 to 1

function [I1Nor I2Nor] = NormalizeImageLinear(I1, I2)

I1 = double(I1);
I2 = double(I2);
minI1 = min(min(I1));
maxI1 = max(max(I1));
minI2 = min(min(I2));
maxI2 = max(max(I2));

minI12 = min([minI1 minI2]);
maxI12 = max([maxI1 maxI2]);

for i = 1 : size(I1, 1)
    for j = 1 : size(I1,2)
        I1Nor(i,j) = (I1(i,j)-minI12)/(maxI12-minI12);
        I2Nor(i,j) = (I2(i,j)-minI12)/(maxI12-minI12);
    end
end
