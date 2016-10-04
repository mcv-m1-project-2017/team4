function [precision, sensitivity, accuracy] = PerformanceEvaluationWindow(TP, FN, FP)
    % PerformanceEvaluationWindow
    % Function to compute different performance indicators (Precision, accuracy, 
    % sensitivity/recall) at the object level
    %
    % [precision, sensitivity, accuracy] = PerformanceEvaluationPixel(TP, FN, FP)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'TP'                Number of True  Positive objects
    %    'FN'                Number of False Negative objects
    %    'FP'                Number of False Positive objects
    %
    % The function returns the precision, accuracy and sensitivity

    precision   = TP / (TP+FP); % Q: What if i do not have TN?
    sensitivity = TP / (TP+FN)
    accuracy    = TP / (TP+FN+FP);
end
