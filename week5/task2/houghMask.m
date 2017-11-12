function [ maskFinal ] = houghMask(image, regionProposals, models)
% Hough Mask: Apply a Hough Transform over an image using the given models over some region proposals.
%
%{
Jonatan Poveda
Martí Cobos
Juan Francesc Serracant
Ferran Pérez
Master in Computer Vision
Computer Vision Center, Barcelona
---------------------------
Project M1/Week5
---------------------------
input:  - image: nxmx3 image
        - regionProposals: k-vector with region proposals using 'regionprops' function
        - models: object containing nxm matrix models to be found using Hough Transform
                  it needs to contain the following attributes: 'triangular_up', 'triangle_down'
output: - masks: nxmxk binary matrices representing the resulting masks for each proposed
%}
  rp = regionProposals;  % alias
  extraMargin = 10;

  k = 1; % output index
  maskFinal = false(size(image,1),size(image,2));

  for region = 1:size(rp,1)
  %for j = b:b %1:size(rp,1)
    %fprintf('\tChecking blob %d\n', j)
    minr = round(max(rp(region).BoundingBox(2) - extraMargin, 1));
    minc = round(max(rp(region).BoundingBox(1) - extraMargin, 1));
    maxr = round(min(rp(region).BoundingBox(2) + rp(region).BoundingBox(4) + extraMargin, size(image,1)));
    maxc = round(min(rp(region).BoundingBox(1) + rp(region).BoundingBox(3) + extraMargin, size(image,2)));
    signalMask = image(minr:maxr, minc:maxc,:);

    m = size(signalMask,1);
    n = size(signalMask,2);
    mask = zeros(m,n);

    model_found = false;
    %[sy, sx] = centerSquare(signalMask);
    sy = -1; sx = -1;
    if sy > 0 && sx > 0
      resizedModel = imresize(squ, [m n]);
      tly = tuy; tlx = tux;
      model_found = true;

    else
      [tuy, tux] = centerTriangleUp(signalMask);

      if tuy > 0 && tux > 0
        resizedModel = imresize(models.triangular_up, [m n]);
        tly = tuy; tlx = tux;
        model_found = true;

      else
        [tdy, tdx] = centerTriangleDown(signalMask);

        if tdy > 0 && tdx > 0
          resizedModel = imresize(models.triangular_down, [m n]);
          tly = tdy; tlx = tdx;
          model_found = true;
        end % if tdy > 0 && tdx > 0

     end % if tuy > 0 && tux > 0
   end % if sy > 0 && sx > 0

    if model_found
        tly = max(tly,1);
        tlx = max(tlx,1);

        % XXX: 'mask' is changing its size with this command
        disp_mask_size = size(mask)
        mask(tly:(tly+m-1), tlx:(tlx+n-1)) = resizedModel;
        disp_mask_size = size(mask)
    end % if model is found

    % FIXME: delete the next 3 lines
%    opath = fullfile(root, 'datasets', 'trafficsigns', 'tmp', 'test5');
%   path = fullfile(opath, [num2str(round(rand(1)*10000)) '_' num2str(region) '_t.png']);
%   imwrite(mask, path);

    % Save mask
    % BUG: 'mask' sometimes is not this size and there is a dimension mismatch on the next command
    disp_size_maskFinal = size(maskFinal(minr:maxr, minc:maxc))
    maskFinal(minr:maxr, minc:maxc) = maskFinal(minr:maxr, minc:maxc) | mask;
    k = k + 1;

  end  % for each region proposal

end % function
