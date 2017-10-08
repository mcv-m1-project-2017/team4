function [ features ] = train_gaussian (paths) 
  % TRAIN GAUSSIAN: Average colour histograms and compute a gaussian function 
  %   over it.
  
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
  
  global hhh
  hhh =  histogram(1);
  % Extract representatives features for each class
  for i = 1:number_of_classes
    fake_data = reconstruct_data(histogram(i).r, bins);
    [ r_mu, r_sigma ] = normfit(fake_data);
    fake_data = reconstruct_data(histogram(i).g, bins);
    [ g_mu, g_sigma ] = normfit(fake_data);
    fake_data = reconstruct_data(histogram(i).b, bins);
    [ b_mu, b_sigma ] = normfit(fake_data)
    features(i) = struct('r', [r_mu r_sigma], ...
                         'g', [g_mu g_sigma], ...
                         'b', [b_mu b_sigma]);
    
    % Recover the actual bins
%    features(i).r = features(i).r * 256/length(bins);
%    features(i).g = features(i).r * 256/length(bins);
%    features(i).b = features(i).r * 256/length(bins);
  end
end
