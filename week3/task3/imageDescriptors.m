%
% Function used to obtain basic descriptors from image
%

function [descriptors] = imageDescriptors(image, mask, boundingBox)

    % TrafficSignDetection
    % Obtain basic descriptors from a given image, mask and its bounding box.
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'image'            nxmx3 array representing image to be analyzed
    %    'mask'             nxm array representing image mask
    %    'boundingBox'      mask bounding box coordinates (TopLeftY, TopLeftX, BottomRightY, BottomRightX)
    %   
    %     descriptor    array containing descriptors
    %     descriptor(1) -> maximum intensity in red channel
    %     descriptor(2) -> minimum intensity in red channel
    %     descriptor(3) -> maximum intensity in green channel
    %     descriptor(4) -> minimum intensity in green channel
    %     descriptor(5) -> maximum intensity in blue channel
    %     descriptor(6) -> minimum intensity in blue channel
    %     descriptor(7) -> maximum intensity in red channel (after
    %     white-patching)
    %     descriptor(8) -> minimum intensity in red channel (after
    %     white-patching)
    %     descriptor(9) -> maximum intensity in green channel (after
    %     white-patching)
    %     descriptor(10) -> minimum intensity in green channel (after
    %     white-patching)
    %     descriptor(11) -> maximum intensity in blue channel (after
    %     white-patching)
    %     descriptor(12) -> minimum intensity in blue channel (after
    %     white-patching)
    %     descriptor(13) -> height
    %     descriptor(14) -> width
    %     descriptor(15) -> form factor (width/height)
    %     descriptor(16) -> mask area
    %     descriptor(17) -> bounding box area
    %     descriptor(18) -> filling ratio (mask area / bounding box area)
    %     
    
    descriptors = zeros(18,1); 
    
    %%modify mask inorder to avoid errors when masks are not well defined
    mask(mask>0)=1;
%     Apply mask to RGB image

    R = image(:,:,1);
    G = image(:,:,2);
    B = image(:,:,3);    
    Rmax = max(R(:));
    Gmax = max(G(:));
    Bmax = max(B(:));
    R(mask == 0) = 0;
    G(mask == 0) = 0;
    B(mask == 0) = 0;
    
    
%     Perform white pattching algorithm in order to eliminate color and
%     intensity changes through differnet images
    RWP = R.*(255/Rmax);
    GWP = G.*(255/Gmax);
    BWP = B.*(255/Bmax);

%   Analyze Bounding box

    topLeftY = boundingBox(1);
    topLeftX = boundingBox(2);
    bottomRightY = boundingBox(3);
    bottomRightX = boundingBox(4);

    height = bottomRightY-topLeftY;
    width = bottomRightX-topLeftX;
    %modify mask in order to only accept values inside the BB
    BBmask = zeros (size(R));
    BBmask(int32(topLeftY):int32(bottomRightY),int32(topLeftX):int32((bottomRightX))) = 1;
    mask(BBmask ==0)=0;
    maskArea = sum(mask(:));
    boundingBoxArea=height*width;


%   Obtain descriptors
    descriptors(1) = max(R(mask==1));
    descriptors(2) = min(R(mask==1));
    descriptors(3) = max(G(mask==1));
    descriptors(4) = min(G(mask==1));
    descriptors(5) = max(B(mask==1));
    descriptors(6) = min(B(mask==1));
    descriptors(7) = max(RWP(mask==1));
    descriptors(8) = min(RWP(mask==1));
    descriptors(9) = max(GWP(mask==1));
    descriptors(10) = min(GWP(mask==1));
    descriptors(11) = max(BWP(mask==1));
    descriptors(12) = min(BWP(mask==1));
    descriptors(13) = height;
    descriptors(14) = width;
    descriptors(15) = height/width;
    descriptors(16) = maskArea;
    descriptors(17) = boundingBoxArea;
    descriptors(18) = maskArea/boundingBoxArea;
    
end