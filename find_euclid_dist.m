function euclid_dist = find_euclid_dist(all_features, all_average, k)
%% DOCUMENTATION

% FUNCTION CALCULATES THE EUCLIDEAN DISTANCE BETWEEN A 
% GIVEN SET OF FEATURE VECTORS AND THE AVERAGE CLASS VECTORS
% FOR USE WITH KMEANS FUNCTIONS

% MADE BY: DANIEL SHERMAN
% MARCH 30, 2020

%% START OF CODE

[block_num, ~] = size(all_features); %get number of blocks
class_num = k; %number of classes

for i = 1:block_num
    for j = 1:class_num
        V = all_features(i,:) - all_average(j,:);
        euclid_dist(i,j) = norm(V*V');
    end
end