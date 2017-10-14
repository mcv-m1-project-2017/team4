function [mask] = segmentation(image, amodel, bmodel)
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
        - amode: colour histogram model a
        - bmodel: colour histogram model b
output: - mask: nxm array representing image mask
---------------------------
%}
  plot_histogram_comparison = false;
  %%Evaluate the image histogram
  nBins = size(amodel,2);

  if plot_histogram_comparison
    % Set the bounding box as all the image
    % TODO: Remove need of a bounding box in calculateHistogram
    mask = ones(size(image(:,:,1)));
    BB = [1,1, size(image,1), size(image,2)];
    [aColorHistogram, bColorHistogram] = calculateHistogram (image, mask, BB, nBins);

    figure();
    subplot(2,2,1), plot(aColorHistogram), title('test image a-hist');
    subplot(2,2,2),plot(bColorHistogram),  title('test image b-hist');

    subplot(2,2,3), plot(amodel'),  title('a-model'), legend('A-B-C', 'D-F', 'E');
    subplot(2,2,4), plot(bmodel'), title('b-model'), legend('A-B-C', 'D-F', 'E');
  end

  % Calculate probability
  % for each pixel as the right colourspace calculate probability using models
  im = rgb2lab(image);
  a = im(:,:,2);
  b = im(:,:,3);

  disp('size a'),   size(a)
  disp('a-range'),   [max(a(:)), min(a(:))]
  disp('b-range'),   [max(b(:)), min(b(:))]
  counts = linspace(-100,100,nBins+1);

  % FIXME: remove it
  % get one pixel
  [xpos,ypos] = find(a==max(a(:)));
  p = a(xpos, ypos);
  pixel_a = a(xpos, ypos)
  pixel_b = b(xpos, ypos)

  % Find closest bin to the pixel value
  dist = counts - pixel_a;
  disp('minium distance'), min(dist)
  position_where_to_compute_probability = find(dist==min(abs(dist)));

  class_1 = [amodel(1,:); bmodel(1,:)];
  size(class_1)
  for i=1:size(im,1)
    for j=1:size(im,2)
  %     % Foreach pixel
      % pixel = im(i,j);

    end
  end
end
