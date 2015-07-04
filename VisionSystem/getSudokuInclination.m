function [ imAngle ] = getSudokuInclination( im )
%GETSUDOKUINCLINATION Computes the inclination angle of the Sudoku puzzle at
%an input image.
%   GETSUDOKUINCLINATION obtains the inclination of the puzzle
%   by applying the Hough Transform in the input image and analyzing the
%   theta angle of the horizontal grid lines (which should be zero when
%   the puzzle is not rotated). The mean of all horizontal lines
%   angles is taken as the inclination of the puzzle.
%
%   A = GETSUDOKUINCLINATION(I) computes the inclination of a Sudoku puzzle
%   in the input image I.

    imCenter = adaptiveThreshold(imcrop(im, [245 165 150 150]));
    imshow(imCenter);
    
    [H, T, R] = hough(imCenter);
    figure, imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,'InitialMagnification','fit');
    xlabel('\theta'), ylabel('\rho');
    axis on, axis normal;
    title('Transformada de Hough');

    P  = houghpeaks(H,20,'threshold',ceil(0.7*max(H(:))));
    x = T(P(:,2)); y = R(P(:,1));
    %figure, plot(x,y,'s','color','white');
    % Find lines and plot them
    lines = houghlines(imCenter,T,R,P,'FillGap',20,'MinLength',7);
    figure, imshow(imCenter), hold on
    %max_len = 0;

    angleSum = 0;
    lineCount = 0;

    for k = 1:length(lines)
      if (lines(k).theta > -45 && lines(k).theta < 45) % horizontal
          angleSum = angleSum + lines(k).theta;
          lineCount = lineCount + 1;
      end

       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

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

    hold off;

    imAngle = angleSum / lineCount;
end

