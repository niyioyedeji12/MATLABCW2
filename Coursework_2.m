% Niyi Oyedeji
% efyoo8@nottingham.ac.uk


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS] Arduino();
% Insert answers here
clear
clc

a = arduino("COM3","Uno"); % establish communication with arduino and matlab

for i = 1:10 % blinks led 10 times
writeDigitalPin(a,'D5',1) % turns led on
pause(0.5); % pauses for 0.5 seconds
writeDigitalPin(a, 'D5',0) % turns led off
pause(0.5); % pauses for 0.5 seconds
end



%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

% Insert answers here

clear
clc
clf

a = arduino("COM3","Uno"); % establish communication with arduino and matlab
sensorPin = 'A0'; % sensor pin used for temp sensor
duration = 600; % duration of 600 seconds
timeInterval = 1; % will check temp every second
readingsNum = 600; % 600 readings of temp as checking every second

temp = zeros(1,readingsNum); % array of 600 zeros to be filled 
voltage = zeros(1,readingsNum); % array of 600 zeros to be filled
time = 0:timeInterval:(duration-1); % gets 600 data points as 0 will be counted

TC = 0.01; % temp coefficient of 10mV/C
V0C = 0.5; % 500mV voltage at 0C

disp('Starting data acquisition...')
for t = 1:readingsNum
    voltage(t) = readVoltage(a, sensorPin);
    temp(t) = (voltage(t) - V0C) / TC;
    pause(timeInterval);
end

disp('Data acquisition finished.')

minTemp = min(temp);
maxTemp = max(temp);
avgTemp = mean(temp);

figure;
plot(time, temp, 'b-', 'LineWidth', 1.5);
xlabel('Time (mins)');
ylabel('Temperature (°C)');
title('Temperature vs Time');
grid on;

dateStr = input('What date is it today? (use the format dd/mm/yyyy): ', 's');
locationStr = input('Where are you located?: ', 's');
fprintf('Data Logging Initated - %s\n', dateStr);
fprintf('Location - %s\n\n', locationStr);

for t = 0:10
    minuteInterval = (t*60) + 1;
    fprintf('Minute %2d\n', t);
    fprintf('Temperature %2.f C\n\n', temp(minuteInterval));
end

fprintf('Max temp %.2f C\n', maxTemp);
fprintf('Min temp %.2f C\n\n', minTemp);
fprintf('Average temp %.2f C\n\n', avgTemp);
fprintf('Data logging terminated\n');

fileID = fopen('cabin_temperature.txt', 'w'); % Open file for writing

fprintf(fileID, 'Data logging initiated - %s\n', dateStr);
fprintf(fileID, 'Location - %s\n\n', locationStr);

for t = 0:10
    minuteInterval = (t * 60) + 1;
    fprintf(fileID, 'Minute %2d\n', t);
    fprintf(fileID, 'Temperature %.2f C\n\n', temperature(minuteInterval));
end

fprintf(fileID, 'Max temp %.2f C\n', maxTemp);
fprintf(fileID, 'Min temp %.2f C\n', minTemp);
fprintf(fileID, 'Average temp %.2f C\n\n', avgTemp);
fprintf(fileID, 'Data logging terminated\n');

fclose(fileID); % Close the file


%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert reflective statement here (400 words max)


%% TASK 5 - COMMENTING, VERSION CONTROL AND PROFESSIONAL PRACTICE [15 MARKS]

% No need to enter any answers here, but remember to:
% - Comment the code throughout.
% - Commit the changes to your git repository as you progress in your programming tasks.
% - Hand the Arduino project kit back to the lecturer with all parts and in working order.