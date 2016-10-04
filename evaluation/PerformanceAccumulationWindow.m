function [TP,FN,FP] = PerformanceAccumulationWindow(detections, annotations)
    % PerformanceAccumulationWindow
    % Function to compute different performance indicators (True Positive, 
    % False Positive, False Negative) at the object level.
    %
    % Objects are defined by means of rectangular windows circumscribing them.
    % Window format is [ struct(x,y,w,h) ; struct(x,y,w,h) ; ... ] in both
    % detections and annotations.
    %
    % An object is considered to be detected correctly if detection and annotation 
    % windows overlap by more of 50%
    %
    %   function [TP,FN,FP] = PerformanceAccumulationWindow(detections, annotations)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'detections'        List of windows marking the candidate detections
    %    'annotations'       List of windows with the ground truth positions of the objects
    %
    % The function returns the number of True Positive (TP), False Positive (FP), 
    % False Negative (FN) objects

    detectionsUsed = zeros(1,size(detections,1));
    annotationsUsed = zeros(1,size(annotations,1));
    TP = 0;
    for i=1:size(annotations,1),
        for j=1:size(detections,1),
            if detectionsUsed(j)==0 && RoiOverlapping(annotations(i), detections(j)) > 0.5
                TP = TP+1;
                detectionsUsed(j) = 1;
                annotationsUsed(i) = 1;
            end
        end
    end
    FN = length(find(annotationsUsed==0));
    FP = length(find(detectionsUsed==0));
end
