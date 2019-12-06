im = imread('./data/im1.png');
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
imshow(final_mask*255)