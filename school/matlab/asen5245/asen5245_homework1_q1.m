%% ASEN 5245 HOMEWORK 1 - QUESTION 1
% date: 01/19/25
% author: Justin Pedersen

% initialize workspace
clear; clc; close all;

% function path
addpath('functions/')

% load constants
constants

fprintf(">>> ASEN 5245 HOMEWORK 1\n")
fprintf("Question #1\n")

%% LOAD VALUES

Pt = 250e3;         % transmit power [watts]
Gtx = 50;           % tx antenna gain [dB]
Grx = 50;           % rx antenna gain [dB]
f = 35.3e9;         % frequency [Hz]
RCS = 0.01^2;       % radar cross section [m^2]
R = 1e3;            % range [m]

% monostatic radar (Gtx = Grx = G)
G_dB = Gtx;

%% PART A
fprintf("\nPART A\n")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% CALCULATE VARIABLES

% radar cross section
fprintf("Radar Cross Section    = %e [m^2]\n", RCS)

% G linearized
G_lin = 10^(G_dB/10);
fprintf("G linearized           = %e [unitless]\n", G_lin)

% wavelength
lambda = c/f;
fprintf("Wavelength (lambda)    = %f [m]\n", lambda)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% RESULTS

Pr = (Pt*(G_lin^2)*(lambda^2)*RCS)/(((4*pi)^3)*(R^4));
fprintf("Power received         = %e [watts]\n", Pr)


%% PART B
fprintf("\nPART B\n")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% CALCULATE VARIABLES

% Convert to dB
Pt_dB = func_lin2db(Pt);
fprintf("Power transmitted      = %.0f [dB]\n", Pt_dB)
lambda_dB = func_lin2db(lambda^2);
fprintf("Lambda                 = %.0f [dB]\n", lambda_dB)
RCS_dB = func_lin2db(RCS);
fprintf("Radar Cross Section    = %.0f [dB]\n", RCS_dB)
const_dB = func_lin2db((4*pi)^3) + func_lin2db(R^4);
fprintf("Denominator Constant   = %.0f [dB]\n", const_dB)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% RESULTS

Pr_dB = Pt_dB+G_dB+G_dB+lambda_dB+RCS_dB-const_dB;
fprintf("Power received         = %.0f [dB]\n", Pr_dB)
