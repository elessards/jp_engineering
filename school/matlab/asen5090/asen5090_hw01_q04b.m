% HOMEWORK #01
% Author:   Justin Pedersen
% Date:     September 1st, 2025

%% PREAMBLE

clear; close all; clc;
fprintf("ASEN 5090 HOMEWORK 01 QUESTION 04B\n")
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
code_prn19_ca_delayed = func_gen_code_CA(prn,chips,200);

% change the zeros and ones 
code_prn19_ca_cor = func_code_convert(code_prn19_ca);
code_prn19_ca_cor_delyaed = func_code_convert(code_prn19_ca_delayed);

%% CORRELATE

n = -1022/2:1022/2;
R_k = func_correlate_cross(n,code_prn19_ca_cor,code_prn19_ca_cor_delyaed);

%% PLOT

figure()
plot(n,R_k,'-*')
grid on
xlim([-1022/2 1022/2])
ylim([-0.2 1.2])
xlabel('Chip Offset')
ylabel('correlation energy')
title('PRN 19 & 19 200 ms Delayed Cross Correlation')
