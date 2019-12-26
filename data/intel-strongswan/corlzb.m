clc 
clear all
raw = csvread('lzb.csv');
%%
% raw = raw(raw(:, 2) > 8.4e7);
% raw = raw(1:40000, :);
x = raw(raw(:, 2) > 4.65e8, :);
lzb = 256 - x(:, 1);
tt = x(:, 2);
% cr = corr(tt, lzb);
% cr = corr(tt, lzb');

boxplot(tt, lzb, 'Colors','k', 'whisker',2.5);
lines = findobj(gcf, 'tag', 'Outliers');
set(lines, 'Color', 'b');
% THR = 200000;
% target = table2array(raw(1:40000, 6));

% histogram(target, 5000, 'FaceColor', 'black');
% xlim([244 256])
ylabel('CPU Cycles')
xlabel('Bit Length')
set(gca,'FontSize',35)
box off