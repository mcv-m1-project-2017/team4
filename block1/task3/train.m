function [ features ] = train (paths) 
% COLOUR SEGMENTATION TRAINING: Average colour histograms
  global number_of_classes
  number_of_classes = uint8('F') - uint8('A') + 1;
  plot_histograms = false;
  
  % Compute the averaged histogram for each class
  [ histogram, bins ] = average_histograms(paths);

  if plot_histograms  
    figure(1)
%    bins = linspace(0, 255, length(histogram(1).r));
    for i = 1:number_of_classes
      subplot(2,3,i);
      plot(
        bins, histogram(i).r', 'r',
        bins, histogram(i).g', 'g',
        bins, histogram(i).b', 'b'
      ); 
      axis([0 255 0 1]), axis('auto y');
      title(sprintf('Class-%s', map_number_to_class(i)));
    end
  end
  
  % Extract representatives features for each class
  for i = 1:number_of_classes
    % NOTE: It is looking for the first maximum (could be greatly improved)  
    features(i) = struct('r', find(histogram(i).r == max(histogram(i).r))(1), 
                         'g', find(histogram(i).g == max(histogram(i).g))(1),
                         'b', find(histogram(i).b == max(histogram(i).b))(1)
                         );
    % Recover the actual bins
    features(i).r *= 256/length(bins);
    features(i).g *= 256/length(bins);
    features(i).b *= 256/length(bins);
  end
end

%end  
%  
%  [ avg_r, avg_g, avg_b ] = extract_averages(paths);
%  x = 1:length(avg_r);
%  plot(x, avg_r, 'r', x, avg_g, 'g', x, avg_b, 'b');
%  %image = imread('../datasets/train/00.000948.jpg');
%  %imshow(image)
%  %mask = cs_image_to_mask(image, [avg_r, avg_g, avg_b], [50, 100, 50], [50, 50, 100]);
%  %imshow(mask(:,:,3),[])
%  features = 1
%end