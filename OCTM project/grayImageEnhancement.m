clc; clear; close all;
%% Load image
% Please change your image directory
img = imread('pollen.png');
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
d = 3;
max_step_size =7;
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
figure(1)
subplot(2,1,1);imshow(img);title('original image');
subplot(2,1,2);imhist(img);
figure(2)
imshow(img_octm);title('After OCTM');
figure(3)
subplot(2,1,1);imhist(img_octm);
subplot(2,1,2);plot(Tr);title('Transfer Function');grid on;
