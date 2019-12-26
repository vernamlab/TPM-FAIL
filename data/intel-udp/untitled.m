clc 
clear all
raw = readtable('result_rsa.csv');
% raw = vec2mat(raw(:, 1), 1000000);
%%
% THR = 200000;
target = table2array(raw(:, 27.02e8));
% b1 = numel(find(target < 7.023e8))
% b2 = numel(find(target > 7.023e8 & target < 7.024e8))
% b3 = numel(find(target > 7.024e8 & target < 7.025e8))
% b4 = numel(find(target > 7.025e8 & target < 7.026e8))
% b5 = numel(find(target > 7.026e8& target < 7.027e8))
% b5 = numel(find(target > 7.027e8& target < 7.028e8))
% b5 = numel(find(target > 7.028e8& target < 7.029e8))
% b4 = numel(find(target > 4.77e8))

% b1 = numel(find(target < 4.04e8))
% b2 = numel(find(target > 4.04e8 & target < 4.08e8))
% b3 = numel(find(target > 4.08e8 & target < 4.12e8))
% b4 = numel(find(target > 4.12e8))

% target = target(target < 1.47e8);
% b1 = numel(find(target < 1.45e8))
% b2 = numel(find(target > 1.45e8))


% histogram(target, 5000, 'DisplayStyle', 'stairs');
% hold on
histogram(target, 5000);
% xlim([4.85e8 5.1e8])
xlabel('CPU Cycles')
ylabel('Histogram')
set(gca,'FontSize',60)
