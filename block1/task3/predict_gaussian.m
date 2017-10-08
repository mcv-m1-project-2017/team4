function [ paths_of_computed_masks ] = predict_gaussian(features, paths)
  % PREDICT GAUSSIAN: Given an average colour histograms predict a segmentation 
  %   and save it as a mask in a PNG format. Uses features which contains the 
  %   average and standard deviation of the maximum of each 3-channel colour 
  %   histogram.
  
  global number_of_classes
  show_masks = false;
  output_folder = fullfile(fileparts(fileparts(paths(1,:))), 'validation', 'mask');
  
  for i=1:size(paths)
    image_path = paths(i,:);
    tmp = strsplit(image_path, '/');
    image_filename = tmp{end};
    tmp = strsplit(image_filename, '.');
    image_name = strcat(tmp{1},'.',tmp{2});
    image = imread(image_path);
    mask = compute_mask_using_gaussian (image, features, 2);
    
    if show_masks
      imshow(mask, [0, 1])
      pause(3)
    end
    output_file = fullfile(output_folder, strcat('mask.', image_name, '.png'));
    fprintf('Saving mask %s to file %s\n', image_name, output_file);
    imwrite(mask, output_file, 'PNG');
    paths_of_computed_masks(i, :) = strcat(output_file);
  end
end