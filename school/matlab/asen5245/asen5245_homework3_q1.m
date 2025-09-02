%% ASEN 5245 HOMEWORK 3 - QUESTION 1
% date: 02/15/25
% author: Justin Pedersen

% initialize workspace
clear; clc; close all;

% load constants
constants

fprintf(">>> ASEN 5245 HOMEWORK 3 <<<\n")
fprintf("Question #1\n")

%% VARIABLES

mu_0 = (4*pi)*e-7;                  % magnetic permeability [H/m]
e_r = 3;                            % dialectric constant
lambda = 0.1;                       % wavelength [m]

%% PART A
fprintf("Part A\n")

mu_p = c/sqrt(e_r);
freq = mu_p/lambda;
fprintf("The operating frequency of this radar is: %.2f GHz\n", freq/1e9)

%% PART C
fprintf("\nPart C\n")

E_mag = 1;
H_mag = 2.65e-3;

resistance = E_mag/H_mag;
fprintf("The ratio between the amplitude of the E field aand amplitude of H field is: %.2f Ohms\n", resistance)
