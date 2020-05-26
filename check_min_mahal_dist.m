function [conf_mat, corr_percent] = check_min_mahal_dist(mahal_dist)
%% DOCUMENTATION

% FUNCTION ACCPETS A MATRIX OF MAHALANOBIS DISTANCES FOR EVERY BLOCK IN THE IMAGE (1024 BLOCKS)
% TO EVERY CLASS (16 CLASSES)
% FUNCTION CHECKS THE MINIMUM MAHALANOBIS DISTANCE AND COUNTS HOW MANY 
% WERE CORRECTLY SORTED IN EACH CLASS
% FUNCTION RETURNS A CONFUSION MATRIX DISPLAYING THE TOTAL NUMBER THAT WERE SORTED CORRECTLY

% MADE BY: DANIEL SHERMAN
% MARCH 27, 2020

%% START OF CODE

%% FIND THE MINIMUM MAHALANOBIS DISTANCE FROM A BLOC TO AN AVERAGE FEATURE IN A CLASS

[blocs, class] = size(mahal_dist);

for i = 1:blocs
    [~, min_index(i)] = min(mahal_dist(i,:));
end

%% BUILD THE CONFUSION MATRIX

conf_mat = zeros(class,class);

for m = 1:class %iterate through the classes
    for n = 1 + (m - 1)*64 : 64 + (m - 1)*64 %iterate in blocks of 64
        switch min_index(n)
            case 1
                conf_mat(m,1) = conf_mat(m,1) + 1;
            case 2
                conf_mat(m,2) = conf_mat(m,2) + 1;
            case 3
                conf_mat(m,3) = conf_mat(m,3) + 1;
            case 4
                conf_mat(m,4) = conf_mat(m,4) + 1;
            case 5
                conf_mat(m,5) = conf_mat(m,5) + 1;
            case 6
                conf_mat(m,6) = conf_mat(m,6) + 1;
            case 7
                conf_mat(m,7) = conf_mat(m,7) + 1;
            case 8
                conf_mat(m,8) = conf_mat(m,8) + 1;
            case 9
                conf_mat(m,9) = conf_mat(m,9) + 1;
            case 10
                conf_mat(m,10) = conf_mat(m,10) + 1;
            case 11
                conf_mat(m,11) = conf_mat(m,11) + 1;
            case 12
                conf_mat(m,12) = conf_mat(m,12) + 1;
            case 13
                conf_mat(m,13) = conf_mat(m,13) + 1;
            case 14
                conf_mat(m,14) = conf_mat(m,14) + 1;
            case 15
                conf_mat(m,15) = conf_mat(m,15) + 1;
            case 16
                conf_mat(m,16) = conf_mat(m,16) + 1;
            otherwise
                error('NUMBER IN MINIMUM MAHALANOBIS DISTANCES THAT SHOULD NOT BE THERE')
        end
    end
end

%% PLOT CONFUSION CHART AND ASSESS CORRECTNESS OF ASSIGNMENTS

figure()
confusionchart(conf_mat)

correct = 0;

for i = 1:class
    correct = correct + conf_mat(i,i);
end

corr_percent = correct/sum(conf_mat, 'all')
