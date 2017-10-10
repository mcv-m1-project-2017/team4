
    [numTest, txtTest, rawTest] = xlsread('F:\Image BBDD\BBDD.xlsm');
    path = 'F:\Image BBDD\';
    time_t6 = [];
    time_t4 = [];
    for i=2:10%length(txtTest(:,1))
        if(isempty(char(txtTest(i,20)))==0)
                obj.i=i-1
                obj.filepath=strcat(path,'Images',char(txtTest(i,21)),char(txtTest(i,20)));
                
                im = double(imread(strcat(obj.filepath,'_RD.bmp')));
                
                tic;
                maskR = ColorSegmentation(im,'red');
                maskB = ColorSegmentation(im,'blue');
                mask = maskR|maskB;
                t=toc;
                time_t6(length(time_t6)+1) = t;
                tic;
                mask1 = ColorSegmentationMod(im);
                t=toc;
                time_t4(length(time_t4)+1) = t;
                
                im = double(imread(strcat(obj.filepath,'_GR.bmp')));
                
                tic;
                maskR = ColorSegmentation(im,'red');
                maskB = ColorSegmentation(im,'blue');
                mask = maskR|maskB;
                t=toc;
                time_t6(length(time_t6)+1) = t;
                tic;
                mask = ColorSegmentationMod(im);
                t=toc;
                time_t4(length(time_t4)+1) = t;
                
                
                im = double(imread(strcat(obj.filepath,'_BL.bmp')));
                
                tic;
                maskR = ColorSegmentation(im,'red');
                maskB = ColorSegmentation(im,'blue');
                mask = maskR|maskB;
                t=toc;
                time_t6(length(time_t6)+1) = t;
                tic;
                mask = ColorSegmentationMod(im);
                t=toc;
                time_t4(length(time_t4)+1) = t;
                
                im = double(imread(strcat(obj.filepath,'.bmp')));
                
                
                tic;
                maskR = ColorSegmentation(im,'red');
                maskB = ColorSegmentation(im,'blue');
                mask = maskR|maskB;
                t=toc;
                time_t6(length(time_t6)+1) = t;
                tic;
                mask = ColorSegmentationMod(im);
                t=toc;
                time_t4(length(time_t4)+1) = t;
                
        end
    end
    
%     frpintf('-------------------------------------------------------\n');
%     frpintf('Time per frame team 6 segmentation:');
    mean(time_t6)
    
%     frpintf('-------------------------------------------------------\n');
%     frpintf('Time per frame team 4 segmentation:');
    mean(time_t4)