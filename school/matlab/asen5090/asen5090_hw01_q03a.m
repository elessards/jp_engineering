% HOMEWORK #01
% Author:   Justin Pedersen
% Date:     August 31st, 2025

%% PREAMBLE

clear; close all; clc;
fprintf("ASEN 5090 HOMEWORK 01 QUESTION 03A\n")

%% QUESTION 3

%{
GPS Textbook Homework Questionn 2-1
Build a C/A Code Generator for PRN 19
%}

%% INITIALIZE

% PRN bits for 
prn_bit1 = 3;
prn_bit2 = 6;

% initialize both G1 and G2 bit shift registers (bsr) with ones
g1_bsr = ones(1,10);
g2_bsr = ones(1,10);

%% EXECUTE

% initialize C/A code array
code_ca = [];

for i = 1:1023
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
    code_ca = [code_ca bitxor(G2_i,G1)];
end

% confirm first 16 chips expressed as hexadecimal is E6D6
first_16 = code_ca(1:16);
binStr = num2str(first_16,'%1d');   % convert to string of '0' and '1'
binStr = binStr(~isspace(binStr));  % remove spaces
hexStrFirst = dec2hex(bin2dec(binStr));  % convert binary string to hex
disp(hexStrFirst)

% isolate last 16 chips
last_16 = code_ca(end-15:end);
binStrLast = num2str(last_16,'%1d');   % convert to string of '0' and '1'
binStrLast = binStrLast(~isspace(binStrLast));  % remove spaces
hexStrLast = dec2hex(bin2dec(binStrLast));  % convert binary string to hex
disp(hexStrLast)

%% PLOT

figure()
stairs(1:length(first_16), first_16, 'LineWidth', 2)
grid on
xlim([1 17])
ylim([-0.2 1.2])
yticks([0 1])
xlabel('chip index')
ylabel('bit State')
title('PRN 19 - First 16 Chips')
subtitle(['Hexadecimal:' ' ' hexStrFirst])

figure()
stairs(length(code_ca)-15:length(code_ca), last_16, 'LineWidth', 2)
grid on
xlim([length(code_ca)-15 length(code_ca)+1])
ylim([-0.2 1.2])
yticks([0 1])
xlabel('chip index')
ylabel('bit State')
title('PRN 19 - Last 16 Chips')
subtitle(['Hexadecimal:' ' ' hexStrLast])

