%% ENGG 4660: MEDICAL IMAGE PROCESSING
% LAB 5: TEXTURE CLASSIFICATION
% DANIEL SHERMAN
% 0954083
% MARCH 23, 2020

%% START OF CODE

close all
clear all
clc

%% LOAD IN FILES

textures = imread('brodatz.tif');
[row, col] = size(textures);

figure()
imshow(textures)

%% SUBDIVIDE INTO CLASSES

for m = 0:3
    for n = 0:3
        eval(strcat(['class', num2str(m + 1), num2str(n + 1), ...
            ' = textures(1 + m*128: 128*(m + 1), 1 + n*128: 128*(n + 1));']));
    end
end

%% SUBDIVIDE A CLASS INTO 16x16 BLOCKS (64 TOTAL PER CLASS)

for m = 0:3
    for n = 0:3
        eval(strcat(['bloc', num2str(1 + m), num2str(1 + n), ...
            ' = double(subdivide_block(class', num2str(1 + m), num2str(1 + n), '));']));
    end
end

%% EXTRACT FEATURE VECTOR FOR EACH BLOCK, AVERAGE FEATURE FOR EACH CLASS, 
% COVARIANCE MATRIX FOR EACH CLASS, AND EIGENVALUES FOR EACH CLASS

for m = 0:3
    for n = 0:3
        %find features for each block (each block's features are a row)
        eval(strcat(['bloc_features', num2str(m + 1), num2str(n + 1), ...
            ' = feature_extraction(bloc', num2str(m + 1), num2str(n + 1), ');']));
        %calculate the average value for each feature in a class
        eval(strcat(['average_feature', num2str(m + 1), num2str(n + 1), ...
            ' = mean(bloc_features', num2str(m + 1), num2str(n + 1), ');']));
        %calculate covariance matrix for each class
        eval(strcat(['cov_mat', num2str(m + 1), num2str(n + 1), ...
            ' = cov(bloc_features', num2str(m + 1), num2str(n + 1), ');']));
        %calculate the sqrare root of eignevalues for each covariance
        %matrix, denoting spread
        eval(strcat(['eigen_cov', num2str(m + 1), num2str(n + 1), ...
            ' = sqrt(eig(cov_mat', num2str(m + 1), num2str(n + 1), '));']));
    end
end


%organize average feature value, covariance matricies, and eigenvalues to
%store the data all together

subdiv = 1;

for m = 0:3
    for n = 0:3
        eval(strcat(['all_average(', num2str(subdiv), ...
            ',:) = transpose(average_feature', num2str(m + 1), num2str(n + 1), ');']));
        eval(strcat(['all_cov(:,:,', num2str(subdiv), ...
            ') = cov_mat', num2str(m + 1), num2str(n + 1), ';']));
        eval(strcat(['all_eig(', num2str(subdiv), ...
            ',:) = transpose(eigen_cov', num2str(m + 1), num2str(n + 1), ');']));
        subdiv = subdiv + 1;
    end
end
    
% 'all_average' is a 16x10 vectors containing the average value of each feature on the column,
% and on the row is each class (row 1 is top left, 
% row 4 is top right, ... row 16 is bottom right class)

% 'all_cov' is the covariance matrix for each class, 10x10 for 
% each feature, and 16 matricies for each class
% (matrix 1 is top left, matrix 4 is top right ... matrix 16 is bottom right class)

% 'all_eig' is a 16x10 vectors containing the eigenvalues 
% for each of the covariance matrix for each class
% row 1 correlates with covariance matrix 1 (top left class), 
% row 4 correlates with covariance matrix 4 (top right matrix),
% row 16 correlates with covariance matrix 16 (bottom right class)

%% CALCULATE THE MAHALANOBIS DISTANCE FOR EVERY BLOCK, FOR EVERY AVERAGE FEATURE VECTOR

mahal_distances = [];

for m = 0:3
    for n = 0:3
        eval(strcat(['mahal_holder = find_mahal_dist(bloc_features', ...
            num2str(m + 1), num2str(n + 1), ', all_average, all_cov);']));
        mahal_distances = [mahal_distances ; mahal_holder];
    end
end

[conf_mat, corr_percent] = check_min_mahal_dist(mahal_distances);
[conf_mat3, corr_percent3] = check_min_mahal_dist_3_classes(mahal_distances, 1, 10, 8);

%% MAKE LARGE MATRIX OF ALL BLOCK FEATURES

all_features = [];

for m = 0:3
    for n = 0:3
        eval(strcat(['all_features = [all_features ; bloc_features', ...
            num2str(m + 1), num2str(n + 1), '];']));
    end
end

%% USING MATLAB FUNCTIONS

id3 = kmeans(all_features, 3);
figure()
silhouette(all_features, id3);
title('k-Means Clustering Done by MATLAB')
xlabel(strcat(['Euclidean Distance Classifier, 3 Classes']))


id8 = kmeans(all_features, 8);
figure()
silhouette(all_features, id8);
title('k-Means Clustering Done by MATLAB')
xlabel(strcat(['Euclidean Distance Classifier, 8 Classes']))

id16 = kmeans(all_features, 16);
figure()
silhouette(all_features, id16);
title('k-Means Clustering Done by MATLAB')
xlabel(strcat(['Euclidean Distance Classifier, 16 Classes']))

%% USING MY_KMEANS

[id_my3] = my_kmeans(all_features, 3, 'Euclidean');
[id_my8] = my_kmeans(all_features, 8, 'Euclidean');
[id_my16] = my_kmeans(all_features, 16, 'Euclidean');

[id_my3ma] = my_kmeans(all_features, 3, 'Mahalanobis');
[id_my8ma] = my_kmeans(all_features, 8, 'Mahalanobis');
[id_my16ma] = my_kmeans(all_features, 16, 'Mahalanobis');