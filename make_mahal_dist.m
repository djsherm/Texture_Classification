function mahal_kmeans = make_mahal_dist(sort_aug_class, mu_vects, k)
%% DOCUMENTATION

% FUNCTION ACCEPTS FEATURE MATRIX, MEAN VECTORS, AND NUMBER OF CLASSES
% FUNCTION CALCULATES THE COVARIANCE MATRIX AND MAHALANOBIS DISTANCE FOR USE IN A CUSTOM
% K-MEANS UNSUPERVISED LEARNING ROUTINE

% FUNCTION CALLS THE FUNCTION find_mahal_dist() TO CALCULATE THE MAHALANOBIS DISTANCE

% MADE BY: DANIEL SHERMAN
% APRIL 2, 2020

%% START OF CODE

[block_num, num_feature] = size(sort_aug_class); %get number of blocks
num_feature = num_feature - 1;
[~,~,iter_num] = size(mu_vects);


%initialize variables to get information on length of classes
class_index = zeros(k + 1, 1);
class_index(1) = 1;
class_index(k + 1) = block_num;
iter = 1;

%get class-changing indexes in the feature matrix
for i = 2:block_num
    if sort_aug_class(i,11,1) ~= sort_aug_class(i - 1,11,1)
        class_index(iter + 1) = i;
        iter = iter + 1;
    end
end

%make covariance matricies for each class
for m = 1:k
     eval(strcat(['cov_mat_mahal(:,:,', num2str(m), ...
         ') = cov(sort_aug_class(class_index(', num2str(m), '):class_index(', num2str(m + 1), ...
         ') - 1, 1:num_feature));']));
end

for i = 1:block_num
    for j = 1:k
        %matrix of squared Mahalanobis distances for each block from each average
        %of each class
        mahal_kmeans(i, j) = sqrt((sort_aug_class(i,1:10, iter_num) - ...
            mu_vects(j,:, iter_num))*inv(cov_mat_mahal(:,:,j))...
            *transpose(sort_aug_class(i,1:10, iter_num) ...
            - mu_vects(j,:, iter_num)));
    end
end

