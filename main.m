function [] = main(imname, targetWidth, targetHeight)
imrgb = im2single(imread(imname));
imrgb = horCut(imrgb, targetHeight);

im = rgb2gray(im2single(imrgb));
mag = myFilter(im);
%[mag, ~] = imgradient(im);
vmag = mag;
w2cut = size(vmag, 2) - targetWidth;
%hmag = mag;
for a = 2:size(vmag, 1)
    for b = 1:size(vmag, 2)
        [val, ~] = upSmall(vmag, a, b);
        vmag(a, b) = vmag(a, b) + val;
    end
end

for j = 1:w2cut
    newvmag = zeros(size(vmag, 1), size(vmag, 2) - 1);
    newrgb = zeros(size(vmag, 1), size(vmag, 2)  - 1, 3);
    [~, currY] = min(vmag(size(vmag, 1), :));
    
    newvmag(size(vmag, 1), 1:currY - 1) = vmag(size(vmag, 1), 1:currY - 1);
    newvmag(size(vmag, 1), currY:end) = vmag(size(vmag, 1), currY + 1:end);
    
    newrgb(size(vmag, 1), 1:currY - 1, :) = imrgb(size(vmag, 1), 1:currY - 1, :);
    newrgb(size(vmag, 1), currY:end, :) = imrgb(size(vmag, 1), currY + 1:end, :);
    
    for i = size(vmag, 1)-1:-1:2
        [~, currY] = upSmall(vmag, i, currY);
        
        newvmag(i - 1, 1:currY - 1) = vmag(i - 1, 1:currY - 1);
        newvmag(i - 1, currY:end) = vmag(i - 1, currY + 1:end);
        
        newrgb(i - 1, 1:currY - 1, :) = imrgb(i - 1, 1:currY - 1, :);
        newrgb(i - 1, currY:end, :) = imrgb(i - 1, currY + 1:end, :);
    end
    imrgb = newrgb;
    vmag = newvmag;
end
imwrite(imrgb, 'yosemitecut.jpg');
end

function [rVal, ry] = upSmall(mat, x, y)
candidates = ones(1, 3) * 9999;
yCoords = ones(1, 3);
yCoords(1) = y - 1;
yCoords(2) = y;
yCoords(3) = y + 1;
if y == 1
    candidates(2) = mat(x - 1, yCoords(2));
    candidates(3) = mat(x - 1, yCoords(3));
elseif y == size(mat, 2)
    candidates(1) = mat(x - 1, yCoords(1));
    candidates(2) = mat(x - 1, yCoords(2));
else
    candidates(1) = mat(x - 1, yCoords(1));
    candidates(2) = mat(x - 1, yCoords(2));
    candidates(3) = mat(x - 1, yCoords(3));
end
[rVal, i] = min(candidates);
ry = yCoords(i);
end

function [mag] = myFilter(img)
% xMask = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
% yMask = [-1, -2, -1; 0, 0, 0; -1, -2, -1];
% gx = conv2(img, xMask, 'same');
% gy = conv2(img, yMask, 'same');
% mag = (gx .^ 2 + gy .^2) .^ 0.5;
% kernel = [1, 0; 0, -1];
% mag = abs(conv2(img, kernel, 'same'));

xMask = [1, -1];
yMask = [1; -1];
gx = conv2(img, xMask, 'same');
gy = conv2(img, yMask, 'same');
mag = (gx .^ 2 + gy .^2) .^ 0.5;
end

function [imrgb] = horCut(input, targetWidth)
input = rot90(input);
imrgb = input;
im = rgb2gray(im2single(imrgb));
mag = myFilter(im);
%[mag, ~] = imgradient(im);
vmag = mag;
w2cut = size(vmag, 2) - targetWidth;
%hmag = mag;
for a = 2:size(vmag, 1)
    for b = 1:size(vmag, 2)
        [val, ~] = upSmall(vmag, a, b);
        vmag(a, b) = vmag(a, b) + val;
    end
end

for j = 1:w2cut
    newvmag = zeros(size(vmag, 1), size(vmag, 2) - 1);
    newrgb = zeros(size(vmag, 1), size(vmag, 2)  - 1, 3);
    [~, currY] = min(vmag(size(vmag, 1), :));
    
    newvmag(size(vmag, 1), 1:currY - 1) = vmag(size(vmag, 1), 1:currY - 1);
    newvmag(size(vmag, 1), currY:end) = vmag(size(vmag, 1), currY + 1:end);
    
    newrgb(size(vmag, 1), 1:currY - 1, :) = imrgb(size(vmag, 1), 1:currY - 1, :);
    newrgb(size(vmag, 1), currY:end, :) = imrgb(size(vmag, 1), currY + 1:end, :);
    
    for i = size(vmag, 1)-1:-1:2
        [~, currY] = upSmall(vmag, i, currY);
        
        newvmag(i - 1, 1:currY - 1) = vmag(i - 1, 1:currY - 1);
        newvmag(i - 1, currY:end) = vmag(i - 1, currY + 1:end);
        
        newrgb(i - 1, 1:currY - 1, :) = imrgb(i - 1, 1:currY - 1, :);
        newrgb(i - 1, currY:end, :) = imrgb(i - 1, currY + 1:end, :);
    end
    imrgb = newrgb;
    vmag = newvmag;
end
imrgb = rot90(imrgb, 3);
end