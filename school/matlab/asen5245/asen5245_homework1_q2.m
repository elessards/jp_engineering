%% ASEN 5245 HOMEWORK 1 - QUESTION 2
% date: 01/19/25
% author: Justin Pedersen

% initialize workspace
clear; clc; close all;

% add path
addpath('functions/')

% load constants
constants

fprintf(">>> ASEN 5245 HOMEWORK 1\n")
fprintf("Question #2\n")

%% LOAD VALUES

Pt_lin = 100e3;             % transmit power [watts]
f = 9.4e9;                  % frequency [Hz]
G_tx_db = 32;               % transmitter antenna gain [dB]
G_rx_db = 28;               % receiver antenna gain [dB]

%% PART A
fprintf("\nPART A\n")

lambda_lin = c/f;
fprintf("Wavelength                             = %e [m]\n", lambda_lin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% VARIABLES

RCS_db = 0;                 % radar cross section [dBsm]
R_tx_lin = 50e3;            % transmitter antenna-to-target range [m]
R_rx_lin = 25e3;            % receiver antenna-to-target range [m]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% CALCULATE VARIABLES

lambda = c/f;

% linear calculations
G_tx_lin = func_db2lin(G_tx_db);
fprintf("Transmit Gain (G_tx)                   = %e [unitless]\n", G_tx_lin)
G_rx_lin = func_db2lin(G_rx_db);
fprintf("Receiver Gain (G_rx)                   = %e [unitless]\n", G_rx_lin)
RCS_lin = func_db2lin(RCS_db);
fprintf("Radar Cross Section                    = %e [m^2]\n", RCS_lin)
const_db_1 = func_lin2db((4*pi)^3);
fprintf("(4*Pi)^3 Constant                      = %.0f [dB]\n", const_db_1)
const_db_2 = func_lin2db(R_tx_lin^2);
fprintf("Transmitter Antenna-to-target Range    = %.0f [dB]\n", const_db_2)
const_db_3 = func_lin2db(R_rx_lin^2);
fprintf("Receiver Antenna-to-Target Rrange      = %.0f [dB]\n", const_db_3)


% decibel calculations
fprintf("\n")
Pt_db = func_lin2db(Pt_lin);
fprintf("Power Transmittted (Pt)                = %.0f [dBW]\n", Pt_db)
lambda_db = func_lin2db(lambda_lin^2);
fprintf("Lambda Squared                         = %.0f [dBsm]\n", lambda_db)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% ANSWER

Pr_lin = (Pt_lin*(G_tx_lin)*(G_rx_lin)*(lambda_lin^2)*RCS_lin)/(((4*pi)^3)*(R_tx_lin^2)*(R_rx_lin^2));
fprintf("Power Received                         = %e [watts]\n", Pr_lin)

%% PART B
fprintf("\nPART B\n")

Pr_db = Pt_db + G_tx_db + G_rx_db + lambda_db + RCS_db - const_db_1 - const_db_2 - const_db_3;
fprintf("Power Received                         = %.0f [dB]\n", Pr_db)