clc 
clear all
raw = readtable('result.csv');
% raw = vec2mat(raw(:, 1), 1000000);
%%
% THR = 200000;
target = table2array(raw(1:40000, 6));

histogram(target, 5000, 'FaceColor', 'black');
hold on
x = 8.63e07;
line([x, x], [0, 220], 'LineWidth', 3, 'LineStyle','-.', 'Color', 'black')
text(x-380000, 100, '4 LZB', 'FontSize', 26.5);
hold on
x = 8.59e07;
line([x, x], [0, 220], 'LineWidth', 3, 'LineStyle','-.', 'Color', 'black')
text(x-390000, 80, '6 LZB', 'FontSize', 26.5);
hold on
x = 8.55e07;
line([x, x], [0, 220], 'LineWidth', 3, 'LineStyle','-.', 'Color', 'black')
text(x-390000, 60, '8 LZB', 'FontSize', 26.5);
hold on
x = 8.51e07;
line([x, x], [0, 220], 'LineWidth', 3, 'LineStyle','-.', 'Color', 'black')
text(x-450000, 40, '10 LZB', 'FontSize', 26.5);

xlim([8.4e7 8.9e7])
ylim([0 220])
xlabel('CPU Cycles')
ylabel('Histogram')
set(gca,'FontSize',35)