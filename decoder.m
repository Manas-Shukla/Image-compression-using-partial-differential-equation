function [psnr] = decoder(maskPath,maskedImagePath,origImagePath,savePath)
%DECODER 
% takes mask and image with some pixel values missing
% generates the estimate of original image using homogenous diffusion
% the error measure used is PSNR
% maskImagePath must have .pbm extension

    res_im = imread(maskedImagePath);
    mask_im = imread(maskPath);
    orig_im = imread(origImagePath);
    
    % Homogenous Diffusion %
    delta_t=0.09;
    max_time=500;

    % convert mask from logical to double to avoid calculation loss
    msk = double(mask_im);
    msk = cat(3,msk,msk,msk);
    % use image as double to avoid integer division 
    res_im = double(res_im);
    [m,n,~]=size(res_im);
%     figure;
    for t=0:delta_t:max_time
%         disp(t);
        % calculate the double dervatives 
        res_xx = res_im(:,[2:n,n],:)-2*res_im+res_im(:,[1,1:n-1],:);
        res_yy = res_im([2:m,m],:,:)-2*res_im+res_im([1,1:m-1],:,:);
        Lap = res_xx + res_yy;

        % get the effictive divergence to applied
        div = delta_t*Lap;
        % disp(sqrt(sum(sum(div.^2))));
        % change only where mask is true
        res_im = res_im + (div.*msk);
%         imshow(uint8(res_im));
%         drawnow 
    end

    % convert back to integer values
    res_im = uint8(res_im);
    % calculate PSNR 
    mse = double(sum(sum(sum((orig_im-res_im).^2))))/(3.0*m*n);
    psnr = 10.0*log10((255.0*255.0)/mse);
    disp(psnr);
    figure;
    imshow(orig_im);
    title('original image');
    pause(2);
    figure;
    imshow(res_im);
    title('restored image');
    
    imwrite(res_im,savePath);

end

% encoder('data/im2.png','data/m_im2.pbm','data/res_im2.png');
% decoder('data/m_im2.pbm','data/res_im2.png','data/im2.png','data/restored_im2.png');