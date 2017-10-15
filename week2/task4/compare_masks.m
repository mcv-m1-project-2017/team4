function [ score ] = compare_masks (mask_gt, mask)
  % Accumulate pixel performance of the current image %%%%%%%%%%%%%%%%%
  [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(mask, mask_gt);
  [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
  f1Score = (2 * pixelPrecision * pixelAccuracy) / (pixelPrecision + pixelAccuracy);
  score = f1Score;
end
