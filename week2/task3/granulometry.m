function pecstrum = granulometry(A, type_SE, steps)
%{
Jonatan Poveda
Martí Cobos
Juan Francesc Serracant
Ferran Pérez
Master in Computer Vision
Computer Vision Center, Barcelona
---------------------------
Project M1/Block2
---------------------------
This function is used to compute an image granulometry.
input:  - A: the input mask to compute granulometry
        - type_SE: Structuring element type
        - steps: number of steps to compute granulometry        
output: - pecstrum: image granulometry
---------------------------
%}

for counter = 1:steps
    remain = imopen(A, strel(type_SE,counter-1));
    pecstrumA(counter) = sum (abs(remain(:)));
    remain = imclose(A, strel(type_SE,counter-1));
    pecstrumB(counter) = sum (abs(remain(:)));
end
pecstrum = cat(2,fliplr(pecstrumB),pecstrumA);
end

