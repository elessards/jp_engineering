clear; close all; clc;

%% DATA

% FPGA stats
time_exec_fpga = 0.823;                     % seconds
power_consum_fpga = 1.31;                   % watts

% ASIC stats
time_exec_asic = 0.3;                       % seconds
power_consum_asic = power_consum_fpga/6.5;  % watts

%% PLOT

figure()
subplot(2,1,1)
plot(power_consum_fpga,time_exec_fpga,'x','linewidth',1.5,'MarkerSize',12)
grid on
hold on
plot(power_consum_asic,time_exec_asic,'x','linewidth',1.5,'MarkerSize',12)
xlim([0 2])
ylim([0 1])
legend('FPGA (Zynq US+)','ASIC (estimated)','Location','best')
xlabel('power consumption [Watts]')
ylabel('execution time [s]')
title('ASIC & FPGA Performance')

X = categorical({'power consumption [watts]', 'execution time [s]'});

subplot(2,1,2)
bar(X, [time_exec_fpga time_exec_asic;power_consum_fpga power_consum_asic])
grid on
legend('FPGA (Zynq US+)','ASIC (estimated)')
title('ASIC vs FPGA: Power and Speed')


