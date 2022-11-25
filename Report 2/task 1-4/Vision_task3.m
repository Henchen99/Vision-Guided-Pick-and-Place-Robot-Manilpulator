clc
clear 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GENERAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%
% Import Image %
%%%%%%%%%%%%%%%%

I = imread('CameraView.bmp'); 
   figure, imshow(I)
   title('normal')
CornerThreshold = 4;

% NOTE: I has 3 layers (RGB) even though it looks "black and white".

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transform into Greyscale %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

IRed = double(I(:,:,1));          
IGreen = double(I(:,:,2));
IBlue = double(I(:,:,3));
IGrey = (IRed+IGreen+IBlue)/3;
I = uint8(IGrey);

I=double(I);
[m,n]=size(I);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CYLINDER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%
% Thresholding %
%%%%%%%%%%%%%%%%

Ithreshold_Yellow = zeros(m,n);
for i = 1:m
    for j = 1:n
        if IBlue(i,j)==0 && IRed(i,j)==255 && IGreen(i,j)==255             
            Ithreshold_Yellow(i,j) = 255;
        else
            Ithreshold_Yellow(i,j) = 0;
        end
    end
end
Ithreshold_Yellow = uint8(Ithreshold_Yellow);

%%%%%%%%%%%%%%%%%%%%
% Median Filtering %
%%%%%%%%%%%%%%%%%%%%
 
Imedian_cylinder = zeros(m,n);
for i=4:m-3
    for j=4:n-3
        Imedian_cylinder(i,j)=median([Ithreshold_Yellow(i-3,j-3),Ithreshold_Yellow(i-3,j-2),Ithreshold_Yellow(i-3,j-1)...
            ,Ithreshold_Yellow(i-3,j),Ithreshold_Yellow(i-3,j+1),Ithreshold_Yellow(i-3,j+2)...
            ,Ithreshold_Yellow(i-3,j+3),Ithreshold_Yellow(i-2,j-3),Ithreshold_Yellow(i-2,j-2)...
            ,Ithreshold_Yellow(i-2,j-1),Ithreshold_Yellow(i-2,j),Ithreshold_Yellow(i-2,j+1)...
            ,Ithreshold_Yellow(i-2,j+2),Ithreshold_Yellow(i-2,j+3),Ithreshold_Yellow(i-1,j-3)...
            ,Ithreshold_Yellow(i-1,j-2),Ithreshold_Yellow(i-1,j-1),Ithreshold_Yellow(i-1,j)...
            ,Ithreshold_Yellow(i-1,j+1),Ithreshold_Yellow(i-1,j+2),Ithreshold_Yellow(i-1,j+3)...
            ,Ithreshold_Yellow(i,j-3),Ithreshold_Yellow(i,j-2),Ithreshold_Yellow(i,j-1)...
            ,Ithreshold_Yellow(i,j),Ithreshold_Yellow(i,j+1),Ithreshold_Yellow(i,j+2)...
            ,Ithreshold_Yellow(i,j+3),Ithreshold_Yellow(i+1,j-3),Ithreshold_Yellow(i+1,j-2)...
            ,Ithreshold_Yellow(i+1,j-1),Ithreshold_Yellow(i+1,j),Ithreshold_Yellow(i+1,j+1)...
            ,Ithreshold_Yellow(i+1,j+2),Ithreshold_Yellow(i+1,j+3),Ithreshold_Yellow(i+2,j-3)...
            ,Ithreshold_Yellow(i+2,j-2),Ithreshold_Yellow(i+2,j-1),Ithreshold_Yellow(i+2,j)...
            ,Ithreshold_Yellow(i+2,j+1),Ithreshold_Yellow(i+2,j+2),Ithreshold_Yellow(i+2,j+3)...
            ,Ithreshold_Yellow(i+3,j-3),Ithreshold_Yellow(i+3,j-2),Ithreshold_Yellow(i+3,j-1)...
            ,Ithreshold_Yellow(i+3,j),Ithreshold_Yellow(i+3,j+1),Ithreshold_Yellow(i+3,j+2)...
            ,Ithreshold_Yellow(i+3,j+3)]);
    end
end

%%%%%%%%%%%%%%%%%%%%
% Change to Binary %
%%%%%%%%%%%%%%%%%%%%

Ibw_cylinder = imbinarize(Imedian_cylinder);
%Ibw_cylinder = imbinarize(Ithreshold_Yellow);
 figure, imshow(Ibw_cylinder)
 title('Cylinder')

%%%%%%%%%%
% moment %
%%%%%%%%%%
%Is the sum of (x location to power p, y location power q) multiplied by intensity
%of pixel (=1) at that x,y location (distance)

M00_cylinder=0;
M01_cylinder=0;
M10_cylinder=0;
M11_cylinder=0;
M20_cylinder=0;
M02_cylinder=0;
onepixel=1;

for i=1:m
    for j=1:n
        if Ibw_cylinder(i,j)==onepixel
            M00_cylinder=M00_cylinder+onepixel;
            M01_cylinder=M01_cylinder+(i^1)*onepixel;
            M10_cylinder=M10_cylinder+(j^1)*onepixel;
            M11_cylinder=M11_cylinder+(i*j)*onepixel;
            M20_cylinder=M20_cylinder+(j^2)*onepixel;
            M02_cylinder=M02_cylinder+(i^2)*onepixel;
        end
    end
end

%%%%%Centroid 
Xc_cylinder=M10_cylinder/M00_cylinder;
Yc_cylinder=M01_cylinder/M00_cylinder;
Centroid_cylinder_XY=[Xc_cylinder,Yc_cylinder]; 

%%%%%inertia matrix
u00_cylinder=M00_cylinder;
u01=0;
u10=0;
u11_cylinder=M11_cylinder-(Xc_cylinder*M01_cylinder);
u20_cylinder=M20_cylinder-(Xc_cylinder*M10_cylinder);
u02_cylinder=M02_cylinder-(Yc_cylinder*M01_cylinder);
J_cylinder=[u20_cylinder u11_cylinder;u11_cylinder u02_cylinder];

%eigenvalues and vectors
[v_cylinder,d_cylinder]=eig(J_cylinder); %v is eigenvector [2x2]
                                         %d is eigenvalue [2x2]        
lamda1_cylinder=max(d_cylinder(1,1),d_cylinder(2,2)); %take first index of eigenvalue matrix
lamda2_cylinder=min(d_cylinder(1,1),d_cylinder(2,2)); %take first index of eigenvalue matrix

%%%%Major minor axis calculation
Majoraxis_cylinder=2*sqrt(lamda1_cylinder/M00_cylinder);
Minoraxis_cylinder=2*sqrt(lamda2_cylinder/M00_cylinder);

if lamda1_cylinder == d_cylinder(2,2)    %choose left or right eigen vector corresponding to lamda1
    vx_cylinder=v_cylinder(1,2); 
    vy_cylinder=v_cylinder(2,2); 
else
    vx_cylinder=v_cylinder(1,1);
    vy_cylinder=v_cylinder(1,2);
end

%%%%Angle from horizontal
Anglefromhorizontal_cylinder=atand(vy_cylinder/vx_cylinder);

%%%%perimeter
Iperim_cylinder = zeros(m,n);
Perimeter_cylinder = 0;

for i = 2:m-1   %Iterate from left to right
    for j = 2:n-1
        if Ibw_cylinder(i,j) ~= Ibw_cylinder(i,j+1)
            if Iperim_cylinder(i,j) == Ibw_cylinder(i,j+1)
                break
            else
                Perimeter_cylinder = Perimeter_cylinder + 1;
                Iperim_cylinder(i,j)=Ibw_cylinder(i,j+1);
                break
            end
        end
    end
end
for i = m-1:-1:2    %Iterate from right to left
    for j = n-1:-1:2
        if Ibw_cylinder(i,j) ~= Ibw_cylinder(i,j-1)
            if Iperim_cylinder(i,j) == Ibw_cylinder(i,j-1)
                break
            else
                Perimeter_cylinder = Perimeter_cylinder + 1;
                Iperim_cylinder(i,j)=Ibw_cylinder(i,j-1);         
                break
            end
        end
    end
end
for j = 2:n-1   %Iterate from top to bottom
    for i = 2:m-1
        if Ibw_cylinder(i,j) ~= Ibw_cylinder(i+1,j)
            if Iperim_cylinder(i,j) == Ibw_cylinder(i+1,j)
                break
            else
                Perimeter_cylinder = Perimeter_cylinder + 1;
                Iperim_cylinder(i,j)=Ibw_cylinder(i+1,j);
                break
            end
        end
    end
end
for j = n-1:-1:2    %Iterate from bottom to top
    for i = m-1:-1:2
        if Ibw_cylinder(i,j) ~= Ibw_cylinder(i-1,j)
            if Iperim_cylinder(i,j) == Ibw_cylinder(i-1,j)
                break
            else
                Perimeter_cylinder = Perimeter_cylinder + 1;
                Iperim_cylinder(i,j)=Ibw_cylinder(i-1,j);
                break
            end
        end
    end
end

figure, imshow(Iperim_cylinder);
title('Perimeter cylinder');
%%%%Area
area_cylinder=M00_cylinder;

%%%%circularity
Circularity_cylinder=(4*pi*M00_cylinder)/Perimeter_cylinder^2;

%%%%RGB
RGB_cylinder = [255,255,0];

%%%%Calculating shape using corners


%%%%Displaying Results
T=table(Centroid_cylinder_XY, Anglefromhorizontal_cylinder...
    , Perimeter_cylinder, Circularity_cylinder, RGB_cylinder);
disp(T)

%%%%Saving value of x, y positions 
Tcw_cylinder = [Xc_cylinder, Yc_cylinder, 1];
save('Pcylinder.mat', 'Tcw_cylinder')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CUBE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ithreshold_cyan = zeros(m,n);
for i = 1:m
    for j = 1:n
        if    IRed(i,j) == 0 
            if j < 81
                Ithreshold_cyan(i,j) = 255;
            end
        else
            Ithreshold_cyan(i,j) = 0;
        end
    end
end
Ithreshold_cyan = uint8(Ithreshold_cyan);

%%%%%%%%%%%%%%%%%%%%
% Change to Binary %
%%%%%%%%%%%%%%%%%%%%


Ibw_cube = imbinarize(Ithreshold_cyan);
 figure, imshow(Ibw_cube)
 title('Cube')

%%%%%%%%%%
% moment %
%%%%%%%%%%
%Is the sum of (x location to power p, y location power q) multiplied by intensity
%of pixel (=1) at that x,y location (distance)

%%%%p=q=0
M00_cube=0;
M01_cube=0;
M10_cube=0;
M11_cube=0;
M20_cube=0;
M02_cube=0;
onepixel=1;

for i=1:m
    for j=1:n
        if Ibw_cube(i,j)==onepixel
            M00_cube=M00_cube+onepixel;
            M01_cube=M01_cube+(i^1)*onepixel;
            M10_cube=M10_cube+(j^1)*onepixel;
            M11_cube=M11_cube+(i*j)*onepixel;
            M20_cube=M20_cube+(j^2)*onepixel;
            M02_cube=M02_cube+(i^2)*onepixel;
        end
    end
end

%%%%%Centroid 
Xc_cube=M10_cube/M00_cube;
Yc_cube=M01_cube/M00_cube;
Centroid_cube_XY=[Xc_cube,Yc_cube]; 

%%%%%inertia matrix
u11_cube=M11_cube-(Xc_cube*M01_cube);
u20_cube=M20_cube-(Xc_cube*M10_cube);
u02_cube=M02_cube-(Yc_cube*M01_cube);
J_cube=[u20_cube u11_cube;u11_cube u02_cube];

%eigenvalues and vectors
[v_cube,d_cube]=eig(J_cube); %v is eigenvector [2x2]
             %d is eigenvalue [2x2]        
lamda1_cube=max(d_cube(1,1),d_cube(2,2)); %take first index of eigenvalue matrix
lamda2_cube=min(d_cube(1,1),d_cube(2,2)); %take first index of eigenvalue matrix

%%%%Major minor axis calculation
Majoraxis_cube=2*sqrt(lamda1_cube/M00_cube);
Minoraxis_cube=2*sqrt(lamda2_cube/M00_cube);

if lamda1_cube == d_cube(2,2)    %choose left or right eigen vector corresponding to lamda1
    vx_cube=v_cube(1,2);
    vy_cube=v_cube(2,2);
else
    vx_cube=v_cube(1,1);
    vy_cube=v_cube(1,2);
end

%%%%Angle from horizontal
Anglefromhorizontal_cube=atand(vy_cube/vx_cube);

Iperim_cube = zeros(m,n);
%%%%perimeter

%%%% left right top bottom
Perimeter_cube=0;
for i = 2:m-1
    for j = 2:n-1
        if Ibw_cube(i,j) ~= Ibw_cube(i,j+1)
            if Iperim_cube(i,j) == Ibw_cube(i,j+1)
                break
            else
                Perimeter_cube = Perimeter_cube + 1;
                Iperim_cube(i,j)=Ibw_cube(i,j+1);
                break
            end
        end
    end
end
for i = m-1:-1:2
    for j = n-1:-1:2
        if Ibw_cube(i,j) ~= Ibw_cube(i,j-1)
            if Iperim_cube(i,j) == Ibw_cube(i,j-1)
                break
            else
                Perimeter_cube = Perimeter_cube + 1;
                Iperim_cube(i,j)=Ibw_cube(i,j-1);         
                break
            end
        end
    end
end
for j = 2:n-1
    for i = 2:m-1
        if Ibw_cube(i,j) ~= Ibw_cube(i+1,j)
            if Iperim_cube(i,j) == Ibw_cube(i+1,j)
                break
            else
                Perimeter_cube = Perimeter_cube + 1;
                Iperim_cube(i,j)=Ibw_cube(i+1,j);
            break
            end
        end
    end
end
for j = n-1:-1:2
    for i = m-1:-1:2
        if Ibw_cube(i,j) ~= Ibw_cube(i-1,j)
            if Iperim_cube(i,j) == Ibw_cube(i-1,j)
                break
            else
                Perimeter_cube = Perimeter_cube + 1;
                Iperim_cube(i,j)=Ibw_cube(i-1,j);
            break
            end
        end
    end
end

figure, imshow(Iperim_cube);
title('Perimeter cube')
%%%%Area
area_cube=M00_cube;

%%%%circularity
Circularity_cube=(4*pi*M00_cube)/(Perimeter_cube^2);

%%%%RGB
RGB_cube = [0,255,255];

%%%%Calculating shape using corners


%%%%Displaying Results
T=table(Centroid_cube_XY, Anglefromhorizontal_cube...
    , Perimeter_cube, Circularity_cube, RGB_cube);
disp(T)

%%%%Saving value of x, y positions 
Tcw_cube = [Xc_cube, Yc_cube, 1];
save('Pcube.mat', 'Tcw_cube')



