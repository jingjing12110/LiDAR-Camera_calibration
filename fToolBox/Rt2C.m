function C = Rt2C(R,t)

Roll = atan2(R(3,2),R(3,3));
temp = power(R(3,2),2)+power(R(3,3),2);
Pitch = atan2(-R(3,1),sqrt(temp));
Yaw = atan2(R(2,1),R(1,1));
C = [t', Roll, Pitch, Yaw];
