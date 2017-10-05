function [ mask ] = task3_image_to_mask( image, red, green, blue )
%CS_IMAGE_TO_MASK Given an image and colour threshold it extracts a binary mask.
    mask_red = image(:,:,1)>red(1) & image(:,:,2)<red(2) & image(:,:,3)<red(3);
    mask_green = image(:,:,1)<green(1) & image(:,:,2)>green(2) & image(:,:,3)<green(3);
    mask_blue = image(:,:,1)<blue(1) & image(:,:,2)<blue(2) & image(:,:,3)>blue(3);
    mask(:,:,1) = mask_red+0.0;
    mask(:,:,2) = mask_green+0.0;
    mask(:,:,3) = mask_blue+0.0;
%    mask = mask_red;
end

