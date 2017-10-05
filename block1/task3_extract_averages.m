function [ r, g, b ] = cs_extract_averages( directory )
%EXTRACT_AVERAGE_COLOURS Summary of this function goes here
%   Detailed explanation goes here

    files = ListFiles(directory);
    %for i=1:size(files,1),
    for i=1:1,
        disp(i)
        % Read file
        im = imread(strcat(directory,'/',files(i).name));
        pixelAnnotation = imread(strcat(directory, '/mask/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;
        masked = im.*pixelAnnotation;
        
        indexes = find(a(1,:)==0)
        [h, w] = size(masked);
        count_zeros = sum(a==0);
        
        
    end
    
    r = 100;
    g = 50;
    b = 50;

end
