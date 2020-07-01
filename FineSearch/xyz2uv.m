function uv = xyz2uv(X,C,K_int)
% X: [x,y,z,Xpi]'��PC_filter��ĵ���
% C: [x,y,z,Roll,Pitch,Yaw]; ��ξ���
% K_int�� �ڲξ���
% uv: [u,v,Xpi],XpiΪ��������ֵ
%% ����궨����
% ���
K_ext=C2RT(C);
% x=C(1,1);y=C(1,2);z=C(1,3);
% Roll = C(1,4); Pitch = C(1,5);Yaw = C(1,6);
% t=[x,y,z]';
% Rx=[1,0,0; 
%     0,cos(Roll),-sin(Roll);
%     0,sin(Roll),cos(Roll)];
% Ry=[cos(Pitch),0,sin(Pitch);
%     0,1,0;
%     -sin(Pitch),0,cos(Pitch)];
% Rz=[cos(Yaw),-sin(Yaw),0;
%     sin(Yaw),cos(Yaw),0;
%     0,0,1];
% R=Rz*Ry*Rx;
% K_ext=eye(4,4);
% K_ext(1:3,1:3)=R;
% K_ext(1:3,4)=t;
% �궨����
K_matrix=K_int*K_ext;
%% ����ͶӰ
xyz = X(:,1:3);
xyz(:,4)=1;
xyz=xyz';
uv=K_matrix*xyz;
uv=uv';
uv(:,1:2)=uv(:,1:2)./(uv(:,3)*ones(1,2)); % uv(:,1:2)=uv(:,1:2)./uv(:,3)
temp = round(uv(:,1:2)); % ���ص�������
uv(:,1:2) = temp;
uv(:,3) = X(:,4);
