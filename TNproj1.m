clc; clear; close all;
%% Load image
img = imread('/Users/dai/Desktop/year4/4TN4/pollen.png');
img_octm = img(:, :);
[counts, binLocations] = imhist(img);

%% OCTM

s = sum(counts);
f = zeros(1, length(binLocations));
for i = 1:length(binLocations)
    f(i) = counts(i)/s * (-1);
end

% create Sj
A = ones(1, length(binLocations));
b = 255;
d = 2;
max_step_size =3;
min_step_size = 1/d;
Aeq = [];
beq = [];
lb = ones(1, length(binLocations)) * min_step_size;
ub = ones(1, length(binLocations)) * max_step_size;
x = linprog(f, A, b, Aeq, beq, lb, ub);

% Create Transfer function
Tr = zeros(1, length(binLocations));
for m = 1 : length(Tr)
    for n = 1 : m
        Tr(m) = Tr(m) + x(n);
    end
    Tr(m) = floor(Tr(m) + 0.5) ;
end

% mapping
[width, height] = size(img);
for x = 1 : width
    for y = 1 : height
        img_octm(x, y) = Tr(img(x, y));
    end
end
figure(2);
subplot(2,3,1);imshow(img);title('original image');
subplot(2,3,2);imhist(img);
subplot(2,3,4);imshow(img_octm);title('After OCTM');
subplot(2,3,5);imhist(img_octm);
subplot(2,3,6);plot(Tr);title('Transfer Function');grid on;

%% Histogram Equaliztion
%figure;
%img_eq = histeq(img);

%subplot(2,2,1);imshow(img);title('original image');
%subplot(2,2,2);imhist(img)
%subplot(2,2,3);imshow(img_eq);title('After Equation');
%subplot(2,2,4);imhist(img_eq);

%% Laplacian filter
%A = imread('/Users/dai/Desktop/year4/4TN4/pollen.png');
%Lap4 = [0 1 0; 1 -4 1; 0 1 0];
%imgLap4 = imfilter(A, Lap4);
%imshow(imgLap4)%, 'image', 150)   
%disp(A)