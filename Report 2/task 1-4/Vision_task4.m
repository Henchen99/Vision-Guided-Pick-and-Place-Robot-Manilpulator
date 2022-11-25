clc
clear

Trw = load('Trw.mat'); %transformation matrix - robot to world
Trw = cell2mat(struct2cell(Trw));
Pcube = load('PCube.mat'); %x,y position of cube
Pcube = cell2mat(struct2cell(Pcube))';
Pcylinder = load('PCylinder.mat'); %x,y position of cylinder
Pcylinder = cell2mat(struct2cell(Pcylinder))';

K = [818.32 0 297.77; 0 818.41 212.26; 0 0 1]; %Intrinsinc Parameter
Tcw = [0.9746 -0.0144 -0.2233 -126.91; 0.061 0.9772 0.2032...
    -43.15; 0.2153 -0.2117 0.9533 646.36]; %tranformation matrix - camera to world

H = K * Tcw; %Extrinsic Parameter

Pcube_wc = H\Pcube;
Pcube_wc = Pcube_wc * (1/Pcube_wc(4));
Pcube = Trw * Pcube_wc;
cubeXYZ=Pcube(1:3)


Pcylinder_wc = H\Pcylinder;
Pcylinder_wc = Pcylinder_wc * (1/Pcylinder_wc(4));
Pcylinder = Trw * Pcylinder_wc;
cylinderXYZ=Pcylinder(1:3)
