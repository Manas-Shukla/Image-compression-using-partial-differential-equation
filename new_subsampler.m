final_mask = uint8(imread('./data/mask.pbm'));

res_im = imread('./data/res_im.png');

[m,n,~] = size(final_mask);

d=1;

thres=0; 

window = 3;

pd = (window-1)/2;

pmsk = padarray(uint8(ones(m,n)),[pd,pd]);

 

for i=pd+1:pd+m

    for j=pd+1:pd+n

        if final_mask(i-pd,j-pd)

            pmsk(i-pd:i+pd,j-pd:j+pd,:) = 0;

        end

    end

end

 

 

pmsk = pmsk(pd+1:pd+m,pd+1:pd+n,:);

pmsk(1,:,:) = 0;

pmsk(m,:,:) = 0;

pmsk(:,1,:)= 0;

pmsk(:,n,:) = 0;

figure;

imshow(pmsk*255)

 

imwrite(logical(pmsk),'./data/mask_use.pbm')

 

 

win = (2*d+1);

res_ed = padarray(final_mask,[win,win]);

res_resim = padarray(res_im,[win,win]);

col = double(res_resim);

% imshow(col)

% size(col)

[sx,sy,~] = size(res_ed);

cnt = double(ones(sx,sy,3));

for i=1+win:m+win

    for j=1+win:n+win

        if res_ed(i,j)==1

            for k=i-win:i+win

                for l=j-win:j+win

                    if res_ed(k,l)==1

                        for t=0:0.25:1

                            cx = floor(t*i+(1-t)*k);

                            cy = floor(t*j+(1-t)*l);

                            cnt(cx-d:cx+d,cy-d:cy+d,:)=cnt(cx-d:cx+d,cy-d:cy+d,:)+double(ones(win,win,3));

                            col(cx-d:cx+d,cy-d:cy+d,:)=col(cx-d:cx+d,cy-d:cy+d,:)+double(res_resim(i-d:i+d,j-d:j+d,:))*t+double(res_resim(k-d:k+d,l-d:l+d,:))*(1-t);

                        end

                    end

                end

            end

        end

    end

end

size(col)

col = uint8(col./cnt);

col = col(1+win:m+win,1+win:n+win,:);

figure;

imshow(col);

imwrite(col,'./data/res_im_use.png')
