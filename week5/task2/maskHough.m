% Task 2: Template matching using Distance Transform and chamfer distance
do_plots = false;

% Add repository functions to path
addpath(genpath('..'));

% Set paths
dataset = 'train';
root = '../../../';
inputMasksPath = fullfile(root, 'datasets', 'trafficsigns', 'm1', dataset);
fullImagePath = fullfile(root, 'datasets', 'trafficsigns', 'split', dataset);

% Get all the files
inputMasks = dir(fullfile(inputMasksPath, '*.png'));
frames = dir(fullfile(fullImagePath, '*.jpg'));


%Get models
tri_down = uint8( imread('/tmp/test/2_1.png') );
tri_up = uint8( imread('/tmp/test/18_1.png') );
squ = uint8( imread('/tmp/test/7_1.png') );
circ = uint8( imread('/tmp/test/1_1.png') );
  
s =7;
b = 2;

for i = 1:size(inputMasks,1)
%for i = s:s %1:size(inputMasks,1)
  fprintf('Checking mask %d\n', i)
  inputMaskObject = inputMasks(i);
  inputMaskPath = fullfile(inputMasksPath, inputMaskObject.name);
  iMask = imread(inputMaskPath);

  frameObject = frames(i);
  framePath = fullfile(fullImagePath, frameObject.name);
  frame = imread(framePath);

  %figure, imshow(iMask)
 
  CC = bwconncomp(iMask);
  rp = regionprops(CC, 'BoundingBox');
  
  extraMargin = 10;
  

  for j = 1:size(rp,1)
  %for j = b:b %1:size(rp,1)
    fprintf('\tChecking blob %d\n', j)
    minr = round(max(rp(j).BoundingBox(2) - extraMargin, 1));
    minc = round(max(rp(j).BoundingBox(1) - extraMargin, 1));
    maxr = round(min(rp(j).BoundingBox(2) + rp(j).BoundingBox(4) + extraMargin, size(frame,1)));
    maxc = round(min(rp(j).BoundingBox(1) + rp(j).BoundingBox(3) + extraMargin, size(frame,2)));
    signalMask = frame(minr:maxr, minc:maxc,:);
    imwrite(signalMask, ['/tmp/test5/' num2str(i) '_' num2str(j) '_o.png']);
                
    m = size(signalMask,1);
    n = size(signalMask,2);
    mask = zeros(m,n);
        
    found = false;
    %[sy, sx] = centerSquare(signalMask);
    sy = -1; sx = -1;
    if sy>0 && sx>0
        resizedModel = imresize(squ, [m n]);
        tly = tuy; tlx = tux;
        found = true;
    else
       [tuy, tux] = centerTriangleUp(signalMask);
       if tuy>0 && tux>0
            resizedModel = imresize(tri_up, [m n]);
            tly = tuy; tlx = tux;
            found = true;
       else
           [tdy, tdx] = centerTriangleDown(signalMask);
           if tdy>0 && tdx>0
                resizedModel = imresize(tri_down, [m n]);
                tly = tdy; tlx = tdx;
                found = true;
            end
       end
    end
  
    if found
        tly = max(tly,1);
        tlx = max(tlx,1);
        mask(tly:(tly+m-1), tlx:(tlx+n-1)) = resizedModel;
    end
              
    imwrite(mask, ['/tmp/test5/' num2str(i) '_' num2str(j) '_t.png']);
 
   end

end
