function [ histograms, bins ] = average_histograms (paths)
  % AVERAGE HISTOGRAMS Computes an average of colour histograms 
  % The output structure is a list of histograms, one per class found,
  %   each of one containing 3 named fields: 'r', 'g', 'b' related to red, 
  %   green and blue channel respectively.
  global dataset_path
  global number_of_classes
  debug = false;
 
  %% Prepare dataset for training
  % Initialize output (expected to have classes from A to F)
  for i = 1:number_of_classes
    histograms(i) = struct('r', 0, 'g', 0, 'b', 0);
  end
  n_images = 0;
  for i = 1:size(paths)
    %% Read file and its annotations
    image_path = paths(i,:);
    image_filename = strsplit(image_path, '/');
    image_filename = image_filename{end};
    name_and_ext = strsplit(image_filename, '.');
    image_name = strcat(name_and_ext{1}, '.', name_and_ext{2});
    annotation_path = fullfile(fileparts(image_path), 'gt', strcat('gt.', image_name, '.txt'));
    [bb, signs] = LoadAnnotations(annotation_path);
    
    % Iterate over all the annotations of each image
    for annotation = 1:size(bb,1)
      class = map_class_to_number(signs{annotation});
      if debug
        fprintf('Processing (image_name,sign,class): %s, %d, %d\n', image_name, annotation, class)
      end
      limits = [
        floor(bb(annotation).y), 
        floor(bb(annotation).y + bb(annotation).h), 
        floor(bb(annotation).x), 
        floor(bb(annotation).x + bb(annotation).w)
      ] + 1;   % Indexes in Octave/Matlab starts at 1 while an image starts with 0
      cropped_image = crop_image(image_path, limits);
      
      % Uncomment the next two lines to save the cropped image
%      cropped_image_path = fullfile(fileparts(paths(i,:)), 'cropped', strcat('crop', sprintf('%d', annotation), '_', image_filename))
%      imwrite(cropped_image, cropped_image_path)

      % Get histograms
      n_bins = 16;
      [red_hist bins] = imhist(cropped_image(:,:,1), n_bins);
      green_hist = imhist(cropped_image(:,:,2), n_bins);  
      blue_hist = imhist(cropped_image(:,:,3), n_bins); 
      
      % Normalize histogram by crop size
      norm = sum(red_hist);
      r_tmp = red_hist / norm;       
      g_tmp = green_hist / norm;       
      b_tmp = blue_hist / norm;       
      
      % Accumulate histograms
      histograms(class).r = histograms(class).r + r_tmp;
      histograms(class).g = histograms(class).g + g_tmp;
      histograms(class).b = histograms(class).b + b_tmp;
      n_images = n_images + 1;
      
      if debug
        disp(image_path)
        disp(annotation_path)
        imshow(cropped_image, [])
        plot(x, r_tmp, 'r', x, g_tmp, 'g', x, b_tmp, 'b');
        axis([1 256 0 1]), axis 'auto y'
      end
  end
  histograms(class).r = histograms(class).r / n_images;
  histograms(class).g = histograms(class).g / n_images;
  histograms(class).b = histograms(class).r / n_images;
  
end
