clc;
clear 

dirs = '/Users/dai/Desktop/year4/4TN4/proj2/VOC2012/JPEGImages';
save_dir_ht = '/Users/dai/Desktop/year4/4TN4/proj2/half_tone';
save_dir_gt = '/Users/dai/Desktop/year4/4TN4/proj2/ground_truth';

filePattern = fullfile(dirs, '*.jpg');
Files = dir(filePattern);

for k = 1:length(Files)
    basefilename = Files(k).name;
    fullfilename = fullfile(dirs, basefilename);
    fprintf(1, 'Now reading %s\n', fullfilename);
    img = imread(fullfilename);
    img = rgb2gray(img);
    img = im2double(img);
    img = imresize(img, [110, 110]);
    p = zeros(13);
    p(7,7) = 1;
    omg = kron(img, p);
    omg = imgaussfilt(omg, 4);
    omg2 = omg > 0.002555;
    %omg2 = imresize(omg2, [256, 256]);

    img = imresize(img, [1430, 1430]);
    
    fullsavingpath_ht = fullfile(save_dir_ht, basefilename);
    fullsavingpath_gt = fullfile(save_dir_gt, basefilename);
    imwrite(omg2, fullsavingpath_ht);
    imwrite(img, fullsavingpath_gt)
    
end


    img = imread('/Users/dai/Desktop/year4/4TN4/proj2/VOC2012/JPEGImages/035A4305_19.jpg');
    img = rgb2gray(img);
    img = im2double(img);
    img = imresize(img, [110, 110]);
    p = zeros(13);
    p(7,7) = 1;
    omg = kron(img, p);
    omg = imgaussfilt(omg, 4);
    omg2 = omg > 0.002555;
    %omg2 = imresize(omg2, [256, 256]);
    size = size(omg2);
    size(1)
    imshow(omg2)
    
    
    