%% ASEN 5245 HOMEWORK 3 - QUESTION 2
% date: 02/17/25
% author: Justin Pedersen

% initialize workspace
clear; clc; close all;

% load constants
constants

fprintf(">>> ASEN 5245 HOMEWORK 3\n")
fprintf("Question #2\n")

%% LOAD VALUES

f = 3e9;                        % pulse width [Hz]
R = 10e3;                       % range [m]

%% PART A
fprintf("Part A\n")

% number of waves
lambda = c/f;
fprintf("Wavelength =               %f meters\n", lambda)
fprintf("Number of wavelengths =    %f\n", R/lambda)

%% PART B
fprintf("\nPart B\n")

N = 200;
n = 1 + (10e-6)*N;
fprintf("Index of refraction =      %f\n", n)

e_r = n^2;
fprintf("Electrical permeability =  %f\n", e_r)

v_phase = c/sqrt(e_r);
fprintf("Propagation Speed =        %e\n", v_phase)

lambda = v_phase/f;
fprintf("Number of wavelengths =    %f\n", R/lambda)

