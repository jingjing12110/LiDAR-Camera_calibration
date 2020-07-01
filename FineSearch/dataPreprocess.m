% clear;clc;
data_dir = '/media/jing/DATA/20180502/search/data1/dataSet';

% ��ʼ����ز���
alpha = 1/3;
gamma1 = 0.98; % �õ�Dͼ�Ĳ���
gamma2 = 0.5; % �õ���������ֵX�Ĳ���
beam_num = 64; % ��������

%% ��������,�������ݽ���Ԥ����
imgDir  = dir(sprintf('%s/img/*.jpg', data_dir));

for i =1:length(imgDir)
    % ͼ��Ԥ����
    i
    img = imread(sprintf('%s/img/img_%06d.jpg',data_dir,i));
    img = rgb2gray(img);
    img = img(351:750,:);
    % Data(i).img = img;
    %D = Inverse_DT(img,alpha,gamma1);
    [E,D] = IDT(img,gamma1,alpha);
    Data(i).D = D;
    
    % ����Ԥ����
    velox = sprintf('%s/velo/velo_%06d.bin', data_dir,i);
    fileID = fopen(velox,'r');
    velo1 = fread(fileID,[112512,4],'double');
    fclose(fileID); %read
    for j=1:112512
        velo1(j,5)=mod(j-1,64);
    end
    
    velo = veloPolarSector(velo1,82);
    itx = velo(:,4)==0;
    velo(itx,:)=[];
    idx1 = velo(:,1)<5 | velo(:,1)>25;
    velo(idx1,:) = [];
    
    itx =  velo(:,3)<-1.6;% | velo(:,2)<-20 | velo(:,2)>20;
    velo(itx,:)=[];
    velo(:,6)=sqrt(power(velo(:,1),2)+power(velo(:,2),2)+power(velo(:,3),2));
    X = PC_filter(velo, gamma2, beam_num); % X=[x,y,z,Xpi]' ���õ�X����
    % �˲�/������
%     itx = X(:,2)<12 & X(:,2)>-9.8 & X(:,1)<50;
%     X = X(itx,:);
    % pcshow(X(:,1:3),'MarkerSize' ,20)
    Data(i).X = X;
    i = i+1;
end




