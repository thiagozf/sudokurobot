function [ lines, points ] = getSudokuCells( im )
%GETSUDOKUCELLS Locates the cells of the Sudoku puzzle at an input image.
%   GETSUDOKUCELLS locates the cells of the Sudoku puzzle by calculating
%   intersection points of the grid lines, obtained with Hough Transform.
%   The points are computed by solving linear systems composed of vertical
%   and horizontal lines pairs.
%
%   [LINES, POINTS] = GETSUDOKUCELLS(I) locates grid lines and cells points
%   of a Sudoku puzzle in the input image I.

    [h,w] = size(im);

    [H, T, R] = hough(im);
    P  = houghpeaks(H,25,'threshold',ceil(0.6*max(H(:))));
    x = T(P(:,2)); y = R(P(:,1));
    %figure, plot(x,y,'s','color','white');
    % Find lines and plot them
    lines = houghlines(im,T,R,P,'FillGap',100,'MinLength',7);
    figure, imshow(im), hold on;
    
    hcount = 0;
    vcount = 0;
    pcount = 1;
    
    horizontals = zeros(10, 2, 2);
    verticals = zeros(10, 2, 2);
    points = zeros(100, 2);
    
    for k = 1:length(lines)
        % rho = x*cos(theta) + y*sin(theta)
       if (lines(k).theta > -45 && lines(k).theta < 45) % horizontal
           vcount = vcount + 1;
           
           y = [0 h];
           x = [(lines(k).rho/cosd(lines(k).theta)) ((lines(k).rho - h*sind(lines(k).theta))/cosd(lines(k).theta))];
           
           verticals(vcount, 1, :) = x;
           verticals(vcount, 2, :) = y;
       else
           hcount = hcount + 1;
           
           x = [0 w];
           y = [(lines(k).rho/sind(lines(k).theta)) ((lines(k).rho - w*cosd(lines(k).theta))/sind(lines(k).theta))];
           
           horizontals(hcount, 1, :) = x;
           horizontals(hcount, 2, :) = y;
       end
       
       plot(x, y,'LineWidth',2,'Color','green');

       %{
       % Plot beginnings and ends of lines
       plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

       % Determine the endpoints of the longest line segment
       len = norm(lines(k).point1 - lines(k).point2);
       if ( len > max_len)
          max_len = len;
          xy_long = xy;
       end
       %}
    end
    
    for x = 1:hcount
        for y=1:vcount
            %{
            hxy = [lines(horizontals(x)).point1; lines(horizontals(x)).point2];
            vxy = [lines(verticals(y)).point1; lines(verticals(y)).point2];
            %}
            
            [xi,yi] = polyxpoly(horizontals(x,1,:),horizontals(x,2,:), verticals(y,1,:),verticals(y,2,:));
            
            points(pcount,:) = [xi,yi];
            pcount = pcount + 1;
            
            plot(xi,yi,'x','LineWidth',5,'Color','red');
        end
    end
    
    hold off;
    
    points = ceil(points);
end

