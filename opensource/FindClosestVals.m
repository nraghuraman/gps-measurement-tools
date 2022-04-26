function closestValue = FindClosestVals(V, N)
% For each value in V, returns the closest value in N
% Adapted from
% https://www.mathworks.com/matlabcentral/answers/152301-find-closest-value-in-array
N_repeated = repmat(N, [size(V, 1), 1]);
% disp(N_repeated);
V_repeated = repelem(V, size(N, 1), 1);
% disp(V_repeated);
differences = N_repeated - V_repeated;
squared_distances = sum(differences .^ 2, 2); % Uses Euclidian distance
reshaped = reshape(squared_distances, [size(N, 1), size(V, 1)]);
% disp(reshaped);
[~, min_indices] = min(reshaped, [], 1);
closestValue = N(min_indices, :);
