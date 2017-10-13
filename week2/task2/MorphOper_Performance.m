%% Script to measure the perfomance of the morphological operators programmed
close all;
clear;
clc;
I = imread('cameraman.tif');
SE = strel('square',5);

fprintf('Performance results obtained by each algorithm, first execution(empty workspace)\n');
fprintf('WARNING: the results vary on each execution and are dependant on various factors\n');
fprintf('SE: 5x5 square, image = 256x256 ''cameraman.tif''\n');
fprintf('Uncomment the code block of the function you want to profile\n');
fprintf('The information above will dissappear in 5 seconds\n to clear memory for the performance tests...\n'); 
pause('on')
pause(5);

% Erode: imerode vs team4_erode

fprintf('Profiling ''imerode''...\n');
tic;
matlab_erode = imerode(I,SE);
m1=toc;
fprintf('%.4fms\n', 1000*m1);

% team4_erode
fprintf('Profiling ''team4_erode''...\n');
tic;
mine_erode = team4_erode(I,SE);
m2 = toc;
fprintf('%.4fms\n', 1000*m2);

% Dilate: imdilate vs team4_dilate

% imdilate
fprintf('Profiling ''imdilate''...\n');
tic;
matlab_dilate= imdilate(I,SE);
m3 = toc;
fprintf('%.4fms\n', 1000*m3);

% team4_dilate
fprintf('Profiling ''team4_dilate''...\n');
tic;
mine_dilate = team4_dilate(I,ones(1,5));
m4 = toc;
fprintf('%.4fms\n', 1000*m4);