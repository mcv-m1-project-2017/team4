% function [ output ] = multiscaleSearch( image )
%{
Jonatan Poveda
Martí Cobos
Juan Francesc Serracant
Ferran Pérez
Master in Computer Vision
Computer Vision Center, Barcelona
---------------------------
Project M1/Week3
---------------------------
This function is used to do a multi-scale search over a given binary image and
select candidates which corresponds to a probable traffic signs.
input:  - image: nxm binary image
output: - list of regions: 5xm matrix of susceptible regions to contain a
          traffic sign and its type (A,B,C,D,E or F) or no detection (X).
          Each row is a region formatted as [x, y, w, h, type]
---------------------------
%}
  image = iMask;
  plot = false;
  debug = true;

  % Init vars
  window = ones(11, 11); % Must be odd to have a center pixel
  scale = 2;

  % Do as many scale downs as the image is 4 times the box (we expect the
  % traffic sign to be as large as 0.25 the original image.
  minimum_size = 4 * size(window,1);

  %% Compute scale downs' size and add some padding in order to the image is
  % multiple of 2 as many times as needed.
  i = 1;
  layers{i} = image;
  original_size = size(layers{i});
  layer_size = original_size;
  while min(layer_size) > minimum_size
    i = i + 1;
    layer_size = ceil(layer_size / scale);
  end
  padded_size = layer_size * scale^(i-1);
  sprintf('Scaling mask from %dx%d to %dx%d', ...
          original_size(1), original_size(2), padded_size(1), padded_size(2))

  % 0-Padding is added to the rightest column and lowest row. This padding would
  % not affect to the mask because we are retreving 1-valued pixels.
  % NOTE: remember to remove padding at the end of the process
  padded_image = padarray(image, padded_size - original_size, 0, 'post');

  % Compute Gaussian Pyramids' of the given image (called layers from now on)
  % Note `layers{1}` is the original image (padded)
  layers{1} = padded_image;
  i = 1;
  while min(size(layers{i})) > minimum_size
    i = i + 1;
    layers{i} = impyramid(layers{i-1}, 'reduce');
  end

  if plot
    for i = (1:size(layers,2))+10
      figure(i), imshow(layers{i});
    end
  end

  % Build a mask iteratively to remove found objects from further analysis.
  mask = true(size(layers{end}));

  %% Starting from the smaller layer find a traffic sign
  n_layers = size(layers,2);
  for n = n_layers:-1:1
    sprintf('Processing layer number: %d', n)
    layer = layers{n};

    % Scale up the mask to match the layer
    if n ~= 6
      mask = imresize(mask, scale);
    end

    % 'Remove' area in the next iteration with the region, scaled up, which has a center in pixel_proposals(k)
    layer = layer & mask;
    [regions, mask] = linearSearch(layer, window);
    figure(1), subplot(2,2,2), imshow(mask), title('Output mask'), pause(3)
  end
  figure(1), subplot(2,2,3), imshow(mask), title('FINAL Output mask');
% end
