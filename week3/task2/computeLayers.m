function [ layers ] = computeLayers ( image )

  plot = false;
  debug = false;

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

  if debug
    sprintf('Scaling mask from %dx%d to %dx%d', ...
            original_size(1), original_size(2), padded_size(1), padded_size(2))
  end

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

end
