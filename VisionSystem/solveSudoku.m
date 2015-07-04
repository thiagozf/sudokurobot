function solveSudoku(im)
%SOLVESUDOKU Detects and solves a Sudoku puzzle at an image.

    close all;
    
    %% Open the image from file
    imInput = imread(im);
    imshow(imInput);

    %% Convert RGB image to grayscale
    imGray = rgb2gray(imInput);
    figure, imshow(imGray);

    %% Corrects the Sudoku grid inclination
    figure, imshow(adaptiveThreshold(imGray));

    imAngle = getSudokuInclination(imGray);
    imNoInclination = imrotate(imGray, imAngle, 'bicubic');
    figure, imshow(imNoInclination);

    %% Convert the result to a binary image
    imBinary = adaptiveThreshold(imNoInclination);
    figure, imshow(imBinary);

    %% Detects the Sudoku grid on the image and remove other elements (noise)
    imGrid = detectSudokuGrid(imBinary);
    imProcessing = imBinary & imGrid;
    figure, imshow(imProcessing);

    %% Locates the cells of the Sudoku grid on the image
    [lines,points] = getSudokuCells(imProcessing);


    points = sortrows(points);
    pointsByColumn = zeros(10:10:2);
    for k=0:9
    pointsByColumn(k+1,:,:) = sortrows(points(k*10+1:k*10+10,:), 2);
    end
    
    %% Recognizes the puzzle
    load('TEMPLATES.mat')
    sudoku = zeros(9,9);

    cells = zeros(9, 9, 4);

    for x=1:9
    for y=1:9
        pTopLeft    = pointsByColumn(x,y,:);
        pTopRight   = pointsByColumn(x+1,y,:);
        pBottomLeft = pointsByColumn(x,y+1,:);

        widthCell = pTopRight(1)-pTopLeft(1);
        heightCell = pBottomLeft(2)-pTopLeft(2);

        marginHeight = ceil(0.10 * heightCell);
        marginWidth = ceil(0.10 * widthCell);

        sizeCell = [pTopLeft(1)+marginWidth, pTopLeft(2)+marginHeight, widthCell-2*marginWidth, heightCell-2*marginHeight];
        cells(x,y,:) = sizeCell;

        imCell = imclearborder( imcrop(imProcessing, sizeCell) );
        %figure, imshow(imCell), hold on;

        L = bwlabel(imCell);
        s = regionprops(L, 'Area', 'BoundingBox');

        if (not(isempty(s)))
            nFeature = 0;
            maxFeatureArea = 0;
            for k=1:size(s,1)
                if (s(k).Area > maxFeatureArea)
                    maxFeatureArea = s(k).Area;
                    nFeature = k;
                end
            end

            % More than 30% of the cell area: assumed to be a clue
            if (maxFeatureArea >= 0.05 * widthCell * heightCell)
                %rectangle('Position', s(nFeature).BoundingBox, 'EdgeColor','c', 'LineWidth', 1);
                sudoku(y,x) = ocr( imcrop(imCell, s(nFeature).BoundingBox), TEMPLATES );
            end
        end

        %hold off;
    end
    end
    
    hold off;
    
    %% Solves the puzle
    %sudoku
    solved = backtrackSudoku(sudoku);
    
    %solved = [5,8,2,1,6,3,4,7,9;3,6,1,4,9,7,5,8,2;7,9,4,5,8,2,3,6,1;4,2,9,8,1,6,7,5,3;1,5,3,7,2,4,6,9,8;6,7,8,3,5,9,1,2,4;8,3,7,2,4,5,9,1,6;2,4,6,9,7,1,8,3,5;9,1,5,6,3,8,2,4,7;];
    displaySudokuSolution(sudoku, solved);

    %% Projects the solution to an output image
    imSolution = projectSudokuSolution(imProcessing,cells,sudoku,solved);
    imFinal = imoverlay(imProcessing,~imSolution,[1 1 1]);
    figure, imshow(imFinal);

    imMask = imrotate(imSolution, imAngle*-1, 'bicubic');

    [hm,wm] = size(imMask);
    [h,w,z] = size(imInput);

    wd = wm - w;
    hd = hm - h;
    wmargin = fix(wd/2);
    hmargin = fix(hd/2);
    
    %imMask2 = imcrop(imMask, [wmargin, hmargin, w, h]);
    
    imMask2 = imMask(hmargin+1:hmargin+h, wmargin+1:wmargin+w);
    imResult = imoverlay(imInput,~imMask2,[0.19 0.20 0.20]);
    figure, imshow(imResult);