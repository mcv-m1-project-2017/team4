function signalClass = decisionTree(ROIMask, ROIhsv)
%{
Jonatan Poveda
Martí Cobos
Juan Francesc Serracant
Ferran Pérez
Master in Computer Vision
Computer Vision Center, Barcelona
---------------------------
Project M1/Week3
---------------------------
This function is used to classify an input ROI.
input:  - ROIMask: input mask to analyze if there is a signal
        - ROIhsv: input ROI in HSV color space       
output: - signalClass: Signal classified in one of the 6 signal groups
(A,B,C,D,E,F) or no detection (X)
---------------------------
%}

%Dummy code to develope multiscalewindowing
size =sum(ROIMask(:));
if ((size> 1000)&&(size< 50000))
    signalClass = 'A';
else
    signalClass = 'X';
end

end

