clear all;

% Read an image
im0 = im2double(imread('lenna.png'));

% Convert the image to grayscale if it is not
if size(im0, 3) > 1
    im0 = rgb2gray(im0);
end

% Resize the image and stretch its dynamic range
img = imresize(im0, 1/4);
img = imadjust(img, stretchlim(img, 0.1), []);

% Scale of the output halftone image
scale = 5;

% Generate a halftone image
omg = halftone(img, scale);

% Reduce dynamic range and add noise to simulate scan and
% compression effects
omg = imadjust(omg, [0 1], [0.2 0.8]);
omg = imnoise(omg, 'gaussian', 0, 0.01);
omg = imgaussfilt(omg, 0.5);

% Output the halftone image
imwrite(omg, 'D:/Desktop/halftone/lenna_halftone1.png');

% Show input and output images side by side
imshowpair(imresize(im0, size(omg)), omg, 'montage');
% imwrite([imresize(img, scale) omg], 'lenna_compare.png');
