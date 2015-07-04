function displaySudokuSolution( sudoku, solved )
%DISPLAYSUDOKUSOLUTION Displays the Sudoku puzzle and its solution to the user.
%   DISPLAYSUDOKUSOLUTION takes two Sudoku puzzles as input, intended to be a
%   puzzle and its solution, and displays them to the user in a new MATLAB window.

D1 = cell(9);
for m = 1:9
    for n = 1:9
        if sudoku(m,n)
            D1{m,n} = sudoku(m,n);
        end
    end
end

D2 = num2cell(solved);

figure;
set(gcf,'units','pixels','Position',[200 200 800 400]);


h1 = uitable('Data',D1,'FontSize',16,'ColumnWidth',num2cell(repmat(30,1,9)),'columne',false(1,9));
set(h1,'units','norm','position',[.05 .05 .4 .9]);
h2 = uitable('Data',D2,'FontSize',16,'ColumnWidth',num2cell(repmat(30,1,9)));
set(h2,'units','norm','position',[.55 .05 .4 .9]);
