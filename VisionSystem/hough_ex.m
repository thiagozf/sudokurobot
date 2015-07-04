x_p = [10 27.1 44.6];
y_p = [30 20 10];

hold off;

set(gca,'YDir','reverse');

ylim([0, 50]);
xlim([0, 60]);

thetas = [0 30 60 90 120 150 180];
C = {'k','b','r',[.5 .6 .7],'y','g',[.8 .2 .6]};

lineLength = 100;

i = 0;
for angle=0:30:180
    i = i + 1;
    x(1) = 44.6;
    y(1) = 10;
    x(2) = x(1) + lineLength * cosd(angle);
    y(2) = y(1) + lineLength * sind(angle);
    x(3) = x(1) - lineLength * cosd(angle);
    y(3) = y(1) - lineLength * sind(angle);
    
    hold on; % Don't blow away the image.
    plot(x, y, 'color',C{i});
end

plot(x_p, y_p, 'black.', 'MarkerSize', 20);


grid off;