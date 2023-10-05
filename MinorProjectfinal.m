%EECS 1011 minor project
%Code by Farhan Qadri
clear all; close all
a = arduino('COM3', 'Uno');

%Values
dry = 3.2; 
wet = 2.7;

%Graph
figure
h = animatedline;
ax = gca;
ax.YGrid = 'on';
ax.YLim = [-0.5 1.5];
title('Moisture sensor voltage vs time (live)');
ylabel('Time [HH:MM:SS]');
xlabel('Voltage(Moisture Sensor) [volt]');
stop = 0;
startTime = datetime('now');

%while loop to keep running until told to stop
while ~stop
    %reading value and adding to the live updating graph
    Mvoltage = readVoltage(a, 'A1');
    sconversion = sensor_conversion(Mvoltage);
    t = datetime('now')-startTime;
    addpoints(h, datenum(t), sconversion);
    ax.XLim = datenum([t-seconds(15) t]);
    datetick('x', 'keeplimits');
    drawnow
    %if statement to decide whether to water or not
    if (sconversion >= 1)
        disp("Watering due to soil dryness.");
        writeDigitalPin(a, 'D2', 1);
    elseif (sconversion < 1 && sconversion > 0)
        disp("Still a little dry, continuing to water...");
        writeDigitalPin(a, 'D2', 1);
    elseif (sconversion <= 0)
        disp("Fully watered.");
        writeDigitalPin(a, 'D2', 0);
    else
        disp("Error")
        writeDigitalPin(a, 'D2', 0);
        stop = 1;
    end
    stop = readDigitalPin(a, 'D6')
end
    




