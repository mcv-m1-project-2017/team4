function [ crop ] = task3_crop_image ( image_path, annotation_path)
% Given an image and its annotations crop it
        % Read image
        image = imread(image_path);

        % Read annotations and extract bounding box
		    windowAnnotation = LoadAnnotations(annotation_path);       
        limits = [
                  floor(windowAnnotation.y), 
                  ceil(windowAnnotation.y+windowAnnotation.h), 
                  floor(windowAnnotation.x), 
                  ceil(windowAnnotation.x+windowAnnotation.w)
                  ];
        crop = image(limits(1):limits(2),limits(3):limits(4),:);
end
