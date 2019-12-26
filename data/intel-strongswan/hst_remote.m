clc 
clear all
raw = readtable('rawdata.csv');
% raw = vec2mat(raw(:, 1), 1000000);
%%
% THR = 200000;
target = table2array(raw(1:40000, 4));

histogram(target, 5000, 'FaceColor', 'black');
hold on
x = 3.32e08;
y = 3.34e08;
rectangle('Position',[x 0 y-x 180], 'LineWidth', 3, 'LineStyle', '-.')
text((x+y) / 2 - (y-x)/2, 190, '8 LZB', 'FontSize', 26.5);

x = 3.35e08;
y = 3.36e08;
rectangle('Position',[x 0 y-x 160], 'LineWidth', 3, 'LineStyle', '-.')
text((x+y) / 2 - (y-x)/2, 170, '4 LZB', 'FontSize', 26.5);

xlim([3.3e8 3.45e8])
ylim([0 200])
xlabel('CPU Cycles')
ylabel('Histogram')
set(gca,'FontSize',35)