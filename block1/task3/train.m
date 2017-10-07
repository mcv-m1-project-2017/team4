function [ values ] = train (paths) 
% COLOUR SEGMENTATION TRAINING: Average colour histograms
  histogram = average_histograms(paths);
  values = histogram(1).r;
  bins = 1:length(values);

  for i=1:6  
    subplot(2,3,i);
    plot(
      bins, histogram(i).r', 'r',
      bins, histogram(i).g', 'g',
      bins, histogram(i).b', 'b'
    ); title(sprintf('Class-%s', map_number_to_class(i)));
    axis([0 255 0 1])
    axis('auto y')
%  plot(
%    bins, histogram(1).r, 'r'
%  ); legend('Class A averaged colour histograms');
end
%  
%  global dataset_path
%  disp(dataset_path)
%  debug=false
% 
%  %% Prepare dataset for training
%  for i=1:10
%    histogram(i) = struct('r', 0, 'g', 0, 'b', 0);
%  end
%  n_images= 0;
%  for i=1:size(paths)
%    %% Read file and its annotations
%    %image_path = strcat(directory,'/',files(i).name);
%    %annotation_path = strcat(directory, '/gt/gt.', files(i).name(1:size(files(i).name,2)-3), 'txt');
%    image_path = paths(i,:)
%    image_filename = strsplit(image_path, '/'){end};
%    image_name = strcat(strsplit(image_filename, '.'){1},
%                        '.',
%                        strsplit(image_filename, '.'){2})
%    annotation_path = fullfile(fileparts(paths(i,:)), 'gt', strcat('gt.', image_name, '.txt'))
%
%    [windowAnnotation, signs] = LoadAnnotations(annotation_path);
%    class = map_class_to_number(signs{1})
%    
%    % Iterate over all the annotations of each image
%    for annotation=1:size(windowAnnotation,1)
%      if debug
%        sprintf('Processing image/annotation: %s/%d, ', image_name, annotation)
%        fflush(stdout);
%      end
%      limits = [
%        floor(windowAnnotation(annotation).y), 
%        ceil(windowAnnotation(annotation).y+windowAnnotation(annotation).h), 
%        floor(windowAnnotation(annotation).x), 
%        ceil(windowAnnotation(annotation).x+windowAnnotation(annotation).w)
%      ]+1;   % Indexes in Octave/Matlab starts at 1 while an image starts with 0
%      cropped_image = task3_crop_image(image_path, limits);
%%      cropped_image_path = fullfile(fileparts(paths(i,:)), 'cropped', strcat('crop', sprintf('%d', annotation), '_', image_filename))
%%      imwrite(cropped_image, cropped_image_path)
%
%      % Get histograms
%      [red_hist x] = imhist(cropped_image(:,:,1));
%      green_hist = imhist(cropped_image(:,:,2));  
%      blue_hist = imhist(cropped_image(:,:,3)); 
%      
%      % Normalize histogram by crop size
%      norm = sum(red_hist);
%      r_tmp = red_hist/norm;       
%      g_tmp = green_hist/norm;       
%      b_tmp = blue_hist/norm;       
%      
%      % Accumulate histograms
%      histogram(class).r += r_tmp;
%      histogram(class).g += g_tmp;
%      histogram(class).b += b_tmp;
%      n_images += 1;
%      
%%      if debug
%%        disp(image_path)
%%        disp(annotation_path)
%%        imshow(cropped_image, [])
%%        plot(x, r_tmp, 'r', x, g_tmp, 'g', x, b_tmp, 'b');
%%        axis([1 256 0 1]), axis 'auto y'
%%      end
%  end
%  histogram(class).r =/ n_images;
%  histogram(class).g =/ n_images;
%  histogram(class).b =/ n_images;
        
%end  
%  
%  [ avg_r, avg_g, avg_b ] = extract_averages(paths);
%  x = 1:length(avg_r);
%  plot(x, avg_r, 'r', x, avg_g, 'g', x, avg_b, 'b');
%  %image = imread('../datasets/train/00.000948.jpg');
%  %imshow(image)
%  %mask = cs_image_to_mask(image, [avg_r, avg_g, avg_b], [50, 100, 50], [50, 50, 100]);
%  %imshow(mask(:,:,3),[])
%  values = 1
%end