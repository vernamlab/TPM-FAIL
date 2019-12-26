clc 
clear all
root_t4 = [68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 90];
root_bit4 = [0.0, 24.0, 32.0, 40.0, 64.0, 52.0, 72.0, 80.0, 72.0, 100.0, 100.0, 100.0, 100.0];
root_t8 = [31, 32, 33, 34, 90];
root_bit8 = [0.0, 6.89, 67.85, 100.0, 100.0];
root_t12 = [18,19,20,21,22,23, 90];
root_bit12=[0.0, 0.0, 0.0, 2.0, 86.0, 100.0, 100.0];


user_t4 = [68, 69, 70,71,72,73,74,75,76,77, 90];
user_bit4= [0, 5, 17, 35, 37, 50, 74, 76, 89, 100, 100];
user_t8 = [31, 32, 33, 34, 35, 90];
user_bit8 = [0, 3, 66, 100, 100, 100];


udp_t8 = [30,31, 32,33,34,35,36,37,38,39,40,41,42,43,44,45];
udp_bit8 = [0, 1,16,70,66.0000000000000, 73.0000000000000, 72.0000000000000, 64.0000000000000, 72.0000000000000, 63.0000000000000, 68.0000000000000, 65.0000000000000, 62.0000000000000, 69.0000000000000, 68.0000000000000, 63.0000000000000];
udp_t4   = [69,70,71,72,73,74,75,76,77,78,90];
udp_bit4 = [0, 5,5,30,40,60,65,75,75,100,100];




% plot(root_t4, root_bit4, '*-k', 'LineWidth', 4, 'MarkerSize', 30);
% hold on 
% plot(root_t8, root_bit8, 'o-b', 'LineWidth', 4, 'MarkerSize', 30);
% hold on
% plot(root_t12, root_bit12, '^-c', 'LineWidth', 4, 'MarkerSize', 30);
% hold on

plot(user_t4, user_bit4, 'x-.m', 'LineWidth', 4, 'MarkerSize', 30);
hold on
plot(user_t8, user_bit8, '^-.r', 'LineWidth', 4, 'MarkerSize', 30);

hold on
plot(udp_t4, udp_bit4, 'o-.b', 'LineWidth', 4, 'MarkerSize', 30);
hold on
plot(udp_t8, udp_bit8, '*-.k', 'LineWidth', 4, 'MarkerSize', 30);


legend(' user 4-bit', ' user 8-bit' ,' remote-udp 4-bit', ' remote-udp 8-bit' ,'Location', 'southeast', 'FontSize', 40);

ylim([0 102])
xlim([20 100])
xlabel('Latice Dimension')
ylabel('Success Probability')
set(gca,'FontSize',35)