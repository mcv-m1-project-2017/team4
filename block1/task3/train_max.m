function [ features ] = train_max (paths) 
  % TRAIN MAX: Average colour histograms and compute its maximum.
  
  global number_of_classes
  number_of_classes = uint8('F') - uint8('A') + 1;
  plot_histograms = false;
  
  % Compute the averaged histogram for each class
  [ histogram, bins ] = average_histograms(paths);

  if plot_histograms  
    figure(1)
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
