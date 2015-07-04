function integral = integralImage(im)
%INTEGRALIMAGE Computes the integral of an image, also know as Summed Area Table.
%   INTEGRALIMAGE produces a data structure for quickly and efficiently generate
%   the sum of values in a rectangular subset of a grid. It was introduced
%   in image processing by the Viola–Jones object detection framework, and
%   is commonly used to sum the rectangular neighborhood of pixel.
%   More details at http://en.wikipedia.org/wiki/Summed_area_table.
%
%   II = INTEGRALIMAGE(I) returns the integral image of I.
    im = double(im);
    
    % Sum all rows and all columns
    integral = cumsum(cumsum(im,2));
    % Pads the result
    integral = padarray(integral, [1 1], 0, 'pre');
end