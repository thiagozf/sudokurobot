function [ imGrid ] = detectSudokuGrid( im )
%DETECTSUDOKUGRID Detects the Sudoku grid area in an binary image.
%   DETECTSUDOKUGRID detects the grid by using a series of morphological
%   operations. First, it fills the image regions and holes. All the
%   connected components (regions) are then identified and the area of each
%   region is computed. The function assumes that the greatest area
%   identified represents the Sudoku grid.
%
%   G = DETECTSUDOKUGRID(I) Returns a mask that identifies the Sudoku puzzle in the
%   image I.
    imFilled = imfill(im, 'holes');
    figure, imshow(imFilled);
    
    imOpen = bwareaopen(imFilled, 20000);
    
    % Determine the connected components
    CC = bwconncomp(imOpen);
    % Compute the area of each component
    S = regionprops(CC, 'Area');
    % Remove small objects
    L = labelmatrix(CC);
    imGrid = ismember(L, find([S.Area] >= max(S.Area)));
    figure, imshow(imGrid);
end

