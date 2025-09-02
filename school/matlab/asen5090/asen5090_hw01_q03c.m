% HOMEWORK #01
% Author:   Justin Pedersen
% Date:     August 31st, 2025

%% PREAMBLE

clear; close all; clc;
fprintf("ASEN 5090 HOMEWORK 01 QUESTION 03B\n")
addpath('functions/')

%% QUESTION 3

%{
GPS Textbook Homework Questionn 2-1
Build a C/A Code Generator for PRN 25 and examine first and last 16 chips
%}

%% INITIALIZE

prn = 25;
chips = 1023;

%% EXECUTE

% Generate C/A code for the specified PRN and number of chips
code = func_gen_code_CA(prn, chips);

% confirm first 16 chips expressed as hexadecimal is E6D6
first_16 = code(1:16);
binStr = num2str(first_16,'%1d');   % convert to string of '0' and '1'
binStr = binStr(~isspace(binStr));  % remove spaces
hexStrFirst = dec2hex(bin2dec(binStr));  % convert binary string to hex
disp(hexStrFirst)

% isolate last 16 chips
last_16 = code(end-15:end);
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
title('PRN 25 - First 16 Chips')
subtitle(['Hexadecimal:' ' ' hexStrFirst])

figure()
stairs(length(code)-15:length(code), last_16, 'LineWidth', 2)
grid on
xlim([length(code)-15 length(code)+1])
ylim([-0.2 1.2])
yticks([0 1])
xlabel('chip index')
ylabel('bit State')
title('PRN 25 - Last 16 Chips')
subtitle(['Hexadecimal:' ' ' hexStrLast])