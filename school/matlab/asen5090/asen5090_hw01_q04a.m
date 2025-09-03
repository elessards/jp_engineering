% HOMEWORK #01
% Author:   Justin Pedersen
% Date:     September 1st, 2025

%% PREAMBLE

clear; close all; clc;
fprintf("ASEN 5090 HOMEWORK 01 QUESTION 04A\n")
addpath('functions/')

%% QUESTION 4

%{
%}

%% INITIALIZE

% set PRN you want
prn = 19;
% set the number of chips you want
chips = 1023;

%% GENERATE CODES

% generate C/A code for the specified PRN and number of chips
code_prn19_ca = func_gen_code_CA(prn,chips,0);

% change the zeros and ones 
code_prn19_ca_cor = func_code_convert(code_prn19_ca);

%% CORRELATION

n = -500:500;
R_k = zeros(size(n));

% auto-correlation of PRN 19
for j = 1:length(n)

    sum_ac = 0;

    for i = 1:chips

        x_k = code_prn19_ca_cor(i);
        x_k_ipn = code_prn19_ca_cor(mod(i + n(j) - 1, 1023) + 1);
        sum_ac = sum_ac + x_k*x_k_ipn;
    
    end
    
    R_k(j) = (1/1023)*sum_ac;

end

%% PLOT

figure()
plot(n,R_k,'-*')
grid on
xlim([-1022/2 1022/2])
ylim([-0.2 1.2])
xlabel('Chip Offset')
ylabel('correlation energy')
title('PRN 19 Auto Correlation')

%% FUNCTIONS

function code_cor = func_code_convert(code)

% convert 0 -> 1 and 1 -> -1
code_cor = code;
code_cor(code == 0) = 1;
code_cor(code == 1) = -1;

end