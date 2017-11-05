function imdist = getDistImage(image)
    canny = edge(image, 'canny');
    %figure, imshow(canny);

    imdist = bwdist(canny);
end