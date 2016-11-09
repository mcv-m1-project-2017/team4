% Set-up UCM
cd MCG-PreTrained
install
cd ..

ima_name = '00.000948.jpg';
ima = imread(ima_name);

seg = segment_ucm(ima, 0.8);

%imshow(label2color(seg));
imwrite(label2color(seg), '00.000948_seg.png');



