% HOMEWORK #01
% Author:   Justin Pedersen
% Date:     August 31st, 2025

%% PREAMBLE

clear; close all; clc;
fprintf("ASEN 5090 HOMEWORK 01 QUESTION 03B\n")

%% QUESTION 3

%{
GPS Textbook Homework Questionn 2-1
Build a C/A Code Generator for PRN 19 to compare the first 1024 chips and
the next 1024 chips
%}

%% INITIALIZE

prn = 19;
chips = 2046;

% Generate C/A code for the specified PRN and number of chips
code = func_gen_code_CA(prn, chips);
code1 = code(1:1023);       % first 1023
code2 = code(1024:2046);    % second 1023
delta = code1-code2;        % code delta

%% PLOT

figure()
stairs(1:length(code1),code1,'LineWidth', 2)
hold on
stairs(1:length(code2),code2)
grid on
xlim([1 1024])
ylim([-0.2 1.2])
yticks([0 1])
xlabel('chip index')
ylabel('bit State')
legend('1st 1023','2nd 1023')
title('Comparing PRN 19 1st 1023 & 2nd 1023')

figure()
stairs(1:length(delta),delta,'LineWidth', 2)
grid on
xlim([1 1024])
ylim([-0.2 1.2])
yticks([0 1])
xlabel('chip index')
ylabel('bit State')
title('PRN 19 Delta of 1st 1023 & 2nd 1023')

%% FUNCTIONS

function [code] = func_gen_code_CA(prn,chips)

% g2 register taps for given PRN
ca_code_taps = readmatrix('data/gps_ca_code.csv');
idx = find(ca_code_taps(:,1) == prn);
prn_bit1 = ca_code_taps(idx,2);
prn_bit2 = ca_code_taps(idx,3);

% initialize both G1 and G2 bit shift registers (bsr) with ones
g1_bsr = ones(1,10);
g2_bsr = ones(1,10);

% initialize C/A code array
code = [];

for i = 1:chips
    % generate XG_i C/A Code
    s1 = g2_bsr(prn_bit1);
    s2 = g2_bsr(prn_bit2);
    G2_i = bitxor(s1,s2);
    
    % save g1 out
    G1 = g1_bsr(10);
    
    % generate new register bits for g1 and g2
    g1_new = bitxor(g1_bsr(3),g1_bsr(10));
    g2_new = bitxor(bitxor(bitxor(bitxor(bitxor(g2_bsr(2),g2_bsr(3)),g2_bsr(6)),g2_bsr(8)),g2_bsr(9)),g2_bsr(10));
    
    % shift the register and add the new bit to the leftmost element
    g1_bsr = [g1_new g1_bsr(1:9)];
    g2_bsr = [g2_new g2_bsr(1:9)];
    
    % update C/A code
    code = [code bitxor(G2_i,G1)];
end

end

