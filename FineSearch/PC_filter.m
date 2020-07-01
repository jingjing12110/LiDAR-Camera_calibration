function X = PC_filter(velo, gamma, beam_num)
X=[];
for i=1:1:beam_num
    itx = find(velo(:,5)==i);
    if itx~=0
        P = velo(itx,:); % 取第i个beam的点云
        p_num = size(P,1);
        Xi = ones(p_num,4);
        Xi(:,1:3)=P(:,1:3);
        Xi(1,4)=power(P(1,6),gamma);
        Xi(p_num,4)=power(P(p_num,6),gamma);
        for j=2:1:p_num-1
            temp1 = max(P(j-1,6)-P(j,6), P(j+1,6)-P(j,6));
            temp = max(temp1, 0);
            Xi(j,4) = power(temp, gamma);
        end
        X = [X;Xi];
    end    
end
% 滤波
threshhold = power(0.3,0.5); % 深度不连续阈值30cm
ithx = X(:,4) <= threshhold;
X(ithx,:)=[];
temp2 = X(:,4);
temp3 = mapminmax(temp2',0,1);
X(:,4)=temp3';


