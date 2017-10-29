function [ mask, region_proposals ] = multiscaleSearch( image, geometricFeatures, params)
% multiscaleSearch: Multi-scale Search over a binary image
%
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
Multi-scale Search algorithm
1. Compute LAYERS using gaussian-pyrdamid
2. Generate an initial mask (half the size as first LAYER) with '1' values => MASK
3. For each LAYER (starting with the smallest one)
  3.0 Up-scale MASK to match the size the LAYER
  3.1 Apply MASK to LAYER
  3.2 Find '1' pixels => PIXEL CANDIDATEs
  3.3 For each PIXEL CANDIDATE
    - Is the region centered on that pixel is a traffic sign ? [CancellingMaskAlgorithm]
      TRUE: Update cancelling mask for region removal => MASK
      FALSE: do nothing
  3.4 Return MASK
4. Return MASK
(4.1) Apply MASK to original mask layer [this operation is perfomed outside this function]

% Cancelling Mask algorithm (given MASK,PIXEL CANDIDATE,WINDOW)
1. Build a matrix of ones with the same size as the current LAYER => MASK
2. Insert the (negated) WINDOW centered in the pixel candidate of this MASK => MASK
3. Return MASK
NOTE this algorithm can be improved removing pixel candidates while removing region

input:  - image: nxm binary image
        - params: from task1
        - geometricFeatures: from task1
output: - mask: nxm binary image
%}
  debug = false;
  scale = 2;
  win = true(11);

  % 1. Compute LAYERS using gaussian-pyrdamid
  layers = computeLayers(image);

  % 2. Generate an initial mask (half the size as first LAYER) with '1' values => MASK
  % Build a mask iteratively to remove found objects from further analysis.

  mask = true(size(layers{end}));
  % 3. For each LAYER (starting with the smallest one)
  %% Starting from the smaller layer find a traffic sign
  n_layers = size(layers,2);
  for n = n_layers:-1:1
    if debug
      sprintf('Processing layer number: %d', n)
    end
    layer = layers{n};

    % 3.0 Scale up the mask to match the layer
    if n ~= 6
      mask = imresize(mask, scale);
    end

    % 3.1 Apply MASK to LAYER
    layer = layer & mask;

    % 3.2 Find '1' pixels => PIXEL CANDIDATEs
    % Find pixel candidates
    candidates = findCandidates(layer);

    % 3.3 For each PIXEL CANDIDATE
    %  - Is the region centered on that pixel is a traffic sign ? [CancellingMaskAlgorithm]
    %    TRUE: Update cancelling mask for region removal => MASK
    %    FALSE: do nothing
    % The mask of positives objects is used to remove areas detected as positives,
    % so not more search has to be done close to it.
    % Init
    p = 1;
    pixel_proposals(p,:) = [0 0];
    regions_scanned = 0;

    for j = 1:size(candidates,1)

      candidate = candidates(j,:);
      if debug
        sprintf('Checking pixel %d,%d', candidate)
      end

      region = getRegion(mask, candidate, win);
      if ~region
        % Skip if a window cannot be centered on this pixel
        continue
      end
      regions_scanned = regions_scanned + 1;

      if debug
        sprintf('Checking region %d', regions_scanned);
      end

      %Is the region centered on that pixel is a traffic sign ? [CancellingMaskAlgorithm]
      % If the region looks like a traffic sign keep it
      class = checkRegion(region, geometricFeatures, params);

      if ~strcmp(class,'X')
        % If it seems to be an object save coordinates ...
        pixel_proposals(p,:) = candidate;
        p = p + 1;

        %    TRUE: Update cancelling mask for region removal => MASK
        mask = updateMask(mask, candidate, win);
      end
    end

    if debug
    sprintf('Number of regions scanned: %d/%d', ...
            regions_scanned, size(candidates, 1))
    end

  end
  % Compute region proposals based on pixels
  region_proposals = false(size(pixel_proposals,1),5);
  for j = 1:size(pixel_proposals,1)
    region_proposals(j,1:4) = pixel_to_region(pixel_proposals(j,:), win);
    % TODO add the right class (given by 'checkRegion' function)
    region_proposals(j,5) = 'A';
  end

  % Remove additional padding from mask
  mask = mask(1:size(image,1), 1:size(image,2));
end  % multiscaleSearch
