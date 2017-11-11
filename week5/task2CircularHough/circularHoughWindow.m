clear
root = fileparts(fileparts(fileparts(pwd)));
path = fullfile(root, 'datasets', 'trafficsigns', 'split','Circular');
files = dir(strcat(path, '/*.jpg'));
imWidth =1628;
imHeight = 1236;
step = 10;
window = 100;
imax = uint32(imWidth/step)-1;
jmax = uint32(imHeight/step)-1;
circen = [];
cirrad=[];
for i = 1:size(files,1)

    im = imread(strcat(path, '/', files(i).name));
    img = rgb2gray(im);
    
    
    %Slide window through image
    for i = 1:imax
        for j = i:jmax
            
    
            imCropped = img(1+(j-1)*step:min(1+window+(j-1)*step,imHeight),1+(i-1)*step:min(1+window+(i-1)*step,imWidth));
            if (all (size(imCropped)>32))
                [accum, circenROI, cirradROI, dbg_LMmask] = CircularHough_Grd(imCropped,[10 40],2,10,0.7);
            end
            circenROI(:,1) = circenROI(:,1) + double((i-1)*step);
            circenROI(:,2) = circenROI(:,2) + double((j-1)*step);
            circen = [circen; circenROI];
            cirrad = [cirrad; cirradROI];
        end
    end
    
    close all;
    figure(2); imagesc(img); colormap('gray'); axis image;
    hold on;
    plot(circen(:,1), circen(:,2), 'r+');
    for k = 1 : size(circen, 1),
        DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'b-');
    end
  
end