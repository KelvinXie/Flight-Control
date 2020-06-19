clear all;
close all;
load('ThreeTurns.mat');
%%
uAngle = 0:0.1:2*pi;
ux = cos(uAngle);
uy = sin(uAngle);
time = rt_colorR.time;
y1 = 0;
y2 = 0;
x1 = 0;
x2 = 0;
angle = 0;
figure;
figure;
for i = 1:length(time)
    R = rt_colorR.signals.values(:,:,i);
    G = rt_colorG.signals.values(:,:,i);
    B = rt_colorB.signals.values(:,:,i);
    picture = cat(3,R,G,B);
    greyImage = rgb2gray(picture);
    I = edge(greyImage, 'sobel', 0.11);
    I(:, [1:10, 150:160]) = 0;
    topHalf = I(1:60, :);
    topHalf(:, [1:40, 120:160]) = 0;
    [y x] = find(topHalf);
    x = x - 80;
    y = -y + 60;
    dist = sqrt(x.^2 + y.^2);
    [mD minIndex] = min(dist);
    [m maxIndex] = max(dist);
    if sum(topHalf, 'all') < 4
        angle = angle;
    else
        y1 = y(minIndex(1));
        y2 = y(maxIndex(end));
        x1 = x(minIndex(1));
        x2 = x(maxIndex(end));
        angle = atan2(y2-y1, x2-x1);
        angle = angle - pi/2;
    end
    angleLog(i)= angle;
    
    
    figure(1); % Camera Viewer
    clf;
    scatter(x, y, '.')
    hold on;
    plot([x1, x2], [y1, y2])
    set(findall(gca, 'Type', 'Line'),'LineWidth',2);
    LabelPlot(['Angle = ' num2str(rad2deg(angle)) ' at time: ' num2str(i/5)], 'x', 'y', [-80 80 -60 60])
    pbaspect([160 120 1])
    
    figure(2); % Angle Viewer
    clf;
    plot(ux, uy);
    hold on;
    plot([cos(angle + pi/2) 0], [sin(angle + pi/2) 0])
    LabelPlot(['Angle = ' num2str(rad2deg(angle)) ' at time: ' num2str(i/5)], 'x', 'y', [-1 1 -1 1])
    pbaspect([1 1 1])
    pause(0.5)
end
%% 
figure; % Angle over Time 
plot(time, angleLog)
set(gca,'YTick', -pi:pi/4:pi) 
set(gca,'YTickLabel',{'-\pi','-3\pi/4', '-\pi/2', '-\pi/4', '0', '\pi/4','\pi/2', '3\pi/4', '\pi'})
LabelPlot(['Angle over Time'], 'x', 'y', [0 time(end) -pi pi])





