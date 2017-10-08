function [ paths_of_computed_masks ] = predict(features, paths)
  % COLOUR SEGMENTATION PREDICTION: Given an average colour histograms do a 
  %   segmentation and save it as a mask in a PNG format.
  global number_of_classes
  for i=1:size(paths)
    image = imread(paths(i,:));
    
    % If all the three colour channels are equal than feature of a class, the 
    %  pixel belongs to that class.
%    red_mask = image(:,:,1) == features(1).r;
%    green_mask = image(:,:,2) == features(1).g;
%    blue_mask = image(:,:,3) == features(1).b;
%    mask = red_mask & green_mask & blue_mask;
    
    % Iterate over all classes
    mask = zeros(size(image(:,:,1)));
    for class=1:number_of_classes
      % If all three colour channels are similar than feature of a class, mark 
      %  that pixel belonging to that class.
      threshold = 10;
      red_mask = (image(:,:,1) > features(class).r - threshold) & ...
                 (image(:,:,1) < features(class).r + threshold);
      green_mask = (image(:,:,2) > features(class).g - threshold) & ...
                   (image(:,:,2) < features(class).g + threshold);
      blue_mask = (image(:,:,3) > features(class).b - threshold) & ...
                  (image(:,:,3) < features(class).b + threshold);
      mask |= red_mask & green_mask & blue_mask;

      figure(2)
      imshow(image)
      figure(3)
      imshow(mask, [0, 1])
      pause(1)
    end
    imshow(mask, [0, 1])
    pause(3)
      
  end

  paths_of_computed_masks = [
  '/home/jon/mcv_repos/datasets/trafficsigns/validation/mask/mask.00.004815.png',
  '/home/jon/mcv_repos/datasets/trafficsigns/validation/mask/mask.00.005893.png',
  '/home/jon/mcv_repos/datasets/trafficsigns/validation/mask/mask.01.001340.png',
  '/home/jon/mcv_repos/datasets/trafficsigns/validation/mask/mask.01.001788.png',
];
end