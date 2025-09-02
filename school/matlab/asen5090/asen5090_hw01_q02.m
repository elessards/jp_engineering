% HOMEWORK #01
% Author:   Justin Pedersen
% Date:     August 30th, 2025

%% PREAMBLE

clear; close all; clc;
fprintf("ASEN 5090 HOMEWORK 01 QUESTION 02\n")

%% QUESTION 2A
%{
Write a simple, well-organized program/code to simulate the aircraft motion for specified
values of v0, x0, and h0; and for this motion, compute and plot the ideal zenith angle,
range, and range rate observations as a function of the horizontal position of the aircraft
(x). Plot the measurements for the following values: v0=50m/s, x0=250m, h0=100 m.
%}

%% SETUP FOR 2A

v0 = 50;                % aircraft velocity, constant, [m/s]
h0 = 100;               % initial height of the aircraft, [m]
x0 = 250;               % aircraft x-position, [m]

% setup array of horizontal positions of the aircraft in integers of 1 [m]
x = -500:1:500;

%% CALCULATIONS FOR 2A

% compute range, zenith angle, and range rate for array of x positions
[R,z,R_dot] = meas_geometry_2d(x,h0,v0);

% compute range, zenith angle, and range rate for x0=250m
R_x0 = sqrt(x0^2 + h0^2);
z_x0 = 90 - acosd(x0/R_x0);
R_dot_x0 = (x0/R_x0) * v0;

%% PLOT FOR QUESTION 2A

% plot range as a function of the aircraft x-position
figure()
plot(x,R,'.')
grid on
hold on
plot(250,sqrt(abs(250)^2 + h0^2),'ro','LineWidth',1.5)
xline(x0,'r-')
yline(R_x0,'r-')
ylim([0 max(R)])
xlabel('horizontal aircraft position [m]')
ylabel('range [m]')
title('Range vs X-Position')
legend('range','range at x0=250m','','')

% plot zenith angle as a function off the aircraft position
figure()
plot(x,z,'.')
grid on
hold on
plot(x0,z_x0,'ro')
xline(x0,'r-')
yline(z_x0,'r-')
ylim([0 90])
xlabel('horizontal aircraft position [m]')
ylabel('zenith angle [degrees]')
title('Zenith Angle vs X-Position')
legend('zenith angle','zenith angle at x0=250m','','')

% plot zenith angle as a function off the aircraft position
figure()
plot(x,R_dot,'.')
grid on
hold on
plot(x0,R_dot_x0,'ro')
xline(x0,'r-')
yline(R_dot_x0,'r-')
ylim([0 60])
xlabel('horizontal aircraft position [m]')
ylabel('range rate [m/s]')
title('Range Rate vs X-Position')
legend('range rate','range rate at x0=250m','','')

%% QUESTION 2B

%{
How useful are the three types of measurements for determining x? In other words, how
sensitive is each measurement to the aircraft position? For which portion(s) of the flight
does each measurement work well and where is it not very useful? Explain.
%}

%% CALCULATIONS FOR 2B

% pre-allocate arrays
R_diff = zeros(length(x)-1,3);
z_diff = zeros(length(x)-1,3);
R_dot_diff = zeros(length(x)-1,3);
dR = zeros(length(x),3);
dz = zeros(length(x),3);
dR_dot = zeros(length(x),3);
% calculate difference and gradient for difference aircraft heights
h = [100,50,150];
for i = 1:3
    [R,z,R_dot] = meas_geometry_2d(x,h(i),v0);
    % difference and gradient of range
    R_diff(:,i) = diff(R);
    dR(:,i) = gradient(R);
    % difference and gradient of zenith angle
    z_diff(:,i) = diff(z);
    dz(:,i) = gradient(z);
    % difference and gradient of range rate
    R_dot_diff(:,i) = diff(R_dot);
    dR_dot(:,i) = gradient(R_dot);
end

%% PLOTS FOR QUESTION 2B

for i = 1:3

    % range plots
    figure(101)
    plot(x(2:end),R_diff(:,i),'.')
    grid on
    hold on
    xlabel('horizontal aircraft position [m]')
    ylabel('delta range [m]')
    title('Successive Differences in Range Values')
    if i == 3
        legend('h=100m','h=50m','h=150m')
    end
    
    figure(102)
    plot(x,dR(:,i),'.')
    grid on
    hold on
    xlabel('horizontal aircraft position [m]')
    ylabel('change in R per change in X (dR/dx)')
    title('Range Derivative Approximation (gradient)')
    if i == 3
        legend('h=100m','h=50m','h=150m')
    end
    
    % zenith angle plots
    figure(103)
    plot(x(2:end),z_diff(:,i),'.')
    grid on
    hold on
    xlabel('horizontal aircraft position [m]')
    ylabel('delta zenith angle [degrees]')
    title('Successive Differences in Zenith Angle Values')
    if i == 3
        legend('h=100m','h=50m','h=150m')
    end
    
    figure(104)
    plot(x,dz(:,i),'.')
    grid on
    hold on
    xlabel('horizontal aircraft position [m]')
    ylabel('change in zenith angle per change in X (dz/dx)')
    title('Zenith Angle Derivative Approximation (gradient)')
    if i == 3
        legend('h=100m','h=50m','h=150m')
    end
    
    % range rate plots
    figure(105)
    plot(x(2:end),R_dot_diff(:,i),'.')
    grid on
    hold on
    xlabel('horizontal aircraft position [m]')
    ylabel('delta range rate [m/s]')
    title('Successive Differences in Range Rate Values')
    if i == 3
        legend('h=100m','h=50m','h=150m')
    end
    
    figure(106)
    plot(x,dR_dot(:,i),'.')
    grid on
    hold on
    xlabel('horizontal aircraft position [m]')
    ylabel('change in range rate per change in X (dR_dot/dx)')
    title('Range Rate Derivative Approximation (gradient)')
    if i == 3
        legend('h=100m','h=50m','h=150m')
    end
end

%% FUNCTIONS

function [R,z,R_dot] = meas_geometry_2d(x,h,v)

% compute range as a function of x-position
R = sqrt(abs(x).^2 + h^2);
% compute zenith angle as a function of x-position
z = 90 - acosd(abs(x)./R);
% compute range rate as a functio of x-position
R_dot = (abs(x)./R).*v;

end