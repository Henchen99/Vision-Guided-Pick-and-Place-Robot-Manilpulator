clc
clear

Trw = load('Trw_lab.mat'); %transformation matrix - robot to world
Trw = cell2mat(struct2cell(Trw))
Pobject = load('Pobject.mat'); %x,y position of object
Pobject = cell2mat(struct2cell(Pobject))'
K = load('K_lab.mat'); %Intrinsinc Parameter
K = cell2mat(struct2cell(K))
Tcw = load('Tcw_lab.mat');
Tcw = cell2mat(struct2cell(Tcw)) %tranformation matrix - camera to world

H = K * Tcw; %Extrinsic Parameter


Pobject_wc = H\Pobject;
Pobject_wc = Pobject_wc * (1/Pobject_wc(4));
Pobject = Trw * Pobject_wc;
objectXYZ=Pobject(1:3)



