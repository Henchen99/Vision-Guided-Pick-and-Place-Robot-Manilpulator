clc
clear

%Inputs
px = 0;
py = 17.5788;
pz = 12.3996;

%solve for theta 1
nonroundedtheta1=atan2d(py,px);
theta1=round(nonroundedtheta1) %round the calculated value to integer

%solve for theta 2
l1=sqrt(px^2 + py^2 + pz^2); %distance from gripper to frame {0} in 3D space 
alpha=asind((sin(pi/2)/l1)*pz); %sin rule to find alpha
beta=acosd((l1^2+9.3^2-17.85^2)/(2*l1*9.3)); %cosine rule to find beta
nonroundedtheta2_up=alpha+beta; %elbow up
nonroundedtheta2_down=alpha-beta; %elbow down
theta2_up=round(nonroundedtheta2_up) %round the calculated value to integer
theta2_down=round(nonroundedtheta2_down) %round the calculated value to integer


%solve for theta 3
b = 9.3; %measured link length
c = 17.85; %measured link length
a = sqrt(px^2 + py^2 + pz^2); %distance from gripper to frame {0} in 3D space 
nonroundedtheta3 = 180 - acosd((b^2 + c^2 - a^2) / (2*b*c)); %we use 180-cosine rule because the servo's positive direction of spin is flipped
theta3=round(nonroundedtheta3) %round the calculated value to integer



%Multiplicity Solution display
%please see report for more in depth explanation and diagram

disp('There are 3 cases that exist depending on the angle of theta 2 and theta 3 as we are not given orientation of the end-effector:')
disp('The case where theta 2 = 90 degrees and theta 3 = 0 degrees, there are infinite solutions (robot arm points up)')
disp('The case where theta 2 = 90 degrees and theta 3 != 0 degrees, there are 2 solutions (mirrored rotation of theta 1)')
disp('Finally The case where theta 2 != 90 degrees and theta 3 != 0 degrees, there are 4 solution (elbow up/down, mirror of theta 1)')
disp(' ')

if (theta2_up == 90 || theta2_up == 0) && theta3 == 0
    disp('Infinite solutions:') 
    fprintf('theta 1: Infinite, theta 2: %d, theta 3: %d\n', theta2_up, theta3)
elseif theta2_up == 90 && theta3 ~= 0
    disp('2 solutions:')
    disp('Solution 1:')
    fprintf('theta 1: %d, theta 2: %d, theta 3: %d\n', theta1, theta2_up, theta3)    
    disp('Solution 2 (theta 1 mirrored):')
    fprintf('theta 1: %d, theta 2: %d, theta 3: %d\n', theta1+180, theta2_up, 180-theta3) 
elseif theta2_up ~= 90 && theta3 ~= 0
    disp('4 solutions:')
    disp('Solution 1 (elbow up):')
    fprintf('theta 1: %d, theta 2: %d, theta 3: %d\n', theta1, theta2_up, theta3)    
    disp('Solution 2 (elbow down):')
    fprintf('theta 1: %d, theta 2: %d, theta 3: %d\n', theta1, theta2_down, 180-theta3)    
    disp('Solution 3 (theta 1 mirrored, elbow up):')
    fprintf('theta 1: %d, theta 2: %d, theta 3: %d\n', theta1+180, 180-theta2_up, 180-theta3)    
    disp('Solution 4 (theta 1 mirrored, elbow down):')
    fprintf('theta 1: %d, theta 2: %d, theta 3: %d\n', theta1+180, 180-theta2_down, theta3)    
end
    