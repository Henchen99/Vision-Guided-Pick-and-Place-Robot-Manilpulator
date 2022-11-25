clc
clear
syms theta1 theta2 theta3 r11 r12 r13 r21 r22 r23 r31 r32 r33

%Link Twists:
alpha0 = 0;
alpha1 = pi/2;
alpha2 = pi;

 

%Link Lengths:
a0 = 0;
a1 = 0;
a2 = 9.3;

 

% %Joint Angle:
% theta1 = 90;
% theta2 = 90;
% theta3 = 0;

 

%Link Offset:
d1 = 0;
d2 = 0;
d3 = 0;

 

%End Effector:
P3 = [17.85;0;0;1];

px=17.2719;
py=17.2719;
pz=6.5761;

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
 
T03desired = [r11 r12 r13 px;
           r21 r22 r23 py;
           r31 r32 r33 pz;
           0 0 0 1];
 
T02= T01*T12;
T03 = T01*T12*T23;
T01_inverse=transpose(T01)
T02_inverse=transpose(T02);
T03_inverse=transpose(T03);
T13= T12*T23;
T13_1=T01_inverse*T03desired;
T23_2=T02_inverse*T03desired;

thea1_1=(atan2(py,px)-atan2(0,1))*(180/pi);
%thea1_2=(atan2(py,px)-atan2(0,-1))*(180/pi)

%thea2_1=asind(pz/9.3)

%thea3_1=inv(tan(pz/(9.3*sqrt(1-(pz^2/9.3^2)))))*(180/pi) %wrong
