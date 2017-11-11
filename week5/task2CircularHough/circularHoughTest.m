clear
root = fileparts(fileparts(fileparts(pwd)));
path = fullfile(root, 'datasets', 'trafficsigns', 'split','Circular');
files = dir(strcat(path, '/*.jpg'));

for i = 1:size(files,1)
    close all;
    im = imread(strcat(path, '/', files(i).name));
    img = double(rgb2gray(im));
    
    [grdx, grdy] = gradient(img);
    grdmag = sqrt(grdx.^2 + grdy.^2);
    
    
    imgEnhanced = img + grdmag;

    [accum, circen, cirrad, dbg_LMmask] = CircularHough_Grd(imgEnhanced,[20 40],50,10,0.7);
        
    figure();
    subplot(2,2,1);imshow(img,[]);
    subplot(2,2,2);imshow(grdmag,[]);
    subplot(2,2,3);imshow(imgEnhanced,[]);
    
    subplot(2,2,4); imagesc(img); colormap('gray'); axis image;
    hold on;
    plot(circen(:,1), circen(:,2), 'r+');
    for k = 1 : size(circen, 1),
        DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'b-');
    end
  
end