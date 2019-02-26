clc; clear; close all;

%% Load image
img = imread('color1.png');


%% 3 channels
redChannel = img(:,:,1); % Red channel
greenChannel = img(:,:,2); % Green channel
blueChannel = img(:,:,3); % Blue channel

%% Change parameters here
b = 255;
d = 2;
max_step_size =10; %% U
min_step_size = 1/d; 
Aeq = [];
beq = [];

%% Red Channel OCTM
img_octm_red = redChannel(:, :);
[counts_red, binLocations_red] = imhist(redChannel);

sr = sum(counts_red);
f = zeros(1, length(binLocations_red));
for i = 1:length(binLocations_red)
    f(i) = counts_red(i)/sr * (-1);
end

% create Sj
A = ones(1, length(binLocations_red));
lb = ones(1, length(binLocations_red)) * min_step_size;
ub = ones(1, length(binLocations_red)) * max_step_size;
xr = linprog(f, A, b, Aeq, beq, lb, ub);

% Create Transfer function
Trr = zeros(1, length(binLocations_red));
for m = 1 : length(Trr)
    for n = 1 : m
        Trr(m) = Trr(m) + xr(n);
    end
    Trr(m) = floor(Trr(m) + 0.5) ;
end

% mapping
[width, height] = size(redChannel);
for x = 1 : width
    for y = 1 : height
        img_octm_red(x, y) = Trr(redChannel(x, y)+1);
    end
end

%% Green Chnannel OCTM

img_octm_green = greenChannel(:, :);
[counts_green, binLocations_green] = imhist(greenChannel);

sg = sum(counts_green);
f = zeros(1, length(binLocations_green));
for i = 1:length(binLocations_green)
    f(i) = counts_green(i)/sg * (-1);
end

% create Sj
A = ones(1, length(binLocations_green));
lb = ones(1, length(binLocations_green)) * min_step_size;
ub = ones(1, length(binLocations_green)) * max_step_size;
xg = linprog(f, A, b, Aeq, beq, lb, ub);

% Create Transfer function
Trg = zeros(1, length(binLocations_green));
for m = 1 : length(Trg)
    for n = 1 : m
        Trg(m) = Trg(m) + xg(n);
    end
    Trg(m) = floor(Trg(m) + 0.5) ;
end

% mapping
[width, height] = size(greenChannel);
for x = 1 : width
    for y = 1 : height
        img_octm_green(x, y) = Trg(greenChannel(x, y)+1);
    end
end

%% Blue Channel OCTM
img_octm_blue = blueChannel(:, :);
[counts_blue, binLocations_blue] = imhist(blueChannel);



sb = sum(counts_blue);
f = zeros(1, length(binLocations_blue));
for i = 1:length(binLocations_red)
    f(i) = counts_blue(i)/sb * (-1);
end

% create Sj
A = ones(1, length(binLocations_blue));

lb = ones(1, length(binLocations_blue)) * min_step_size;
ub = ones(1, length(binLocations_blue)) * max_step_size;
xb = linprog(f, A, b, Aeq, beq, lb, ub);

% Create Transfer function
Trb = zeros(1, length(binLocations_blue));
for m = 1 : length(Trb)
    for n = 1 : m
        Trb(m) = Trb(m) + xb(n);
    end
    Trb(m) = floor(Trb(m) + 0.5) ;
end

% mapping
[width, height] = size(blueChannel);
for x = 1 : width
    for y = 1 : height
        img_octm_blue(x, y) = Trb(blueChannel(x, y)+1);
    end
end

%% Concatenate
full_img = cat(3, img_octm_red, img_octm_green, img_octm_blue);

%% Show image
figure(1);

subplot(3,2,1);imhist(redChannel);title('Red:Original histogram');
subplot(3,2,2);imshow(redChannel);title('Red:Original image');

subplot(3,2,3);imhist(greenChannel);title('Green:Original histogram');
subplot(3,2,4);imshow(greenChannel);title('Green:Original image');

subplot(3,2,5);imhist(blueChannel);title('Blue:Original histogram');
subplot(3,2,6);imshow(blueChannel);title('Blue:Original image');

figure(2);
subplot(3,3,1);plot(Trr);title('Transfer function: Red');
subplot(3,3,2);imhist(img_octm_red);title('Red:histogram after OCTM');
subplot(3,3,3);imshow(img_octm_red);title('Red:image after OCTM');
subplot(3,3,4);plot(Trg);title('Transfer function: Green');
subplot(3,3,5);imhist(img_octm_green);title('Green:histogram after OCTM');
subplot(3,3,6);imshow(img_octm_green);title('Green:image after OCTM');
subplot(3,3,7);plot(Trb);title('Transfer function: Blue');
subplot(3,3,8);imhist(img_octm_blue);title('Blue:histogram after OCTM');
subplot(3,3,9);imshow(img_octm_blue);title('Blue:image after OCTM');

figure(3);
imshow(img);title('Original color image')
figure(4);
imshow(full_img);title('Color image after OCTM')
