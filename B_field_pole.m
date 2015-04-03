function [B] = B_field_pole(current_total, distance, diameter)
% Calculates magnetic field of a long, straight current carrying wire
% given total current, which is assumed to be evenly distributed inside the 
% pole, and distance from center. Units of Teslas.
    B = [];
    u = 4*pi*(10^-7);                %magnetic permability constant in T*m/A
    
    if (distance > diameter)
        B = (u.*current_total)./(2.*pi.*abs(distance));
    else
        B = (u.*current_total.*distance)./(2.*pi.*(diameter^2));
    end
end

