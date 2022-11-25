clc
clear 
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

phi = zeros(256*2,9); % initialising phi matrix with zeros, each corner point has two rows in the matrix thus we need to double the lines
H = zeros(3,3,5);
for j = 1:5
    for i = 1:2:512
        ok = imagePoints(:,:,j);
        x = ok(1,:);
        y = ok(2,:);
        phi(i,:) = [0 0 0 X((i+1)/2) Y((i+1)/2) 1 -y((i+1)/2) * X((i+1)/2) -y((i+1)/2) * Y((i+1)/2) -y((i+1)/2)];
        phi(i+1,:) = [X((i+1)/2) Y((i+1)/2) 1 0 0 0 -x((i+1)/2) * X((i+1)/2) -x((i+1)/2) * Y((i+1)/2) -x((i+1)/2)];

    end % forming phi matrix
   % H(:,j) = svd(phi);
   [U,S,V] = svd(phi);
   H(1, 1:3, j) = V(1:3, 9);
   H(2, 1:3, j) = V(4:6, 9);
   H(3, 1:3, j) = V(7:9, 9);
   
end

V1 = zeros(10,6);
for i = 1:5
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
for m = 1:5
    
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
for n = 1:5
Tcw(:,:,n) = finalParameters(:,:,n);

end
   

save('Tcw.mat','Tcw')

save('K.mat','K')






