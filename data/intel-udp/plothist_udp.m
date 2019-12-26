clc 
clear all
raw = readtable('result.csv');
% raw = vec2mat(raw(:, 1), 1000000);
%%
% THR = 200000;
target = table2array(raw(1:40000, 3));

histogram(target, 5000, 'FaceColor', 'black');

hold on

x = 4.93e08;
line([x, x], [0, 600], 'LineWidth', 3, 'LineStyle','-.', 'Color', 'black')
text(x-0.2e7, 300, '8 LZB', 'FontSize', 26.5);
hold on
x = 4.97e08;
line([x, x], [0, 600], 'LineWidth', 3, 'LineStyle','-.', 'Color', 'black')
text(x-0.2e7, 300, '4 LZB', 'FontSize', 26.5);
hold on


xlim([4.85e08 5.07e08])
ylim([0 600])
xlabel('CPU Cycles')
ylabel('Histogram')
set(gca,'FontSize',35)