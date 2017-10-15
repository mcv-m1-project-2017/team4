function [ p ] = segmentation(image, amodels, bmodels)
%{
Jonatan Poveda
Martí Cobos
Juan Francesc Serracant
Ferran Pérez
Master in Computer Vision
Computer Vision Center, Barcelona
---------------------------
Project M1/Block2
---------------------------
This function is used to segment an image using two image colour histograms.
input:  - image:  nxmx3 array representing image to be analyzed
        - amode: nxmx3 a-colour histogram of the 3 classes
        - bmodels: nxmx3 b-colour histogram of the 3 classes
output: - p: nxmx3 array representing pixel probabilites of belonging to 3 classes
% output: - mask: nxm array representing image mask
---------------------------
%}
  plot_histogram_comparison = false;
  %%Evaluate the image histogram
  nBins = size(amodels,2);
  mask = zeros(size(image(:,:,1)));

  if plot_histogram_comparison
    % Set the bounding box as all the image
    % TODO: Remove need of a bounding box in calculateHistogram
    mask = ones(size(image(:,:,1)));
    BB = [1,1, size(image,1), size(image,2)];
    [aColorHistogram, bColorHistogram] = calculateHistogram (image, mask, BB, nBins);

    figure();
    subplot(2,2,1), plot(aColorHistogram), title('test image a-hist');
    subplot(2,2,2),plot(bColorHistogram),  title('test image b-hist');

    subplot(2,2,3), plot(amodels'),  title('a-model'), legend('A-B-C', 'D-F', 'E');
    subplot(2,2,4), plot(bmodels'), title('b-model'), legend('A-B-C', 'D-F', 'E');
  end

  % Calculate probability
  % for each pixel as the right colourspace calculate probability using models
  im = rgb2lab(image);
  a_channel = im(:,:,2);
  b_channel = im(:,:,3);

  counts = linspace(-100,100,nBins+1);
  n_classes = size(amodels,1);

  % For each pixel find its probability and Acummulate
  probability = nan(size(im,1), size(im,2), size(amodels,1)); % probability of image belonging to a class
  pixel_probability = 0;
  for i=1:size(im,1)
    for j=1:size(im,2)
      pa = a_channel(i,j);
      pb = b_channel(i,j);
      % Find closest bin to the pixel value
      dist_a = abs(counts - pa);
      dist_b = abs(counts - pb);
      closest_bin_a = find(dist_a==min(dist_a));
      closest_bin_b = find(dist_b==min(dist_b));
      for class = 1:n_classes
        model_a = amodels(class,:);
        model_b = bmodels(class,:);
        % [ size(pixel_probability), 99, size(model(closest_bin)), 99,  size(probability(class))]
        pixel_probability = model_a(closest_bin_a) * model_b(closest_bin_b);
        probability(i,j, class) = pixel_probability;
      end
    end
  end
  p = probability / numel(a_channel);
end
