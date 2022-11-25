% clc
% clear

% Since we have the same point expressed in 2 different frames (World and
% Camera frame. We use the transformation matrix to find the relationship
% between these frames. In the world frame, there is no 'Z' because we are 
% looking at a 2D plane. In the transformation matrix we need to solve for
% 2 parameters: rhoij and tx,y,z.

%%% World coordinates %%%%
% Xi=[0 42 42 0 63 147 168];    %%%%CHANGE%%%%
% Yi=[0 0 21 63 84 105 0];   %%%%CHANGE%%%%
% 
% %%%% Robot coordinates %%%%
% Xri=[-15.3786 -10.6322 -10.4298 -15.5958  -7.9721 1.0444 2.5727]; %%%%CHANGE%%%%
% Yri=[15.0336 15.0219  17.0867 21.6321 24.1479 26.4647 15.9016];    %%%%CHANGE%%%%
% Zri=[-5.9043 -7.1120 -7.0308 -3.5606 -4.5224  -4.8102 -7.3432];    %%%%CHANGE%%%%

Xi=[0 0 42 168 147];    %%%%CHANGE%%%%
Yi=[0 63 21 0 105];   %%%%CHANGE%%%%

%%%% Robot coordinates %%%%
Xri=[-13.78 -13.53 -9.3 4.6 2.3]; %%%%CHANGE%%%%
Yri=[15.05 21.65 16.9 16.1 26.8];    %%%%CHANGE%%%%
Zri=[-5.2 -4.5 -6.8 -7 -4.1];    %%%%CHANGE%%%%

% Xri=Xri.*10;
 Yri=Yri.*10;
% Zri=Zri.*10;
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
Trw_lab = [rhocomb t; 0 0 0 1]
% %Trw_lab = [rho11 rhot; 0 0 0 1]
% RHO = cross([rho11;rho21;rho31],[rho12;rho22;rho32]);
% rho13 = RHO(1,1);
% rho23 = RHO(2,1);
% rho33 = RHO(3,1);
% 
% rhocomb = [ rho11 rho12 rho13; rho21 rho22 rho23; rho31 rho32 rho33];
% Trw_lab = [rho11 rho12 rho13 tx; rho21 rho22 rho23 ty; rho31 rho32 rho33 tz; 0 0 0 1]
save('Trw_lab.mat', 'Trw_lab')
