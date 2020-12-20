function degreeSpan=degreeReOrder(theta1,theta2)

if abs(theta1-theta2)<180
    degreeSpan.upperBound = max(theta1,theta2);
    degreeSpan.lowerBound = min(theta1,theta2);
    degreeSpan.crossZero = 0;
else
    degreeSpan.upperBound = max(theta1,theta2);
    degreeSpan.lowerBound = min(theta1,theta2);
    degreeSpan.crossZero = 1;
end
