function [] = generateTestImages()
  tmp = zeros(300);
  point = tmp; point(150,150)=1;
  imwrite(point, 'point.png', 'png');

  line = tmp;
  for i=1:300
    line(i,i)=1;
  end
  imwrite(line, 'line.png', 'png');

  cross = line | rot90(line);
  imwrite(cross, 'cross.png', 'png');

  hline = tmp;
  hline(200,:)=1;
  triangle = cross | hline;
  imwrite(triangle, 'triangle.png', 'png');
end % function
