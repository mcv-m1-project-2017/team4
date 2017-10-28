function [fromModel] = calculateModel(image, mask, boundingBox, nBins)
%{
Jonatan Poveda
Martí Cobos
Juan Francesc Serracant
Ferran Pérez
Master in Computer Vision
Computer Vision Center, Barcelona
---------------------------
Project M1/Block2
---------------------------
This function is used to compute the image color histogram.
input:  - image:  nxmx3 array representing image to be analyzed
        - mask: nxm array representing image mask
        - boundingBox: mask bounding box coordinates (TopLeftY, TopLeftX, BottomRightY, BottomRightX)
output: - histogram: image color histogram
---------------------------
%}

    close all;
    % Modify mask inorder to avoid errors when masks are not well defined
    mask(mask>0)=1;


    % Analyze Bounding box
    topLeftY = boundingBox(1);
    topLeftX = boundingBox(2);
    bottomRightY = boundingBox(3);
    bottomRightX = boundingBox(4);

    ROImask = mask(int32(topLeftY):int32(bottomRightY),int32(topLeftX):int32((bottomRightX)));
    
    fromModel = imresize (ROImask,[40,40]);
end
