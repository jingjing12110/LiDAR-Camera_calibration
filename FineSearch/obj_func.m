function JC = obj_func(uvr,D)
% ���㵥֡����ͶӰ��Ŀ�꺯��
% uvr������ͶӰֵ
% D: Inverse_DT�任���ͼ��
b = size(uvr,1);
JC = 0;
for p=1:1:b
%     i=round(uvr(p,1));
%     if i<0.4
%         i=1; 
%     end
%     j=round(uvr(p,2));
%     if j<0.4
%         j=1;
%     end
    i = uvr(p,1); % u��Ӧͼ�������У�v��Ӧͼ��������
    j = uvr(p,2);
    temp = uvr(p,3)*D(j,i);
    JC = JC+temp;
end

