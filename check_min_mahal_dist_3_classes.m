function [conf_mat3, corr_percent] = check_min_mahal_dist_3_classes(mahal_dist, c1, c2, c3)
%% DOCUMENTATION

% FUNCTION ACCPETS A MATRIX OF MAHALANOBIS DISTANCES FOR EVERY BLOCK IN THE IMAGE (1024 BLOCKS)
% TO EVERY CLASS (16 CLASSES)
% FUNCTION ALSO ACCEPTS THE CHOICE OF 3 CLASSES
% FUNCTION CHECKS THE MINIMUM MAHALANOBIS DISTANCE AND COUNTS 
% HOW MANY WERE CORRECTLY SORTED IN EACH CLASS
% FUNCTION RETURNS A CONFUSION MATRIX DISPLAYING THE TOTAL NUMBER THAT WERE
% SORTED CORRECTLY FOR 3 CLASSES

% MADE BY: DANIEL SHERMAN
% MARCH 30, 2020

%% START OF CODE

%% CHOOSE OUT CLASSES

parse_mahal = [mahal_dist(1:64, c1), mahal_dist(1:64, c2), mahal_dist(1:64, c3); ...
    mahal_dist(65:128, c1), mahal_dist(65:128, c2), mahal_dist(65:128, c3); ...
    mahal_dist(449:512, c1), mahal_dist(449:512, c2), mahal_dist(449:512,c3)];

%% FIND THE MINIMUM MAHALANOBIS DISTANCE FROM A BLOC TO AN AVERAGE FEATURE IN A CLASS

[blocs, class] = size(parse_mahal);

for i = 1:blocs
    [~, min_index(i)] = min(parse_mahal(i,:));
end

%% BUILD THE CONFUSION MATRIX

conf_mat3 = zeros(class, class);

for m = 1:class %iterate through the classes
    for n = 1 + (m - 1)*64 : 64 + (m - 1)*64 %iterate in blocks of 64
        switch min_index(n)
            case 1
                conf_mat3(m,1) = conf_mat3(m,1) + 1;
            case 2
                conf_mat3(m,2) = conf_mat3(m,2) + 1;
            case 3
                conf_mat3(m,3) = conf_mat3(m,3) + 1;
            otherwise
                error('NUMBER IN MINIMUM MAHALANOBIS DISTANCES THAT SHOULD NOT BE THERE')
        end
    end
end

%% PLOT CONFUSION CHART AND ASSESS CORRECTNESS OF ASSIGNMENTS

figure()
confusionchart(conf_mat3, [c1, c2, c3])

correct = 0;

for i = 1:class
    correct = correct + conf_mat3(i,i);
end

corr_percent = correct/sum(conf_mat3, 'all')