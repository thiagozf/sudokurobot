function [ sudoku ] = backtrackSudoku ( sudoku )
%BACKTRACKSUDOKU Solves a Sudoku puzzle using a backtrack algorithm.
%   BACKTRACKSUDOKU applies a backtracking algorithm to solve a Sudoku
%   puzzle. The puzzle should be present as a 9 x 9 matrix on the input,
%   with 0 defining empty cells. The function returns the solved Sudoku
%   as the same 9 x 9 matrix, but with the empty cells filled.
%
%   SOLUTION = BACKTRACKSUDOKU(S) solves the Sudoku puzzle S.
    [done, sudoku] = solve(sudoku, 1, 0);
end

function [valid] = isValid(number, sudoku, row, column)
    valid = 1;    

    for i=1:9
        if (sudoku(i, column) == number)
            valid = 0;
        end
        
        if (sudoku(row, i) == number)
           valid = 0; 
        end
    end
 
    sectorRow = fix((row-1)/3)*3 + 1;
    sectorCol = fix((column-1)/3)*3 + 1;
    
    for i=sectorRow:sectorRow+2
        for j=sectorCol:sectorCol+2
            if (sudoku(i,j) == number)
                valid = false;
                return
            end
        end
    end
end

function [ done, sudoku ] = solve (sudoku, row, column)
    done = false;
    
    column = column + 1;
    
    if (column == 10)
        column = 1;
        row = row + 1;    
    end 
        
    if (row == 10)
        done = 1;
        return;
    end
    
    if (sudoku(row,column) == 0)
        for n=1:9
            if (isValid(n, sudoku, row, column) == 1);
                sudoku(row,column) = n;
                [done, sudoku] = solve(sudoku, row, column);
                if (done == 1)
                    return;
                end
                sudoku(row,column) = 0;
            end
        end        
    else
        [done, sudoku] = solve(sudoku, row, column);
    end
end