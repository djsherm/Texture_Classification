function mahal_dist = find_mahal_dist(bloc_features, mu_vects, cov_mats)
%% DOCUMENTATION

% FUNCTION CALCULATES THE MAHALANOBIS DISTANCE BETWEEN 1 BLOCK'S FEATURE VECTOR AND THE
% AVERAGE FEATURE VECTOR FOR EACH OF 16 CLASSES
% FUNCTION OUTPUTS THE MAHALANOBIS DISTANCE MATRIX OF 16 DISTANCES FOR 64 CLASSES

% MADE BY: DANIEL SHERMAN
% MARCH 27, 2020

%% START OF CODE

[block_num, ~] = size(bloc_features); %get number of blocks
[~, ~, class_num] = size(cov_mats); %get number of classes

bloc_features = bloc_features.'; %block features down the column
mu_vects = mu_vects.';

for i = 1:block_num
    for j = 1:class_num
        %matrix of squared Mahalanobis distances for each block from each average
        %of each class
        mahal_dist(i, j) = sqrt(transpose((bloc_features(:,i) - ...
            mu_vects(:,j)))*inv(cov_mats(:,:,j))*(bloc_features(:,i) - mu_vects(:,j)));
    end
end
