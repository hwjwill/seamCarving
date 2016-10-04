function [] = main(imname, targetWidth)
imrgb = imread(imname);
im = rgb2gray(im2single(imrgb));
mag = mySobel(im);
%[mag, ~] = imgradient(im);
vmag = mag;
w2cut = size(vmag, 2) - targetWidth;
%hmag = mag;
for a = 2:size(vmag, 1)
    for b = 1:size(vmag, 2)
        vmag(a, b) = vmag(a, b) + upSmall(vmag, a, b);
    end
end
for j = 1:w2cut
    [~, currY] = min(vmag(size(vmag, 1), :));
    vmag(size(vmag, 1), currY) = 9999;
    imrgb(size(vmag, 1), currY, 1) = 255;
    imrgb(size(vmag, 1), currY, 2) = 255;
    imrgb(size(vmag, 1), currY, 3) = 255;
    for i = size(vmag, 1):-1:2
        [~, currY] = upSmall(vmag, i, currY);
        vmag(i - 1, currY) = 9999;
        imrgb(i - 1, currY, 1) = 255;
        imrgb(i - 1, currY, 2) = 255;
        imrgb(i - 1, currY, 3) = 255;
    end
end
imshow(imrgb);
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

function [mag] = mySobel(img)
xMask = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
yMask = [-1, -2, -1; 0, 0, 0; -1, -2, -1];
gx = conv2(img, xMask, 'same');
gy = conv2(img, yMask, 'same');
mag = (gx .^ 2 + gy .^2) .^ 0.5;
end

% function [result] = cutVertical()
% 
% end