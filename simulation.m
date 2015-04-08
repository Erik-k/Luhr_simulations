% Attempting to simulate magnetic fields around current sheets
% Erik Knechtel Feb 2013

% Going from eq. 2 in Luhr, and since only Bx exists, we get:
% Jz = (1/u)*(dBx/dy) which is the change in Bx/dt as we travel along y
% (through the sheet. v = vy). Convert dB/dt to dB/ds using velocity of
% spacecraft.

% Remaining issues:
% 1) Increase measurementFrequency makes the x axis labels get too large.

clc
clear all
close all; %remove figure windows

% CONSTANTS
u = 4*pi*(10^-7);                        % magnetic permability constant N/A^2 or T*m/A
current = 100*(10^-6);                  % current in amps

% VARIABLES
starting_distance = 40000;              % in meters
speed = 10000;                          % in meters/sec
measurementFrequency = 100;              % in Hz, 1/s

num_measurements = (starting_distance/speed).*measurementFrequency;  % unit-less
measurement_locations = speed/measurementFrequency;      % spacing of the measurements in m

%% SCENARIOS
% Scenario 1: A spacecraft approaching a single current pole and passing through.
% Perpendicular approach assumed.

diameter = 1000;            % diameter of each pole in meters

disp('First Scenario: A single thin pole')
disp('Approaching')
distances_approaching = linspace(starting_distance, 1, num_measurements+1);
B_approaching = zeros(1, length(distances_approaching));
for i = 1:length(distances_approaching)
    B_approaching(i) = B_field_pole(current, distances_approaching(i), diameter);
end
dBdt_approaching = diff(B_approaching);

disp('Leaving')
distances_leaving = linspace(1, starting_distance, num_measurements+1); % after passing through
B_leaving = zeros(1, length(distances_leaving));
for i = 1:length(distances_leaving)
    B_leaving(i) = B_field_pole(current, distances_leaving(i), diameter);
end
dBdt_leaving = diff(B_leaving);

measurements = cat(2, dBdt_approaching, dBdt_leaving);
% ignore any that couldn't be detected by our magnetometer's resolution:
% stripped_measurements = measurements( abs(measurements) >= 1e-10);  
B_measurements = cat(2, B_approaching, B_leaving);
subplot(3,2,2)
plot( measurements )
hold on
title(sprintf('Approaching and passing through a single current pole.\nCurrent density is %0.6f A/m^2 \nMeasurement frequency is %0.0fHz', ...
    current, measurementFrequency));
xlabel('Distance from start in 100''s m');
%myxaxis = cat(2, -40:5:-1, 0:5:40);      
%set(gca, 'XTick', myxaxis )
ylabel('dB/dt in teslas/second');

subplot(3,2,1)
plot( B_measurements )
title('B-field measurements for crossing a single pole');
xlabel('Distance from start in 100''s m');
ylabel('B-field in Teslas');
hold off

% Resulting current density estimation:
Jz = (-1/u).*max(measurements)              % pretty sure this is wrong. How to account for a whole vector of dB/dt?
estimation_error = abs(Jz - current)

%%
% Scenario 2: Multiple current poles comprising total width w and depth d
% where depth = diameter, width = diameter*number, and s = spaceship point
% of entry. Perpendicular approach assumed.
disp('Second Scenario: Multiple Poles')
number_of_poles = 55;
diameter = 1000;            % diameter of each pole in meters
disp('Approaching')
B_multi_approaching = zeros(1, length(distances_approaching));
for i = 1:length(distances_approaching)
    B_multi_approaching(i) = B_field_multiple_poles(current, distances_approaching(i), diameter, number_of_poles);
end
dBdt_approaching_multi = diff(B_multi_approaching);

disp('Leaving')
B_multi_leaving = zeros(1, length(distances_leaving));
for i = 1:length(distances_leaving)
    B_multi_leaving(i) = B_field_multiple_poles(current, distances_leaving(i), diameter, number_of_poles);
end
dBdt_leaving_multi = diff(B_multi_leaving);

measurements_multi = cat(2, dBdt_approaching_multi, dBdt_leaving_multi);
B_measurements_multi = cat(2, B_multi_approaching, B_multi_leaving);
subplot(3,2,4)
plot( measurements_multi )
hold on
title(sprintf('Approaching %d adjacent current poles perpendicularly', number_of_poles))
ylabel('dB/dt in teslas/second');

subplot(3,2,3)
plot( B_measurements_multi )
title('B-field measurements for the multiple-pole scenario');
hold off

%%
% Scenario 3: Multiple current poles as in Scenario 2, but now angle of
% approach is anything from 1 to 179 degrees.

disp('Third Scenario: Angled Approach')
angle = 179;
number_of_poles = 8;
diameter = 1000;

disp('Approaching')
B_angled_approaching = zeros(1, length(distances_approaching));
for i = 1:length(distances_approaching)
    B_angled_approaching(i) = B_field_angle_size(current, distances_approaching(i), diameter, number_of_poles, angle);
end
dBdt_approaching_angled = diff(B_angled_approaching);

disp('Leaving')
B_angled_leaving = zeros(1, length(distances_leaving));
for i = 1:length(distances_leaving)
    B_angled_leaving(i) = B_field_angle_size(current, distances_leaving(i), diameter, number_of_poles, angle);
end
dBdt_leaving_angled = diff(B_angled_leaving);

measurements_angled = cat(2, dBdt_approaching_angled, dBdt_leaving_angled);
B_measurements_angled = cat(2, B_angled_approaching, B_angled_leaving);
subplot(3,2,6)
plot( measurements_angled )
hold on
title(sprintf('Approaching and passing through a sheet of %d poles at an angle of %0.0f degrees\n', ...
    number_of_poles, angle));
ylabel('dB/dt in teslas/second');

subplot(3,2,5)
plot( B_measurements_angled )
title('B-field measurements for the angled scenario');
hold off


%% Testing. Sanity checks! x_x

% Try to get the parts of a vector to sum correctly. How much needs to be
% done in main, and how much done inside the function? 
% Answer: Loop through each distance increment in main, and pass it as a
% scalar, but loop through each pole inside the function and sum their
% effects before passing the result back out AS A SCALAR. Then append these
% scalars into the B result vector one by one using for loop indexing.

%myvec = [1 2 3 4 5];
%poles = 3;
%results = zeros(1, length(myvec));
%for i = 1:length(myvec)
%    results(i) = test_func(poles, myvec(i))
%end


%% Future steps:
% 1) Moving current sheets: this can be simulated by adding some velocity
% along with or against the spacecraft's v.
% 2) Letting the user click and drag a slider to see the effects of
% changing parameters "live" in the graphs.



















