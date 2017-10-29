function [ output ] = mss( mask )
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
This function is used to do a multi-scale search over a given mask and
select candidates which corresponds to a probable traffic signs.
input:  - image: nxmx3 image
        - mask: nxmx1 mask with the same size as the image
output: - list of regions susceptible to contain a traffic sign and its
type (A,B,C,D,E,F) or no detection (X).
---------------------------
%}
% Implementation of a Multi-Scale Search
% Run w3_main.m before this one

plot = false;
debug = true;
% plot = true;

%   tic
window = ones(11, 11); % Must be odd to have a center pixel

% Compute reductions size and 0-pad the original mask in order to be multiple of
% 2 as many times as needed. The padding is added on the right-low-most corner.
% 0-padding would not affect to the mask because we are retreving 1-valued pixels.
% NOTE: remember to remove padding at the end of the process
minimum_size = 4 * size(window,1);
i = 1;
pyr{i} = mask;
original_size = size(pyr{i});
reduction_size = original_size;
while min(reduction_size) > minimum_size
  i = i + 1;
  reduction_size = ceil(reduction_size / 2);
end
padded_size = reduction_size * 2^(i-1);
sprintf('Scaling mask from %dx%d to %dx%d', ...
        original_size(1), original_size(2), padded_size(1), padded_size(2))
padded_mask = padarray(mask, padded_size - original_size, 0, 'post');

% Do as many reductions as the image is 4 times the box (we expect the
% traffic sign to be as large as 0.25 the image.
i = 1;
pyr{i} = padded_mask;
pyr_int{i} = integral_image(pyr{i});
while min(size(pyr{i})) > minimum_size
  i = i + 1;
  pyr{i} = impyramid(pyr{i-1}, 'reduce');
  pyr_int{i} = integral_image(pyr{i});
end

if plot
  for i = 1:size(pyr,2)
    figure(i), imshow(pyr{i});
  end
end

%% Look at all the pyr{k} images to find a traffic sign
n_thumbnails = size(pyr,2);
mask_of_positive_objects = true(size(pyr{6}));

% mask_of_positive_objects(2:15, 1:15) = 0; % FIXME: delete this line

for n = n_thumbnails:-1:1
  sprintf('Processing reduction number: %d', n)
  im = pyr{n};
  im_int = pyr_int{n};
  % 'Remove' area in the next iteration with the region, scaled up, which has a center in pixel_proposals(k)
  % Region is a 'box' centered on the pixel_proposals(k).
  % To scale up, ...
  % [n, size(im), size(mask_of_positive_objects)]

  if n ~= 6
    mask_of_positive_objects = imresize(mask_of_positive_objects, 2);
  end
  size(mask_of_positive_objects);

  im = im & mask_of_positive_objects;

  [pixel_proposals, mask_of_positive_objects] = linearSearch(im, im_int, window);
  % subplot(2,1,1), imshow(mask_of_positive_objects);
  % subplot(2,1,2), imshow(im);
  % pause(2)
  % break;  % FIXME: delete me
end

   output = mask_of_positive_objects;
end
