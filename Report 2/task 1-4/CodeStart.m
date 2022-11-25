clear all
close all
clc

%%%%%%%%%%%%%%%%%
% Corner Points %
%%%%%%%%%%%%%%%%%

% Data from https://www.microsoft.com/en-us/research/project/a-flexible-new-technique-for-camera-calibration-2/?from=http%3A%2F%2Fresearch.microsoft.com%2F%7Ezhang%2Fcalib%2F

load Model.txt;

X = Model(:,1:2:end);
Y = Model(:,2:2:end);

X = X(:)';
Y = Y(:)';

numberImages = 5; 

load data1.txt;
load data2.txt;
load data3.txt;
load data4.txt;
load data5.txt;

x = data1(:,1:2:end);
y = data1(:,2:2:end);
x = x(:)';
y = y(:)';
imagePoints(:,:,1) = [x;y];

x = data2(:,1:2:end);
y = data2(:,2:2:end);
x = x(:)';
y = y(:)';
imagePoints(:,:,2) = [x;y];

x = data3(:,1:2:end);
y = data3(:,2:2:end);
x = x(:)';
y = y(:)';
imagePoints(:,:,3) = [x;y];

x = data4(:,1:2:end);
y = data4(:,2:2:end);
x = x(:)';
y = y(:)';
imagePoints(:,:,4) = [x;y];

x = data5(:,1:2:end);
y = data5(:,2:2:end);
x = x(:)';
y = y(:)';
imagePoints(:,:,5) = [x;y];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Continue with your own code %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%