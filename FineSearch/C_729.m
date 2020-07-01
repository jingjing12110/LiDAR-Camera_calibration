function CC = C_729(C, delta_t, delta_R)
delta_tx = delta_t;
delta_ty = delta_t;
delta_tz = delta_t;
delta_Rx = delta_R;
delta_Ry = delta_R;
delta_Rz = delta_R;

Xs = [C(1)-delta_tx, C(1), C(1)+delta_tx];
Ys = [C(2)-delta_ty, C(2), C(2)+delta_ty];
Zs = [C(3)-delta_tz, C(3), C(3)+delta_tz];
Roll_s = [C(4)-delta_Rx, C(4), C(4)+delta_Rx];
Pitch_s = [C(5)-delta_Ry, C(5), C(5)+delta_Ry];
Yaw_s = [C(6)-delta_Rz, C(6), C(6)+delta_Rz];
CC=zeros(729,6);
kk=1;
for i=1:1:3
    for j=1:1:3
        for k =1:1:3
            for m=1:1:3
                for n=1:1:3
                    for p=1:1:3
                        temp=[Xs(i), Ys(j), Zs(k), Roll_s(m), Pitch_s(n), Yaw_s(p)];
%                         CC = [CC; temp];
                        CC(kk,:) = temp;
                        kk = kk+1;
                    end
                end
            end
        end
    end
end

