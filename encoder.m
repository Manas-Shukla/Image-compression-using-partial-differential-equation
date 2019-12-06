function encoder( imagePath,maskPath,maskedImagePath )
%ENCODER 

%  takes input image(3 channel) and generates an mask, 
% saves mask and mask applied on input image
% maskImagePath must have .pbm extension

    im = imread(imagePath);
    [m,n,~] = size(im);

    % get the edges using canny detector
    ed_im = edge(rgb2gray(im),'canny');     
    mask_im = uint8(ones(m,n,3));

    % exclude neighbour of pixel around edges also in mask
    window = 3;
    pd = (window-1)/2;

    % padded mask
    pmsk = padarray(mask_im,[pd,pd]);

    for i=pd+1:pd+m
        for j=pd+1:pd+n
            % exclude the neighbour if edge found
            if ed_im(i-pd,j-pd)
                pmsk(i-pd:i+pd,j-pd:j+pd,:) = 0;
            end
        end
    end

    % extract the mask out of padded array
    mask_im = pmsk(pd+1:pd+m,pd+1:pd+n,:);

    % we also exclude the boundary pixels of image in the mask
    % this will help us in generating the background in less time
    mask_im(1,:,:) = 0;
    mask_im(m,:,:) = 0;
    mask_im(:,1,:)= 0;
    mask_im(:,n,:) = 0;
    
    % generate image with negation to mask applied to it 
    % this will give us pixels on and near edges and rest 0 everywhere
    res_im = (1-mask_im).*im;

    figure;
    imshow(mask_im);
    title('Mask');
    pause(2);
    figure;
    imshow(res_im);
    title('Result');
    
    % make the mask logical before saving
    mask_im = logical(mask_im);
    
    % save these images for compressing 
    imwrite(mask_im,maskPath);
    imwrite(res_im,maskedImagePath);


end

