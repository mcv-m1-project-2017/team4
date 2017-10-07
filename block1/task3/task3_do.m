function [] = task3_do () 
  addpath('../:../evaluation/')

  [ avg_r, avg_g, avg_b ] = task3_extract_averages('../../datasets/train');
  x = 1:length(avg_r);
  plot(x, avg_r, 'r', x, avg_g, 'g', x, avg_b, 'b');
  %image = imread('../datasets/train/00.000948.jpg');
  %imshow(image)
  %mask = cs_image_to_mask(image, [avg_r, avg_g, avg_b], [50, 100, 50], [50, 50, 100]);
  %imshow(mask(:,:,3),[])
end