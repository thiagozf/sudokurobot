function imSolution = projectSudokuSolution(im,cells,sudoku,solved)
%PROJECTSUDOKUSOLUTION Plots the solution of a Sudoku puzzle to an ouput image.
%   PROJECTSUDOKUSOLUTION plots the solution of a Sudoku puzzle, prints it
%   to a temporary file, copies that image to an image variable I, and then
%   deletes the temporary file.
%
%   IS = PROJECTSUDOKUSOLUTION (I, CELLS, SUDOKU, SOLVEDSUDOKU) 

[h,w] = size(im);

figure(15);
set(15,'visible','off');
set(15,'Units','pixels','Position',[1 1 w h]);
set(15,'paperpositionmode','auto');
a = axes;
set(a,'units','nor','pos',[0 0 1 1]);

axis([0 w 0 h]);
axis ij
axis off

for i = 1:9
    for j = 1:9
        if ~sudoku(i,j)
            text(cells(j,i,1)+floor(cells(j,i,3)/2),cells(j,i,2),num2str(solved(i,j)),'fontweight','bold'...
                ,'horiz','center','vert','top','FontUnits','pixels','fontsize',cells(j,i,4));
        end
    end
end
print('-dpng','testimage.png',['-r' num2str(get(0,'screenPixelsPerInch'))]);
imSolution = im2bw(imread('testimage.png'));
imshow(imSolution);
%delete testimage.png
close(15);