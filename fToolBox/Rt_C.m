function C = Rt_C(R,t)
% ��֪��ת����R��ƽ��������C
Roll = atan2(R(3,2),R(3,3));
temp = power(R(3,2),2)+power(R(3,3),2);
Pitch = atan2(-R(3,1),sqrt(temp));
Yaw = atan2(R(2,1),R(1,1));
% ƽ��Ϊ��λΪm���Ƕ�Ϊ����ֵ
C = [t', Roll, Pitch, Yaw];
% %% ��֤
% Rx=[1,0,0; 
%     0,cos(Roll),-sin(Roll);
%     0,sin(Roll),cos(Roll)];
% Ry=[cos(Pitch),0,sin(Pitch);
%     0,1,0;
%     -sin(Pitch),0,cos(Pitch)];
% Rz=[cos(Yaw),-sin(Yaw),0;
%     sin(Yaw),cos(Yaw),0;
%     0,0,1];
% RR=Rz*Ry*Rx;
