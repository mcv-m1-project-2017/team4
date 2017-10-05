function [ r, g, b ] = task3_extract_averages( directory )
%EXTRACT_AVERAGE_COLOURS Summary of this function goes here
%   Detailed explanation goes here
    
    debug=false
    files = ListFiles(directory);
    
    % value accumulators
    r_acc = g_acc = b_acc = 0;
    

    sprintf('Reading images...')
%    for i=1:60
    n_images = 0;
    for i=1:4,
        sprintf('%d, ', i)
        fflush(stdout);
        % Read file and its annotations
        image_path = strcat(directory,'/',files(i).name);
        annotation_path = strcat(directory, '/gt/gt.', files(i).name(1:size(files(i).name,2)-3), 'txt');
        
        % Crop the image to get the traffic sign
        cropped_image = task3_crop_image(image_path, annotation_path);

        % Get histograms
        [red_hist x] = imhist(cropped_image(:,:,1));
        green_hist = imhist(cropped_image(:,:,2));  
        blue_hist = imhist(cropped_image(:,:,3)); 
        norm = sum(red_hist);
        
        % Normalize histogram by crop size
        r_tmp = red_hist/norm;       
        g_tmp = green_hist/norm;       
        b_tmp = blue_hist/norm;       
        
        r_acc += r_tmp;
        g_acc += g_tmp;
        b_acc += b_tmp;
        
        n_images += 1;
        
        if debug
          disp(image_path)
          disp(annotation_path)
          imshow(cropped_image, [])
          pause(1)
          pause(1)
          plot(x, r_tmp, 'r', x, g_tmp, 'g', x, b_tmp, 'b');
          axis([1 256 0 1]), axis 'auto y'
          pause(1)
        end
        
    end
    
    r = r_acc/n_images;
    g = g_acc/n_images;
    b = b_acc/n_images;

end
