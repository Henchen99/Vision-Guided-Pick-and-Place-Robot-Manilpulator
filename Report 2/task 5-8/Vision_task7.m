clc
clear 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GENERAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%
% Import Image %
%%%%%%%%%%%%%%%%

I = imread('object1.png'); 
   figure, imshow(I)
   title('normal')

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% object %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%
% Thresholding %
%%%%%%%%%%%%%%%%

Ithreshold = zeros(m,n);
for i = 1:m
    for j = 1:n
        if IRed(i,j)>210 && IRed(i,j)<255 && IGreen(i,j)>200 &&...
                IGreen(i,j)<=255 && IBlue(i,j)> 230 && IBlue(i,j)<=255
            if (i > 50) && (i < (m-50)) && (j > 50) && (j < (n-50))
                Ithreshold(i,j) = 255;
            end
        else 
            Ithreshold(i,j) = 0;
        end
    end
end
Ithreshold = uint8(Ithreshold);

%%%%%%%%%%%%%%%%%%%%
% Median Filtering %
%%%%%%%%%%%%%%%%%%%%
 
Imedian_object = zeros(m,n);
for i=4:m-3
    for j=4:n-3
        Imedian_object(i,j)=median([Ithreshold(i-3,j-3),Ithreshold(i-3,j-2),Ithreshold(i-3,j-1)...
            ,Ithreshold(i-3,j),Ithreshold(i-3,j+1),Ithreshold(i-3,j+2)...
            ,Ithreshold(i-3,j+3),Ithreshold(i-2,j-3),Ithreshold(i-2,j-2)...
            ,Ithreshold(i-2,j-1),Ithreshold(i-2,j),Ithreshold(i-2,j+1)...
            ,Ithreshold(i-2,j+2),Ithreshold(i-2,j+3),Ithreshold(i-1,j-3)...
            ,Ithreshold(i-1,j-2),Ithreshold(i-1,j-1),Ithreshold(i-1,j)...
            ,Ithreshold(i-1,j+1),Ithreshold(i-1,j+2),Ithreshold(i-1,j+3)...
            ,Ithreshold(i,j-3),Ithreshold(i,j-2),Ithreshold(i,j-1)...
            ,Ithreshold(i,j),Ithreshold(i,j+1),Ithreshold(i,j+2)...
            ,Ithreshold(i,j+3),Ithreshold(i+1,j-3),Ithreshold(i+1,j-2)...
            ,Ithreshold(i+1,j-1),Ithreshold(i+1,j),Ithreshold(i+1,j+1)...
            ,Ithreshold(i+1,j+2),Ithreshold(i+1,j+3),Ithreshold(i+2,j-3)...
            ,Ithreshold(i+2,j-2),Ithreshold(i+2,j-1),Ithreshold(i+2,j)...
            ,Ithreshold(i+2,j+1),Ithreshold(i+2,j+2),Ithreshold(i+2,j+3)...
            ,Ithreshold(i+3,j-3),Ithreshold(i+3,j-2),Ithreshold(i+3,j-1)...
            ,Ithreshold(i+3,j),Ithreshold(i+3,j+1),Ithreshold(i+3,j+2)...
            ,Ithreshold(i+3,j+3)]);
    end
end

%%%%%%%%%%%%%%%%%%%%
% Change to Binary %
%%%%%%%%%%%%%%%%%%%%

Ibw_object = imbinarize(Imedian_object);
%Ibw_object = imbinarize(Ithreshold);
  figure, imshow(Ibw_object)
 title('object')

%%%%%%%%%%
% moment %
%%%%%%%%%%
%Is the sum of (x location to power p, y location power q) multiplied by intensity
%of pixel (=1) at that x,y location (distance)

M00_object=0;
M01_object=0;
M10_object=0;
M11_object=0;
M20_object=0;
M02_object=0;
onepixel=1;

for i=1:m
    for j=1:n
        if Ibw_object(i,j)==onepixel
            M00_object=M00_object+onepixel;
            M01_object=M01_object+(i^1)*onepixel;
            M10_object=M10_object+(j^1)*onepixel;
            M11_object=M11_object+(i*j)*onepixel;
            M20_object=M20_object+(j^2)*onepixel;
            M02_object=M02_object+(i^2)*onepixel;
        end
    end
end

%%%%%Centroid 
Xc_object=M10_object/M00_object;
Yc_object=M01_object/M00_object;
Centroid_object_XY=[Xc_object,Yc_object]; 

%%%%%inertia matrix
u00_object=M00_object;
u01=0;
u10=0;
u11_object=M11_object-(Xc_object*M01_object);
u20_object=M20_object-(Xc_object*M10_object);
u02_object=M02_object-(Yc_object*M01_object);
J_object=[u20_object u11_object;u11_object u02_object];

%eigenvalues and vectors
[v_object,d_object]=eig(J_object); %v is eigenvector [2x2]
                                         %d is eigenvalue [2x2]        
lamda1_object=max(d_object(1,1),d_object(2,2)); %take first index of eigenvalue matrix
lamda2_object=min(d_object(1,1),d_object(2,2)); %take first index of eigenvalue matrix

%%%%Major minor axis calculation
Majoraxis_object=2*sqrt(lamda1_object/M00_object);
Minoraxis_object=2*sqrt(lamda2_object/M00_object);

if lamda1_object == d_object(2,2)    %choose left or right eigen vector corresponding to lamda1
    vx_object=v_object(1,2); 
    vy_object=v_object(2,2); 
else
    vx_object=v_object(1,1);
    vy_object=v_object(1,2);
end

%%%%Angle from horizontal
Anglefromhorizontal_object=atand(vy_object/vx_object);

%%%%perimeter
Iperim_object = zeros(m,n);
Perimeter_object = 0;

for i = 2:m-1   %Iterate from left to right
    for j = 2:n-1
        if Ibw_object(i,j) ~= Ibw_object(i,j+1)
            if Iperim_object(i,j) == Ibw_object(i,j+1)
                break
            else
                Perimeter_object = Perimeter_object + 1;
                Iperim_object(i,j)=Ibw_object(i,j+1);
                break
            end
        end
    end
end
for i = m-1:-1:2    %Iterate from right to left
    for j = n-1:-1:2
        if Ibw_object(i,j) ~= Ibw_object(i,j-1)
            if Iperim_object(i,j) == Ibw_object(i,j-1)
                break
            else
                Perimeter_object = Perimeter_object + 1;
                Iperim_object(i,j)=Ibw_object(i,j-1);         
                break
            end
        end
    end
end
for j = 2:n-1   %Iterate from top to bottom
    for i = 2:m-1
        if Ibw_object(i,j) ~= Ibw_object(i+1,j)
            if Iperim_object(i,j) == Ibw_object(i+1,j)
                break
            else
                Perimeter_object = Perimeter_object + 1;
                Iperim_object(i,j)=Ibw_object(i+1,j);
                break
            end
        end
    end
end
for j = n-1:-1:2    %Iterate from bottom to top
    for i = m-1:-1:2
        if Ibw_object(i,j) ~= Ibw_object(i-1,j)
            if Iperim_object(i,j) == Ibw_object(i-1,j)
                break
            else
                Perimeter_object = Perimeter_object + 1;
                Iperim_object(i,j)=Ibw_object(i-1,j);
                break
            end
        end
    end
end

figure, imshow(Iperim_object);
title('Perimeter')

%%%%circularity
Circularity_object=(4*pi*M00_object)/Perimeter_object^2;

%%%%Displaying Results
T=table(Centroid_object_XY, Anglefromhorizontal_object...
    , Perimeter_object, Circularity_object);
disp(T)

%%%%Saving value of x, y positions 
Tcw_object = [Xc_object, Yc_object, 1];
save('Pobject.mat', 'Tcw_object')