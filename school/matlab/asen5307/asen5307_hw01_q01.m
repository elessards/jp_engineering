% HOMEWORK #01
% Author:   Justin Pedersen
% Date:     August 30th, 2025
% Class:    ASEN 5307 Engineering Data Analysis Methods

%% PREAMBLE

clear; close all; clc;
fprintf("ASEN 5037 HOMEWORK 01 QUESTION 01\n")

%% LOAD DATA

% load raw data from .mat
data_raw = load('data/boulder_precip.mat');

% parse data into more practical struct
data.year =     data_raw.precip(:,1);
data.month =    data_raw.precip(:,2);
data.day =      data_raw.precip(:,3);
data.percip =   data_raw.precip(:,4);

% convert individual year, month, and day to vector of datetime
data.date = datetime(data.year,data.month,data.day);

% cleanup
clear data_raw

%% QUESTION 1A
% calculate the mean of the total percipitation averaged for each month

% find the number of unique years
year_uniq = unique(data.year);

% pre-allocate
monthly_sums = zeros(length(year_uniq),12);
monthly_means = zeros(length(year_uniq),12);

% parse the data to isolate the total percipitation each month
for i=1:length(year_uniq)
    % find the data points in the year
    idx1 = find(data.year == year_uniq(i));
    month_uniq = unique(data.month(idx1));
    for j=1:length(month_uniq)
        % cross reference with the year and the month to find the days
        idx2 = find(data.month == month_uniq(j));
        idx3 = intersect(idx1,idx2);
        % find the sum of precipitation for that month
        monthlySum = sum(data.percip(idx3));
        monthlyAve = mean((data.percip((idx3))));
        % store into matrix
        monthly_sums(i,month_uniq(j)) = monthlySum;
        monthly_means(i,month_uniq(j)) = monthlyAve;
    end

end

data.monthly.years =    year_uniq;
data.monthly.sums =     monthly_sums;
data.monthly.means =    monthly_means;

% find the mean & std of the total precipitation averaged for each month
for i=1:12
    idx = find(data.monthly.sums(:,i) ~= 0);
    data.monthly.perMonth_ave(1,i) = mean(data.monthly.sums(idx,i));
    data.monthly.perMonth_std(1,i) = std(data.monthly.sums(idx,i));
end

% clean up
clearvars -except data

%% PLOT

% mean precipitation versus month
figure()
plot(data.monthly.perMonth_ave,'-*','LineWidth',1.5)
grid on
xlim([1 12])
xticks(1:12)
xticklabels({'Jan','Feb','Mar','Apr','May','Jun',...
             'Jul','Aug','Sep','Oct','Nov','Dec'})
xlabel('month')
ylabel('mean precipitation [in]')
title('Mean Precipitation For Each Month Since 1948')

% standard deviation o precipitation versus month
figure()
plot(data.monthly.perMonth_std,'-*','LineWidth',1.5)
grid on
xlim([1 12])
xticks(1:12)
xticklabels({'Jan','Feb','Mar','Apr','May','Jun',...
             'Jul','Aug','Sep','Oct','Nov','Dec'})

xlabel('month')
ylabel('\sigma precipitation [in]')
title('Standard Deviation of Precipitation For Each Month Since 1948')