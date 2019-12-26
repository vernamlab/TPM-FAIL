clc 
clear all
raw = readtable('result.csv');
% raw = vec2mat(raw(:, 1), 1000000);
%%
% THR = 200000;
target = table2array(raw(1:40000, 6));

histogram(target, 5000, 'FaceColor', 'black');
% hold on
% x = 4.8e08;
% line([x, x], [0, 150], 'LineWidth', 3, 'LineStyle','-.', 'Color', 'black')
% text(x-0.3e7, 100, '4 LZB', 'FontSize', 29);
% hold on
% x = 4.755e08;
% line([x, x], [0, 150], 'LineWidth', 3, 'LineStyle','-.', 'Color', 'black')
% text(x-0.3e7, 80, '8 LZB', 'FontSize', 29);
% hold on
% x = 4.71e08;
% line([x, x], [0, 150], 'LineWidth', 3, 'LineStyle','-.', 'Color', 'black')
% text(x-0.3e7, 60, '12 LZB', 'FontSize', 29);
% % 
xlim([1.43e8 1.49e8])
ylim([0 80])
xlabel('CPU Cycles')
ylabel('Histogram')
set(gca,'FontSize',35)