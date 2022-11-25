clc
clear

%Link Twists:
alpha0 = 0;
alpha1 = pi/2;
alpha2 = pi;

%Link Lengths:
a0 = 0;
a1 = 0;
a2 = 9.3;

%Joint Angle:
theta1 = 81.56*(pi/180); %to convert degrees to radians
theta2 = 34.98*(pi/180);
theta3 = 59.86*(pi/180);

%Link Offset:
d1 = 0;
d2 = 0;
d3 = 0;

%End Effector:
P3 = [21.5;0;0;1]; %Lengths are

%Link Transformations:
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
 
T03 = T01*T12*T23;

%position and orientation of end-effector wrt. frame{0}:
P0a = T03 * P3;
P0final = P0a(1:3,1)