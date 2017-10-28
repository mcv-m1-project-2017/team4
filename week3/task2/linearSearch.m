function [ region_proposals, mask_of_positive_objects ] = linearSearch ( image, window )
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
This function does a linear and naive search over a mask and return the pixels
which context has some properties defined for `decisionTree`.
input:  - image: nxm binary mask
        - window: nxm (even size) binary matrix that will be applied to determine
          which area analyze from the mask. Must be smaller than the mask.
output: - list of pixels susceptible to be from an object.
---------------------------
%}
  debug = false;

  % Init vars
  is_a_signal = false;
  center = ((size(window,1)-1)/2);

  % Find pixel candidates
  candidates = findCandidates(image);

  % The mask of positives objects is used to remove areas detected as positives,
  % so not more search has to be done close to it.
  mask_of_positive_objects = true(size(image));

  % Init
  i = 1;
  pixel_proposals(i,:) = [0 0];

  regions_scanned = 0;
  % Check each candidate and save positive ones
  for candidate = 1:size(candidates,1)
    if debug
      sprintf('Checking candidate %d', candidate)
    end
    c = candidates(candidate,:);
    range = [c(1)-center, c(1)+center, c(2)-center, c(2)+center];
    % try
      region = image(range(1):range(2), range(3):range(4)).*window;
      regions_scanned = regions_scanned + 1;
      if debug
        sprintf('Checking region %d', regions_scanned);
      end

      % If the region looks like a traffic sign keep it
      signalClass = checkRegion(region, 0);

      if strcmp(signalClass,'X')
       % If it seems to be an object save coordinates ...
        pixel_proposals(i,:) = c;
        i = i + 1;

        % ... and remove positive area (image AND NOT mask_of_positive_objects)
        starting = pixel_proposals - center;
        ending = pixel_proposals + center;
        mask_of_positive_objects(starting(1):ending(1), starting(2):ending(2)) = ~window;
        image = image & mask_of_positive_objects;
      end
    % catch
      % Skip if a window cannot be centered on this pixel
      if debug
        sprintf('(%d,%d) Skipped!', c(1), c(2))
      end
    % end
  end
  sprintf('Number of regions scanned: %d/%d', ...
          regions_scanned, size(candidates, 1))

  region_proposals = false(size(pixel_proposals,1),5);
  for j = 1:size(pixel_proposals,1)
    region_proposals(j,1:4) = pixel_to_region(pixel_proposals(j,:), window);
    % TODO add the right class (given by 'checkRegion' function)
    region_proposals(j,5) = 'A';
  end

end
