
    
    path = '..\Datasets\train';
    files=dir(strcat(path,'/*.jpg'));
    time_t6 = [];
    time_t4 = [];
    for i=1:length(files)
                i
                filepath=fullfile(path, files(i).name);
                close all;
                im = imread(filepath);
                imshow(im);
                figure;
                tic;
                maskR = ColorSegmentationt4(im,'red');
                maskB = ColorSegmentationt4(im,'blue');
                mask = maskR|maskB;
                t=toc;
                time_t6(length(time_t6)+1) = t;
                tic;
                mask1 = colorSegmentation(im);
                t=toc;
                imshow(mask1,[]);
                time_t4(length(time_t4)+1) = t;

    end
    
%     frpintf('-------------------------------------------------------\n');
%     frpintf('Time per frame team 6 segmentation:');
    mean(time_t6)
    
