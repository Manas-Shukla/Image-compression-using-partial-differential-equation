%%subsampler

 

im = imread('./data/mouse.png');

[m,n,~] = size(im);

ed_im = uint8(edge(rgb2gray(im),'canny'));

% imshow(ed_im)

d=1;

thres=0; 

edd_im = padarray(ed_im,[d,d]);

msk_im = uint8(zeros(m,n));

mask_im = padarray(msk_im,[d,d]);

final_mask = uint8(zeros(m,n));

for i=1+d:m+d

    for j=1+d:n+d

        if edd_im(i,j)==1

            msk = uint8(ones(2*d+1,2*d+1));

            val = sum(sum(msk.*mask_im(i-d:i+d,j-d:j+d)));

            if val<=thres

                final_mask(i-d,j-d)=1;

                mask_im(i-d:i+d,j-d:j+d)=ones(2*d+1,2*d+1);

            end    

        end

    end

end

% figure;

% imshow(final_mask*255)

 

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

 

imwrite(logical(final_mask),'./data/mask.pbm')

 

res_im = (1-pmsk).*im;

figure;

imshow(res_im)

 

imwrite(res_im,'./data/res_im.png')

 

 

%%supersampler

 

% win = (2*d+1);

% res_ed = padarray(final_mask,[win,win]);

% res_resim = padarray(res_im,[win,win]);

% col = double(res_resim);

% % imshow(col)

% % size(col)

% [sx,sy,~] = size(res_ed);

% cnt = double(ones(sx,sy,3));

% for i=1+win:m+win

%     for j=1+win:n+win

%         if res_ed(i,j)==1

%             for k=i-win:i+win

%                 for l=j-win:j+win

%                     if res_ed(k,l)==1

%                         for t=0:0.25:1

%                             cx = floor(t*i+(1-t)*k);

%                             cy = floor(t*j+(1-t)*l);

%                             cnt(cx-d:cx+d,cy-d:cy+d,:)=cnt(cx-d:cx+d,cy-d:cy+d,:)+double(ones(win,win,3));

%                             col(cx-d:cx+d,cy-d:cy+d,:)=col(cx-d:cx+d,cy-d:cy+d,:)+double(res_resim(i-d:i+d,j-d:j+d,:))*t+double(res_resim(k-d:k+d,l-d:l+d,:))*(1-t);

%                         end

%                     end

%                 end

%             end

%         end

%     end

% end

% size(col)

% col = uint8(col./cnt);

% col = col(1+win:m+win,1+win:n+win,:);

% % figure;

% % imshow(col);

% 

% % imwrite(col,'./data/res_im.png')
