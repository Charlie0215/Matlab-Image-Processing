function omg = halftone(img, scale)

htscale = round(scale * 1.5);

om1 = halftone1(img, htscale, -1);
om2 = halftone1(img, htscale, 1);

rmg = rand(size(om2)) > 0.99;
sigma = sqrt(numel(rmg) / sum(rmg(:))) / 3;
rmg = imgaussfilt(double(rmg), sigma, 'Padding', 'symmetric');
rmg = (rmg - median(rmg(:))) / median(rmg(:)) + 0.5;
rmg = max(min(rmg, 1), 0);
omg = rmg.*om1 + (1-rmg).*om2;

omg = picknoise(omg, 0.15, 2);

omg = imresize(omg, [size(img,1) size(img,2)] * scale);


function omg = halftone1(img, scale, shape)

if nargin < 2
    scale = 6;
end

if nargin < 3
    shape = 0;
end

clear r p g d;
global r p g d;

r = 33;
d = scale;

w = 4 * r + 1;
v = abs(shape) + 0.75;

%%% Generate pinhole pattern

p = ones(r * 8);
p = imrotate(p, 45);
p = imresize(p, [r r], 'bilinear');

x = linspace(-(w-1)/r/2, (w-1)/r/2, w);
[x y] = meshgrid(x, x);

g = exp(-(x.^2 + y.^2) * 2 * v);
g = g / sum(g(:));

tmg = repmat([1 0; 0 1], [5 5]);
tmg = kron(tmg, p);
tmg = imfilter(tmg, g);
tmg = tmg(3*2*r + (1:r*2), 3*2*r + (1:r*2));

[h, edges] = histcounts(tmg, 'Normalization', 'cdf');
h = 1 - [0 h];
f = fit(h', edges', 'poly5');

%%% Render

tmg = im2double(img);
if shape < 0
    tmg = 1 - tmg;
end
tmg = reshape(1 ./ f(tmg), size(tmg));
if shape < 0
    tmg(1:2:end, 1:2:end) = 0;
    tmg(2:2:end, 2:2:end) = 0;
else
    tmg(1:2:end, 2:2:end) = 0;
    tmg(2:2:end, 1:2:end) = 0;
end

omg = blockproc(tmg, round([1000 1000] / r), @draw, ...
                'BorderSize', ceil([w-r-1 w-r-1] / r / 2), ...
                'TrimBorder', false);
if shape < 0
    omg = 1 - omg;
end

omg = im2class(omg, class(img));


function omg = draw(blk)

global r p g d;

b = blk.border .* d;

img = kron(blk.data, p);
img = imfilter(img, g);
img = (img - 1) * 20 + 0.5;
img = max(min(img, 1), 0);
img = imresize(img, size(blk.data) * d);

omg = img(1+b(1):end-b(1), 1+b(2):end-b(2));


function omg = picknoise(img, ratio, iter)

if nargin < 3
    iter = 1;
end

tmg = padarray(img, [1 1], 'replicate');

h = [1 1 1]' * [-size(tmg,1) 0 size(tmg,1)];
v = [-1 0 1]' * [1 1 1];
off = reshape(h + v, 1, []);
ind = reshape(1:numel(tmg), size(tmg));
ind = ind(2:end-1, 2:end-1);

omg = tmg;

for i = 1:iter
    rnd = off(randi(9, size(ind)));
    rnd(rand(size(ind)) > ratio) = 0;
    omg(ind) = omg(rnd + ind);
end


function omg = im2class(img, cls)

converter.double = @im2double;
converter.single = @im2single;
converter.uint8 = @im2uint8;
converter.uint16 = @im2uint16;
converter.int16 = @im2int16;

fun = converter.(cls);

omg = fun(img);
