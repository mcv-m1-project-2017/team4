function output = binarize(input, threshold)
  output = input;
  %output(output <  threshold) = 0.0;
  output(output >= threshold) = 1.0;
end