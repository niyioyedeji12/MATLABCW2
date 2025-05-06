function temp_monitor(a)
    % This is a function for monitoring temperature and controlling LEDs.
    % This function reads the temperature from the thermistor and controls
    % LEDs based on the temperature value.
    % - Green LED ON for 18-24°C
    % - Yellow LED blinks at 0.5s below 18°C
    % - Red LED blinks at 0.25s above 24°C
    % It also displays the live temperature plot.

    % set up digital pins for LEDs
    greenLED = 'D2';
    yellowLED = 'D3';
    redLED = 'D4';

    % set LED pins as output
    configurePin(a, greenLED, 'DigitalOutput');
    configurePin(a, yellowLED, 'DigitalOutput');
    configurePin(a, redLED, 'DigitalOutput');
    
    % set analog pin for thermistor
    thermistorPin = 'A0';

    % thermistor constants
    V0C = 0.5;
    TC = 0.01;


    % initialize time for live graph plotting
    time = 0;

    % figure for live graphing
    figure;
    hold on;
    grid on;
    xlabel('Time (seconds)');
    ylabel('Temperature (°C)');
    xlim([0, 600]);  % x-axis limit
    ylim([0, 35]);   % y-axis limit for temperature range
    
    plot([0, 600], [18, 18], 'g--', 'LineWidth', 2);  % green dashed line at 18°C
    plot([0, 600], [24, 24], 'r--', 'LineWidth', 2);  % red dashed line at 24°C
    while true
        % read temperature from thermistor pin 
        voltage = readVoltage(a, thermistorPin); % read voltage
        temperature = (voltage - V0C) / TC;    % convert to degrees celsius
        
        % display temperature 
        disp(['Temperature: ', num2str(temperature), ' °C']);
        
        % Update live plot
        plot(time, temperature, 'bx');
        grid on;
        drawnow;

        % control LEDs based on temperature range
        if temperature >= 18 && temperature <= 24
            % green LED ON
            writeDigitalPin(a, greenLED, 1);  % green LED ON
            writeDigitalPin(a, yellowLED, 0); % yellow LED OFF
            writeDigitalPin(a, redLED, 0);    % red LED OFF
        elseif temperature < 18
            % yellow LED blinking (every 0.5s)
            writeDigitalPin(a, greenLED, 0);  % green LED OFF
            writeDigitalPin(a, redLED, 0);    % red LED OFF
            writeDigitalPin(a, yellowLED, 1); % yellow LED ON
            pause(0.25); % makes total blink time 0.5s
            writeDigitalPin(a, yellowLED, 0); % yellow LED OFF
            pause(0.25);
            writeDigitalPin(a, yellowLED, 1); % yellow LED ON
            pause(0.25); % makes total blink time 0.5s
            writeDigitalPin(a, yellowLED, 0); % yellow LED OFF
            pause(0.25);
        elseif temperature > 24
            % red LED blinking (every 0.25s)
            writeDigitalPin(a, greenLED, 0);  % green LED OFF
            writeDigitalPin(a, yellowLED, 0); % yellow LED OFF
            writeDigitalPin(a, redLED, 1);    % red LED ON
            pause(0.125); % makes total blink cycle 0.25s
            writeDigitalPin(a, redLED, 0);    % red LED OFF
            pause(0.125);
             writeDigitalPin(a, redLED, 1);    % red LED ON
            pause(0.125); % makes total blink cycle 0.25s
            writeDigitalPin(a, redLED, 0);    % red LED OFF
            pause(0.125);
             writeDigitalPin(a, redLED, 1);    % red LED ON
            pause(0.125); % makes total blink cycle 0.25s
            writeDigitalPin(a, redLED, 0);    % red LED OFF
            pause(0.125);
             writeDigitalPin(a, redLED, 1);    % red LED ON
            pause(0.125); % makes total blink cycle 0.25s
            writeDigitalPin(a, redLED, 0);    % red LED OFF
            pause(0.125);
        end
        
        % increment time for plotting
        time = time + 1;
        
        % pause 1 second before reading the next value and updating the plot
        pause(1);
    end
end