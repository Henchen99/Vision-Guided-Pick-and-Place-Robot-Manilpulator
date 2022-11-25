clc
clear
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % This script is to take 1 image of checkerboard %
% % for calibration of the camera. %
% % Requires MATLAB Support Package for USB Webcams %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear all
% close all
% clc
% camList = webcamlist
% % Set up connection to the correct webcam
% cam = webcam(2);
% cam.Resolution = '640x480';
% % Preview video stream
% preview(cam);
% % Wait 10 seconds before taking image to stabilize
% pause(10.0);
% % Acquire snapshot
% img = snapshot(cam);
% % Display image;
% figure,image(img);
% % Save image;
% imwrite(img,'Image0.png');
% % Stop connection
% clear cam

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is to extract the checkerboad points %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc
% General Settings
numImages = 7; % depends on the number of images you have
squareSize = 21; % in millimeters
% Read files
files = cell(1, numImages);
for i = 1:numImages
 files{i} = fullfile(sprintf('Image%d.png', i-1)); %i-1 because images
%numbered from 0 to 6
end
% Display the image at working position
I = imread(files{1});
figure; imshow(I);
title('Image at Working Position');
% Detect the checkerboard corners in the images.
[imagePoints, boardSize] = detectCheckerboardPoints(files);
% Generate the world coordinates of the checkerboard corners in the
% pattern-centric coordinate system, with the upper-left corner at (0,0).
worldPoints = generateCheckerboardPoints(boardSize, squareSize);
X = worldPoints(:,1);
Y = worldPoints(:,2);

X = X(:)';
Y = Y(:)';
phi = zeros(54*2,9); % initialising phi matrix with zeros, each corner point has two rows in the matrix thus we need to double the lines
H = zeros(3,3,7);
% imagePoints2 = zeros(2,54,5);
% imagePoints2(:,54,5) = imagePoints(:,)' ;

%imagePoints=permute(imagePoints,[2 1 3]);
for j = 1:7
    for i = 1:54
        ok = imagePoints(:,:,j);
        x = ok(:,1);
        y = ok(:,2);
        phi(2*i-1,:) = [0 0 0 X(i) Y(i) 1 -y(i) * X(i) -y(i) * Y(i) -y(i)];
        phi(2*i,:) = [X(i) Y(i) 1 0 0 0 -x(i) * X(i) -x(i) * Y(i) -x(i)];

    end % forming phi matrix
   % H(:,j) = svd(phi);
   [U,S,V] = svd(phi);
   H(1, 1:3, j) = V(1:3, 9);
   H(2, 1:3, j) = V(4:6, 9);
   H(3, 1:3, j) = V(7:9, 9);
   
end

for i = 1:7
    h11 = H(1,1,i);
    h12 = H(1,2,i);
    h21 = H(2,1,i);
    h22 = H(2,2,i);
    h31 = H(3,1,i);
    h32 = H(3,2,i);
    
    v12T = [h11 * h12 h21 * h12 + h11 * h22 h21 * h22 h31 * h12 + h11 * h32 h31 * h22 + h21 * h32 h31 * h32];
    v11T = [h11 * h11 h21 * h11 + h11 * h21 h21 * h21 h31 * h11 + h11 * h31 h31 * h21 + h21 * h31 h31 * h31];
    v22T = [h12 * h12 h22 * h12 + h12 * h22 h22 * h22 h32 * h12 + h12 * h32 h32 * h22 + h22 * h32 h32 * h32];
    
    V1(2*i - 1, :) = v12T;
    V1(2*i , :) = v11T - v22T;

end
 
    [U1,S1,V2] = svd(V1);

    b11 = V2(1,6);
    b12 = V2(2,6);
    b22 = V2(3,6);
    b13 = V2(4,6);
    b23 = V2(5,6);
    b33 = V2(6,6);

    y0 = (b12 * b13 - b11 * b23) / (b11 * b22 - b12^2);
    lambda = b33 - (b13^2 + y0 * (b12 * b13 - b11 * b23)) / b11;
    alpha = sqrt(lambda / b11);
    beta = sqrt((lambda * b11) / (b11 * b22 - b12^2));
    gamma = -(b12 * alpha^2 * beta) / lambda;
    x0 = (gamma * y0) / alpha - (b13 * alpha^2) / lambda;

    K = [alpha gamma x0; 0 beta y0; 0 0 1];
for m = 1:7
    
    h1 = H(:,1,m);
    h2 = H(:,2,m);
    h3 = H(:,3,m);
    
    sigma = 1/norm(inv(K)*h1);
    r1 = sigma * inv(K) * h1;
    r2 = sigma * inv(K) * h2;
    r3 = cross(r1, r2);
    CPWorg = sigma * inv(K) * h3;
    finalParameters(:,:,m) = [r1 r2 r3 CPWorg];
end

%rotation and translation for each image to compare results
Tcw_Lab = finalParameters(:,:,1);

K_Lab = K;

save('Tcw_lab.mat','Tcw_Lab')

save('K_lab.mat','K')
