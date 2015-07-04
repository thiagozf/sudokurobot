function [ imBinary ] = adaptiveThreshold( im )
%ADAPTIVETHRESHOLD Convert grayscale image to binary image by an adaptive threshold.
%   ADAPTIVETHRESHOLD produces binary image from grayscale images. To do
%   this, it converts the input image to binary by applying an adaptive
%   threshold known as Sauvola's method.
%
%   BW = adaptiveThreshold(I) converts the grayscale image I to black and
%   white.

    %% Constants
    W = 11;
    AREA = W^2;
    RECT = (W-1)/2;
    C = 4;
    
    %% Gets width and height of the image
    [h,w] = size(im);
    
    %% Computes the integral image
    II = integralImage(im);
    
    %% Apply the thresholding
    
    % Creates the binary image
    imBinary = zeros(h,w);
    
    for y = RECT+2:h-RECT
        for x = RECT+2:w-RECT
            % Sums up the neighborhood
            windowSum = II(y-RECT-1,x-RECT-1) + II(y+RECT,x+RECT) - II(y-RECT-1,x+RECT) - II(y+RECT,x-RECT-1);
            % Computes the mean
            windowMean = windowSum / (AREA);
            % Define if pixel is foreground or background
            imBinary(y-1,x-1) = im(y,x) < (windowMean-C);
        end
    end
end

