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
      plot(bins, histogram(i).r', 'r', ...
           bins, histogram(i).g', 'g', ...
           bins, histogram(i).b', 'b'); 
      axis([0 255 0 1]), axis('auto y');
      title(sprintf('Class-%s', map_number_to_class(i)));
    end
  end
  
  % Extract representatives features for each class
  for i = 1:number_of_classes
    r_value = find(histogram(i).r == max(histogram(i).r));
    g_value = find(histogram(i).g == max(histogram(i).g));
    b_value = find(histogram(i).b == max(histogram(i).b));
    features(i) = struct('r', r_value(1), ...
                         'g', g_value(1), ...
                         'b', b_value(1));
    % Recover the actual bins
    features(i).r = features(i).r * 256/length(bins);
    features(i).g = features(i).g * 256/length(bins);
    features(i).b = features(i).b* 256/length(bins);
  end
end
