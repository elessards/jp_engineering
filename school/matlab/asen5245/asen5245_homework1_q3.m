%% ASEN 5245 HOMEWORK 1 - QUESTION 3
% date: 01/19/25
% author: Justin Pedersen

% initialize workspace
clear; clc; close all;

% load constants
constants

fprintf(">>> ASEN 5245 HOMEWORK 1\n")
fprintf("Question #3\n")

%% LOAD VALUES

tau = 1e-6;                     % pulse width [seconds]
T_p = 200e-6;                   % pulse repetition time [seconds]

%% ANSWERS

% a. range resolution
RR = c*tau/2;
fprintf("a. Range Resolution                    = %.2f [m]\n", RR)

% c. apparent range to taret
T2 = 80e-6;                     % time for retun signal [seconds]
R_app = T2*c/2;
fprintf("a. Apparent Range                      = %.2f [m]\n", R_app)

% d. unambiguous rangge
R_u = T_p*c/2;
fprintf("a. Unambiguous Range                   = %.2f [m]\n", R_u)

% e. apparent range
R_true = 37.5e3;                % true rannge [meters]
T1 = 2*R_true/c;
T2 = T1-T_p;

R_app = (T2*c)/2;
fprintf("a. Apparent Range                      = %.2f [m]\n", R_app)