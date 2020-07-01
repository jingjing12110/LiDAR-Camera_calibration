function uv = img_n3(img)
[a,b] = size(img);
uv = zeros(a*b,3);
i = 1;
for u = 1:a
    for v = 1:b
        uv(i,1) = u;
        uv(i,2) = v;
        uv(i,3) = img(u,v);
        i = i+1;
    end
end
