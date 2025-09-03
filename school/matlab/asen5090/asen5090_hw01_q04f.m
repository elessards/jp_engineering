% HOMEWORK #01
% Author:   Justin Pedersen
% Date:     September 1st, 2025

%% PREAMBLE

clear; close all; clc;
fprintf("ASEN 5090 HOMEWORK 01 QUESTION 04F\n")
addpath('functions/')

%% QUESTION 4

%{
%}

%% SETUP

% set the number of chips you want
chips = 1023;

% noise vecto
noise = 4*rand(1,1023);

%% GENERATE CODES

% generate C/A code for the specified PRN and number of chips
code_prn25_ca_delayed = func_gen_code_CA(25,chips,905);
code_prn19_ca_delayed = func_gen_code_CA(19,chips,350);
code_prn05_ca_delayed = func_gen_code_CA(5,chips,75);

code_prn19_ca = func_gen_code_CA(19,chips,0);

% change the zeros and ones 
code_prn25_ca_cor_delayed = func_code_convert(code_prn25_ca_delayed);
code_prn19_ca_cor_delayed = func_code_convert(code_prn19_ca_delayed);
code_prn05_ca_cor_delayed = func_code_convert(code_prn05_ca_delayed);

code_prn19_ca_cor = func_code_convert(code_prn19_ca);

sum = code_prn25_ca_cor_delayed+code_prn19_ca_cor_delayed+code_prn05_ca_cor_delayed+noise;

% cross correlate
n = -1022/2:1022/2;
R_k_l = func_correlate_cross(n,code_prn19_ca_cor,sum);

%% PLOT

figure()
subplot(4,1,1)
stairs(code_prn25_ca_cor_delayed);
xlim([1 1023])
ylim([-1.2 4])
title('C/A Code PRN 25 (Delayed)');
xlabel('chip index');
ylabel('amplitude');
subplot(4,1,2)
stairs(code_prn19_ca_cor_delayed);
xlim([1 1023])
ylim([-1.2 4])
title('C/A Code PRN 19 (Delayed)');
xlabel('chip index');
ylabel('amplitude');
subplot(4,1,3)
stairs(code_prn05_ca_cor_delayed);
xlim([1 1023])
ylim([-1.2 4])
title('C/A Code PRN 05 (Delayed)');
xlabel('chip index');
ylabel('amplitude');
subplot(4,1,4)
plot(noise);
xlim([1 1023])
ylim([-1.2 4])
title('Noise');
xlabel('chip index');
ylabel('amplitude');

figure()
plot(sum)
grid on
xlim([1 1023])
xlabel('chip index')
ylabel('amplitude');
title('Full Signal: PRN 25, 19, & 5 w/ Noise');

figure()
plot(n,R_k_l,'-*')
grid on
xlim([-1022/2 1022/2])
xlabel('chip index');
ylabel('amplitude');
title('PRN 19 Cross Corellation w/ Full Signal');



