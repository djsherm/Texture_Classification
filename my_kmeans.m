function [idx] = my_kmeans(all_features,k, distance)
%% DOCUMENTATION

% TRYING TO EMULATE MATLAB'S KMEANS() FUNCTION
% FUNCTION ACCEPTS A FEATURE MATRIX, NUMBER OF CLASSES K, AND A STRING
% DECLARING WHAT TYPE OF DISTANCE CLASSIFIER IS DESIRED 
%(ONLY EUCLIDEAN AND MAHALANOBIS ARE SUPPORTED)

% MADE BY: DANIEL SHERMAN
% MARCH 30,2020

%% START OF CODE

[num_bloc, num_feature] = size(all_features); 
%getting size, n is number of blocks, p is number of features

idx_rand = randi(k, num_bloc, 1); %assign initial blocks to random classes

%% SPLIT INTO k CLASSES

feat_aug_class(:,:,1) = [all_features idx_rand]; 
%augment the feature matrix with the randomly assigned classes

sort_aug_class(:,:,1) = sortrows(feat_aug_class, [11 1:10]); 
%sort rows by ascending class column (group classes together)

%initialize variables to get information on length of classes
class_index = zeros(k + 1, 1);
class_index(1) = 1;
class_index(k + 1) = num_bloc;
iter = 1;

%get class-changing indexes in the feature matrix
for i = 2:num_bloc
    if sort_aug_class(i,11,1) ~= sort_aug_class(i - 1,11,1);
        class_index(iter + 1) = i;
        iter = iter + 1;
    end
end

%% FIND INITIAL AVERAGES

for i = 1:k
    eval(strcat(['mu(', num2str(i), ...
        ', 1:num_feature, 1) = mean(all_features(class_index(', ...
        num2str(i), '):class_index(', num2str(i + 1), ') - 1, 1:num_feature));']));
end

%% CALCULATE EUCLIDEAN DISTANCE FROM BLOCK TO EACH AVERAGE, AND REASSIGN CLASSES

count = 2;

dummy_check = 0;

tic
while dummy_check == 0

    %calculates euclidean distance from each block's feature vector to each
    %average
    
    switch distance
        case 'Euclidean'
            euclid_dist = find_euclid_dist(all_features(:,1:num_feature), mu(:,:,count - 1), k);
        case 'Mahalanobis'
            for i = 1:k
                cov_mat(:,:,i) = cov(sort_aug_class(class_index(i):class_index(i+1), ...
                    1:num_feature));
            end
            euclid_dist = find_mahal_dist(sort_aug_class(:,1:num_feature), ...
                mu(:,:, count - 1), cov_mat);
        otherwise
            error('That distance type is not supported')
    end
    


    %determine the minimum distance from a bloc to the class average
    for i = 1:num_bloc
        [~, min_index(i)] = min(euclid_dist(i,:));
    end

    feat_aug_class(:,11, count) = min_index(:).'; 
    %augment the organized features with the newly calculated classes
    feat_aug_class(:, 1:10, count) = feat_aug_class(:, 1:10, count - 1); 
    %carry over features from previous iterations
    sort_aug_class(:,:, count) = sortrows(feat_aug_class(:,:, count), [11 1:10]); 
    %sort by new classification

    %get class-changing indexes in the feature matrix
    for i = 2:num_bloc
        if sort_aug_class(i,11, count) ~= sort_aug_class(i - 1,11, count);
            class_index(iter) = i;
            iter = iter + 1;
        end
    end

    for i = 1:k
        eval(strcat(['mu(', num2str(i), ', 1:num_feature,' , ...
            num2str(count), ') = mean(sort_aug_class(class_index(', ...
            num2str(i), '):class_index(', num2str(i + 1), ') - 1, 1:num_feature));']));
    end

    dummy_check = isempty(find(sort_aug_class(:,:,count) - sort_aug_class(:,:, count - 1)));
    count = count + 1

end %while loop
toc

figure()
silhouette(sort_aug_class(:,1:10,count - 1), sort_aug_class(:,11,count - 1))
title('Custom k-Means Clustering Routine')
ylabel(strcat(['Converged on Iteration ', num2str(count - 1)]))
xlabel(strcat([distance, ' Distance Classifier, ', num2str(k), ' Classes']))

idx = sort_aug_class(:,11, count - 1);
