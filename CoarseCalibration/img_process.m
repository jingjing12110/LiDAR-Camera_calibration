file_dir = 'F:\code\calib_camlaser\2011_09_26_calib\����ͼ��궨����\�궨������';
frame=1;
img = imread(sprintf('%s/my_pic%d.jpg',file_dir,frame));
% %% ����任
% alpha = 1/3;
% gamma = 0.98;
% D = Inverse_DT(img,alpha,gamma);

%% ��ͼ����nx3��ʾ
[a,b,c]=size(img);
    mm=[];
    imguv=[];
    for i=1:b
        mm(i)=i;
    end
    mm=mm';
    for i=1:a
        imguv=[imguv;[zeros(b,1)+i,mm]];
    end
    
    for i=1:a
        for j=1:b
            imguv(i*j,3)=img(i,j);
        end
    end
