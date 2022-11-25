clc
clear

%syms alpha1 alpha2 alpha3 theta1 theta2 theta3
%Link Twists:
alpha0 = 0;
alpha1 = pi/2;
alpha2 = pi;

%Link Lengths:
a0 = 0;
a1 = 0;
a2 = 9.3;

%Joint Angle:
theta1 = 0*(pi/180);
theta2 = 24*(pi/180);
theta3 = 13*(pi/180);

%Link Offset:
d1 = 0;
d2 = 0;
d3 = 0;

%End Effector:
P3 = [17.85;0;0;1];

%Link Transformations:
% T01 = [cos(theta1) -sin(theta1) 0 a0;
%      cos(alpha0)*sin(theta1) cos(alpha0)*cos(theta1) -sin(alpha0) -sin(alpha0)*d1;
%      sin(alpha0)*sin(theta1) sin(alpha0)*cos(theta1) cos(alpha0) cos(alpha0)*d1;
%      0 0 0 1];
% T12 = [cos(theta2) -sin(theta2) 0 a1;
%      cos(alpha1)*sin(theta2) cos(alpha1)*cos(theta2) -sin(alpha1) -sin(alpha1)*d2;
%      sin(alpha1)*sin(theta2) sin(alpha1)*cos(theta2) cos(alpha1) cos(alpha1)*d2;
%      0 0 0 1];
% T23 = [cos(theta3) -sin(theta3) 0 a2;
%      cos(alpha2)*sin(theta3) cos(alpha2)*cos(theta3) -sin(alpha2) -sin(alpha2)*d3;
%      sin(alpha2)*sin(theta3) sin(alpha2)*cos(theta3) cos(alpha2) cos(alpha2)*d3;
%      0 0 0 1];

 T01 = [cos(theta1) -sin(theta1) 0 0;
     sin(theta1) cos(theta1) 0 0;
     0 0 1 0;
     0 0 0 1];
T12 = [cos(theta2) -sin(theta2) 0 0;
     0 0 -1 0;
     sin(theta2) cos(theta2) 0 0;
     0 0 0 1];
T23 = [cos(theta3) -sin(theta3) 0 9.3;
     -sin(theta3) -cos(theta3) 0 0;
     0 0 -1 0;
     0 0 0 1];
 
T03 = T01*T12*T23

%position and orientation of end-effector wrt. frame{0}:
P0a = T03 * P3;
P0final = P0a(1:3,1)