% HOMEWORK #01
% Author:   Justin Pedersen
% Date:     September 3rd, 2025
% Class:    ASEN 5307 Engineering Data Analysis Methods

%% PREAMBLE

clear; close all; clc;
fprintf("ASEN 5037 HOMEWORK 01 QUESTION 02\n")

%% LOAD DATA

% load raw data from .mat
data_raw = load('data/boulder_temp.mat');

% parse data into more practical struct
data.year   = data_raw.temp(:,1);
data.month  = data_raw.temp(:,2);
data.day    = data_raw.temp(:,3);
data.temp   = data_raw.temp(:,4);

% convert individual year, month, and day to vector of datetime
data.date = datetime(data.year,data.month,data.day);

% find the average temperature for each year
year_uniq = unique(data.year);
data.years_jan1 = datetime(year_uniq,6,1); 
data.temp_yearly_mean = zeros(length(year_uniq),1);
for i = 1:length(year_uniq)
    idx = find(data.year == year_uniq(i));
    data.temp_yearly_mean(i,1) = mean(data.temp(idx));
end

% find the probability of the temperature is greater than 80 degrees during July
idx = find(data.month == 7);
julyDays_above80 = sum(data.temp(idx) > 80);
data.p_july_tempAbove80 = julyDays_above80/length(idx);
fprintf('Probability of the temperature greater than 80 F in July: %.2f%%\n',data.p_july_tempAbove80*100)

% store all the entries for temperature on March days in a variable called march_temp
idx = find(data.month == 3);
data.march_temp = data.temp(idx);

% calculate the skewness of March temperature data
x_bar = mean(data.march_temp);      % average
sigma = std(data.march_temp);       % standard deviation
n = length(data.march_temp);        % number of data points
skewness = 0;
for i = 1:n
    skewness = skewness + ((data.march_temp(i) - x_bar)/sigma)^3;
end
skewness = (1/n)*skewness;
fprintf('The skewness of the distribution: %f\n',skewness)

% calculate kurtosis of March temperature data
kurt_sum = 0;
for i = 1:n
    kurt_sum = kurt_sum + ((data.march_temp(i) - x_bar)/sigma)^4;
end
kurtosis_val = (1/n) * kurt_sum;
fprintf('The kurtosis of the distribution: %.4f\n',kurtosis_val)

% find the warmest and coolest temperatures found in the data?
max_temp = max(data.temp);
min_temp = min(data.temp);
fprintf('The warmest temperature recorded: %.2f F\n', max_temp);
fprintf('The coolest temperature recorded: %.2f F\n', min_temp);

% cleanup
clearvars -except data

%% PLOT

figure()
plot(data.date,data.temp)
grid on
hold on
plot(data.years_jan1,data.temp_yearly_mean,'-o','LineWidth',1.5)
xlabel('date/time')
ylabel('temperature [^oF]')
title('Time Series for Temperature')
legend('temperature','mean temperature per year')

figure()
histogram(data.march_temp)
grid on
xlabel('temperature [^oF]')
ylabel('number of days')
title('Temperature Distribution in March')