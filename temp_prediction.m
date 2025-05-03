function temp_prediction(a)
%  temp_prediction monitors and predicts temperature trends.
%  this function reads the temperature from a thermistor every second,
%  calculates the average rate of change over 60 seconds in °C/s,
%  and predicts the temperature 5 minutes ahead.
%  leds indicate:
%  - green = stable,
%  - red = heating too fast (>4°c/min),
%  - yellow = cooling too fast (<-4°c/min).
%  connect the thermistor to A0 and leds to D2 (green), D3 (yellow), D4 (red).

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
bufferSize = 60; % 60 seconds = 1 minute

% data storage
temps = zeros(1, bufferSize);
i = 1;

disp('starting temperature monitoring and prediction...');

while 1
    % read and convert to °C
    voltage = readVoltage(a, thermistorPin);
    currentTemp = (voltage - V0C) / TC;

    % display current temperature
    disp(['current temperature: ', num2str(currentTemp), '°c']);

    % store reading in buffer
    temps(i) = currentTemp;

    % only calculate rate after 60 readings
    if i == bufferSize
        tempStart = temps(1);
        tempEnd = temps(end);
        rate = (tempEnd - tempStart) / (bufferSize - 1); % °C/s

        % predict future temp (300 seconds = 5 mins)
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
        else
            % stable
            writeDigitalPin(a, greenLED, 1);
            writeDigitalPin(a, yellowLED, 0);
            writeDigitalPin(a, redLED, 0);
        end

        % shift buffer to start again
        i = 1;
    else
        i = i + 1;
    end

    pause(1);
end
end
