function temp_prediction(a)
%  temp_prediction monitors and predicts temperature trends.
%  This function reads the temperature from a thermistor every second,
%  Calculates the average rate of change over 60 seconds in °C/s,
%  and predicts the temperature 5 minutes ahead.
%  LEDs indicate:
%  - green = stable,
%  - red = heating too fast (>4°c/min),
%  - yellow = cooling too fast (<-4°c/min).


% set up pins
greenLED = 'D2';
yellowLED = 'D3';
redLED = 'D4';
thermistorPin = 'A0';
configurePin(a, greenLED, 'DigitalOutput');
configurePin(a, yellowLED, 'DigitalOutput');
configurePin(a, redLED, 'DigitalOutput');

% constants
V0C = 0.5;       % voltage at 0°C
TC = 0.01;       % 10 mV per °C
cycleTime = 60; % 1 minute

% data storage
temps = zeros(1, cycleTime);
i = 1;

disp('Starting temperature monitoring and prediction...');

while 1
    % read and convert to °C
    voltage = readVoltage(a, thermistorPin);
    currentTemp = (voltage - V0C) / TC;

    % display current temperature
    disp(['Current temperature: ', num2str(currentTemp), '°c']);

    % store reading in cycle time
    temps(i) = currentTemp;

    % only calculate rate after 60 readings
    if i == cycleTime
        tempStart = temps(1);
        tempEnd = temps(end);
        rate = (tempEnd - tempStart) / (cycleTime - 1); % °C/s (derivative of data)

        % predict future temp in 5 mins
        predictedTemp = currentTemp + rate * 300;

        % show results
        disp(['rate of change: ', num2str(rate), '°c/s']);
        disp(['predicted temp in 5 mins: ', num2str(predictedTemp), '°c']);

        % led control
        if rate > 0.0667
            % heating too fast
            writeDigitalPin(a, greenLED, 0);
            writeDigitalPin(a, yellowLED, 0);
            writeDigitalPin(a, redLED, 1);
        elseif rate < -0.0667
            % cooling too fast
            writeDigitalPin(a, greenLED, 0);
            writeDigitalPin(a, yellowLED, 1);
            writeDigitalPin(a, redLED, 0);
        elseif currentTemp > 18 && currentTemp < 24
            % comfort temp inside stable rate
            writeDigitalPin(a, greenLED, 1);
            writeDigitalPin(a, yellowLED, 0);
            writeDigitalPin(a, redLED, 0);
        else
            % stable rate outside comfort range flash green
            writeDigitalPin(a, greenLED, 1);
            pause(0.5)
             writeDigitalPin(a, greenLED, 0);
            pause(0.5)
             writeDigitalPin(a, greenLED, 1);
            pause(0.5)
             writeDigitalPin(a, greenLED, 0);
            pause(0.5)
             writeDigitalPin(a, greenLED, 1);
            pause(0.5)
             writeDigitalPin(a, greenLED, 0);
            pause(0.5)
             writeDigitalPin(a, greenLED, 1);
            pause(0.5)
             writeDigitalPin(a, greenLED, 0);
              writeDigitalPin(a, greenLED, 1);
            pause(0.5)
             writeDigitalPin(a, greenLED, 0);
            pause(0.5)
             writeDigitalPin(a, greenLED, 1);
            pause(0.5)
             writeDigitalPin(a, greenLED, 0);
            writeDigitalPin(a, yellowLED, 0);
            writeDigitalPin(a, redLED, 0);

        end

        % cycle start again
        i = 1;
    else
        i = i + 1;
    end

    pause(1);
end
end
