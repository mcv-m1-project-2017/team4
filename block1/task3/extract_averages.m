function [ r, g, b ] = extract_averages( paths )
  %EXTRACT_AVERAGE_COLOURS 
  debug=true;

  % initialize value accumulators
  r_acc = g_acc = b_acc = 0;

  disp('Reading images...')
  fflush(stdout);
  n_images = 0;
  for i=1:size(paths)
    %% Read file and its annotations
    %image_path = strcat(directory,'/',files(i).name);
    %annotation_path = strcat(directory, '/gt/gt.', files(i).name(1:size(files(i).name,2)-3), 'txt');
    image_path = paths(i,:)
    image_filename = strsplit(image_path, '/'){end};
    image_name = strcat(strsplit(image_filename, '.'){1},
                        '.',
                        strsplit(image_filename, '.'){2})
    annotation_path = fullfile(fileparts(paths(i,:)), 'gt', strcat('gt.', image_name, '.txt'))

%    annotation_path = strcat(directory, '/gt/gt.', files(i).name(1:size(files(i).name,2)-3), 'txt');
    %% Crop the image to get the traffic sign
    windowAnnotation = LoadAnnotations(annotation_path);
    
    % Iterate over all the annotations of each image
    for annotation=1:size(windowAnnotation,1)
      if debug
        sprintf('Processing image/annotation: %s/%d, ', image_name, annotation)
        fflush(stdout);
      end
      limits = [
        floor(windowAnnotation(annotation).y), 
        ceil(windowAnnotation(annotation).y+windowAnnotation(annotation).h), 
        floor(windowAnnotation(annotation).x), 
        ceil(windowAnnotation(annotation).x+windowAnnotation(annotation).w)
      ]+1;   % Indexes in Octave/Matlab starts at 1 while an image starts with 0
      cropped_image = task3_crop_image(image_path, limits);

      % Get histograms
      [red_hist x] = imhist(cropped_image(:,:,1));
      green_hist = imhist(cropped_image(:,:,2));  
      blue_hist = imhist(cropped_image(:,:,3)); 
      norm = sum(red_hist);
      
      % Normalize histogram by crop size
      r_tmp = red_hist/norm;       
      g_tmp = green_hist/norm;       
      b_tmp = blue_hist/norm;       
      
      % Accumulate histograms
      r_acc += r_tmp;
      g_acc += g_tmp;
      b_acc += b_tmp;
      n_images += 1;
      
%      if debug
%        disp(image_path)
%        disp(annotation_path)
%        imshow(cropped_image, [])
%        plot(x, r_tmp, 'r', x, g_tmp, 'g', x, b_tmp, 'b');
%        axis([1 256 0 1]), axis 'auto y'
%      end
  end

  r = r_acc/n_images;
  g = g_acc/n_images;
  b = b_acc/n_images;
end
