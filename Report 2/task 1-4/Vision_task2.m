clc
clear

% Since we have the same point expressed in 2 different frames (World and
% Camera frame. We use the transformation matrix to find the relationship
% between these frames. In the world frame, there is no 'Z' because we are 
% looking at a 2D plane. In the transformation matrix we need to solve for
% 2 parameters: rhoij and tx,y,z.

%%%% World coordinates %%%%
Xi=[-22 0 22 44 66 154];
Yi=[-22 22 66 22 88 -22];

%%%% Robot coordinates %%%%
Xri=[-121.6 -100.4 -79.16 -56.39 -35.55 54.32];
Yri=[222.4 178 133.6 177.2 110.9 219.3];
Zri=[-20 -20.04 -20.08 -19.96 -20.04 -19.7];

%%%%% calculate rho11 rho12 tx %%%%%
Exixi=Xi.*Xi;
Exixi=sum(Exixi);

Eyixi=Yi.*Xi;
Eyixi=sum(Eyixi);

Exiyi=Xi.*Yi;
Exiyi=sum(Exiyi);

Eyiyi=Yi.*Yi;
Eyiyi=sum(Eyiyi);

Exrixi=Xri.*Xi;
Exrixi=sum(Exrixi);

Exriyi=Xri.*Yi;
Exriyi=sum(Exriyi);

Exi=sum(Xi);
Eyi=sum(Yi);
Exri=sum(Xri);

n=6; %the number of points you extract

x = inv([Exixi Eyixi Exi; Exiyi Eyiyi Eyi; Exi Eyi n]) * [Exrixi Exriyi Exri]';
rho11=x(1);
rho12=x(2);
tx=x(3);

%%%%% calculate rho21 rho22 ty %%%%%
Eyrixi=Yri.*Xi;
Eyrixi=sum(Eyrixi);

Eyriyi=Yri.*Yi;
Eyriyi=sum(Eyriyi);

Eyri=sum(Yri);

y = inv([Exixi Eyixi Exi; Exiyi Eyiyi Eyi; Exi Eyi n]) * [Eyrixi Eyriyi Eyri]';
rho21=y(1);
rho22=y(2);
ty=y(3);

%%%%% calculate rho31 rho32 tz %%%%%
Ezrixi=Zri.*Xi;
Ezrixi=sum(Ezrixi);

Ezriyi=Zri.*Yi;
Ezriyi=sum(Ezriyi);

Ezri=sum(Zri);

z = inv([Exixi Eyixi Exi; Exiyi Eyiyi Eyi; Exi Eyi n]) * [Ezrixi Ezriyi Ezri]';
rho31=z(1);
rho32=z(2);
tz=z(3);


%%%% rhoi1 %%%%
rhoi1=[rho11 rho21 rho31];
%%%% rhoi2 %%%%
rhoi2=[rho12 rho22 rho32];
%%%% rhoi3 %%%%
rhoi3=cross(rhoi1,rhoi2);

rhocomb=[rhoi1; rhoi2; rhoi3]

t=[tx; ty; tz]

%position and orientation of world frame with respect to robot frame 
%as a single homogeneous transformation matrix 
Trw = [rhocomb t; 0 0 0 1]
save('Trw.mat', 'Trw')
