function [ B ] = B_field_multiple_poles(current_density, distance, ...
    diameter, number_of_poles)
% Calculates magnetic field of multiple long, straight current carrying
% wires (or poles). Returns units in Teslas.
    u = 4*pi*(10^-7);               % magnetic permability constant in T*m/A
    B = [];                 
    
    if mod(number_of_poles, 2) == 0
        for i = 1:floor(number_of_poles/2)      % EVEN CASE
            %sprintf('Loop is running %d', i)
            hypotenuse = sqrt( (diameter*i).^2 + distance.^2);
            B = 2.*(u.*current_density)./(2.*pi.*abs(hypotenuse));
        end
    else
        for i = 1:floor(number_of_poles/2)      % ODD CASE
            %sprintf('Loop is running %d', i)
            hypotenuse = sqrt( (diameter*i).^2 + distance.^2);
            B = (2.*(u.*current_density)./(2.*pi.*abs(hypotenuse))) ...
                + ((u.*current_density)./(2.*pi.*abs(distance)));
        end
    end 
end

