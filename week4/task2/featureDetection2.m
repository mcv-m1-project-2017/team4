function [resultImage, minValue] = featureDetection2(imdist, model, th, extraMargin)
    figure, imshow(imdist);
    m = size(imdist,1) - ((extraMargin - 3) * 2);
    n = size(imdist,2) - ((extraMargin - 3) * 2);
    
    resizedModel = imresize(model, [m n]);
    modelCanny = edge(resizedModel, 'canny');
    figure, imshow(modelCanny)
        
    correlated = xcorr2(imdist, modelCanny);
    
    marginM = m;
    marginN = n;
    c = correlated(marginM:size(correlated,1)-marginM, marginN:size(correlated,2)-marginN);
    c = normalize(c);
    figure, imshow(c);  
    %minC = min(c(:))
    
    binImage = binarize(c, th);
    %figure, imshow(binImage);
    
    resultImage = zeros(size(imdist,1), size(imdist,2));
    minValue = min(binImage(:))
    if minValue < 1.0
      [r c] = find( binImage == minValue );
      if binImage(r,c) < 1.0
        ty = r; %  + extraMargin;
        tx = c; % + extraMargin;
        resultImage(ty:ty+m-1, tx:tx+n-1) = resizedModel;
      end
    else
      minValue = 1.0;
    end
    figure, imshow(resultImage);
end