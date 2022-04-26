function closestValue = FindClosestVals(V, N)
% For each value in V, returns the closest value in N
% Adapted from
% https://www.mathworks.com/matlabcentral/answers/152301-find-closest-value-in-array
% [~, closestIndex] = min(abs(N - V.'));
% closestValue = N(closestIndex);
A = repmat(N,[1 length(V)]);
disp(abs(A-V'));
[minValue,closestIndex] = min(abs(A-V'));
disp(A);
closestValue = N(closestIndex) ;
