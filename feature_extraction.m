function bloc_features = feature_extraction(bloc)
%% DOCUMENTATION

% FUNCTION ACCEPTS AN ARRAY OF BLOCKS (SIZE 16x16)
% FOR EACH BLOCK, FUNCTION CALCULATES THE FOLLOWING:
% MEAN, STANDARD DEVIATION, 
% MEAN MAGNITUDE OF HIGH FREQUENCY REPRESENTATIONS (THETA = 
% 0, 45, 90, 135 BOTH HORIZONTALLY AND VERTICALLY),
% AND SQUARE ROOT OF THE AUTOCORRELATION FOR TAU = 1,4, HORIZONTALLY AND
% VERTICALLY

%% START OF CODE

[row, col, mat] = size(bloc); %size of block
Rxx_h = zeros(mat,4); %initialize horizontal autocorrelation
Rxx_v = zeros(mat,4); %initialize vertical autocorrelation

for i = 1:mat
    bloc_transpose(:,:,i) = bloc(:,:,i)'; %find transpose of 
    %every single matrix in the bloc array
end

bloc_reshape_H = reshape(bloc, 1, row*col, mat);
bloc_reshape_V = reshape(bloc_transpose, 1, row*col, mat);

for k = 1:mat

    %% AVERAGE AND STANDARD DEVIATION

    avg_bloc(k) = mean(bloc(:,:,k), 'all'); %mean grey level

    std_bloc(k) = std(bloc(:,:,k), 1, 'all'); %standard deviation of grey level

    %% MEAN FREQUENCY AT VARYING ANGLES

    mag_bloc(:,:,k) = abs(fftshift(fft2(bloc(:,:,k)))); %frequency domain transform
    mag_0(k) = mean(mag_bloc(5:8, 13:16, k), 'all'); %0 degree average
    mag_45(k) = mean(mag_bloc(1:4, 13:16, k), 'all'); %45 degree average
    mag_90(k) = mean(mag_bloc(1:4, 9:12, k), 'all'); %90 degree average
    mag_135(k) = mean(mag_bloc(1:4, 1:4, k), 'all'); %135 degree average

    %% AUTOCORRELATION

    for tau = 1:4 %iterate for tau vales 1:4
     for m = 1:row*col - tau
          Rxx_h(k, tau) = Rxx_h(k, tau) + bloc_reshape_H(1, m, k)...
              .*bloc_reshape_H(1, m + tau, k); %horizontal autocorrelation
          Rxx_v(k, tau) = Rxx_v(k, tau) + bloc_reshape_V(1, m, k)...
              .*bloc_reshape_V(1, m + tau, k); %vertical autocorrelation
     end
    end

    bloc_features(:,k) = [avg_bloc(k); ... %average pixel value in bloc
     std_bloc(k);... %standard deviation of pixel value in bloc
     mag_0(k);... %mean frequency at 0 degrees
     mag_45(k);... %mean frequency at 45 degrees
     mag_90(k);... %mean frequency at 90 degrees
     mag_135(k);... %mean frequency at 135 degrees
     sqrt(Rxx_h(k, 1));... %horizontal autocorrelation, tau = 1
     sqrt(Rxx_v(k, 1));... %vertical autocorrelation, tau = 1
     sqrt(Rxx_h(k, 4));... %horizontal autocorrelation, tau = 4
     sqrt(Rxx_v(k, 4));].'; %vertical autocorrelation, tau = 4
end

bloc_features = bloc_features.';