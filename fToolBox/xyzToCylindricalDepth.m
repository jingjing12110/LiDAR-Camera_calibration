fid = fopen('velo_000050.bin','r');
velo = fread(fid,[112512,4],'double');
% velo = fread(fid,[4 inf],'single')';
fclose(fid);
velo_1=velo;

for i=1:112512
    velo(i,5)=mod(i-1,64);
end

% itx = find(velo(:,5)==2);
% velo_i = velo(itx,1:3);
% pcshow(velo_i,'markersize',15)
%% �������ͼ //velo_cylin:[R,theta,z, x,y,idensity,ID]
[TH,R,Z] = cart2pol(velo(:,1),velo(:,2),velo(:,3));
velo_cylin=[R,TH,Z];
velo_cylin(:,4:5)=velo(:,1:2);%x���꣬�������Ƕ�ͼ
velo_cylin(:,6:7)=velo(:,4:5); 

depth=zeros(64,873);
d_ref=zeros(64,873);
for row=1:1:64
    itx = velo_cylin(:,7)==row-1;
    velo_row=velo_cylin(itx,:);
    i=1;
    for col=pi:-0.0072:-pi
        itx1=find(velo_row(:,2)<col & velo_row(:,2)>col-0.0072);
        velo_col=velo_row(itx1,:);
        if ~isempty(velo_col)
            I=mean(velo_col(:,1));% ����
            depth(65-row,i)=I;
            
            I1=mean(velo_col(:,4));% x����
            d_ref(65-row,i,1)=I1;
            
            I2=mean(velo_col(:,3));% z����
            d_ref(65-row,i,2)=I2;
                        
            I3=mean(velo_col(:,6));% ������
            d_ref(65-row,i,3)=I3;
            
            data_lab{row,i}=velo_col(:,3:7); 
        end       
        i=i+1;
    end
end

%% ����Ƕ�ͼ
% depth1 = depth(:,2:871);
alpha=zeros(63,873);
for col=1:1:873
    for row=1:1:63
        delta_x=abs(d_ref(row,col,1)-d_ref(row+1,col,1));
        delta_z=abs(d_ref(row,col,2)-d_ref(row+1,col,2));
        alpha(row,col)=atan2(delta_z,delta_x);
    end
end

% SG�˲�
% Alpha_matrix = sgolayfilt(alpha,3,5);
%% ���ڹ�����������ĵ����˲�
node_y=[];
for k=1:1:873
    if(alpha(63,k)<=0.7854)
        node_y=[node_y;k];
    end   
end

label=zeros(63,873);
for node_ID=1:1:length(node_y)
    startNode=node_y(node_ID);
    result=BFSTraversal(startNode,alpha);
    for k=1:1:length(result)
        x=63-floor(result(k)/873);
        y=mod(result(k)-1,873)+1;
        label(x,y)=1;
    end
end






