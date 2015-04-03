function [ B ] = B_field_angle_size(varargin)
% Calculates magnetic field of multiple long, straight current carrying
% wires (or poles). Returns a vector of the sums. Eventually this function
% should replace the other two (B_field_pole and B_field_multiple_poles)
	current_density = varargin{1};
	distance = varargin{2};
	diameter = varargin{3};
	number_of_poles = varargin{4};
    angle = varargin{5};
	width = diameter * number_of_poles;
    u = 4*pi*(10^-7);               % magnetic permability constant in T*m/A
    B = [];              
    
	if (angle > 179) || (angle < 1)
        disp('Error: angle out of range')
    end
    
    if number_of_poles == 1        % angle doesn't matter for 1 pole
            B = (u.*current_density)./(2.*pi.*abs(distance));
    end
    
    if angle == 90
        
        for i = 1:floor(number_of_poles/2)
            hypotenuse = sqrt( (diameter*i).^2 + distance.^2);
            B = 2.*(u.*current_density)./(2.*pi.*abs(hypotenuse));
        end
 
    elseif angle ~= 90
        % Using the Law Of Cosines, see notebook p. 116
        % hypotenuse1 = angle, hypotenuse2 = 180-angle
        % The odd case must also account for the middle pole for which
        % angle is irrelevant.
        if mod(number_of_poles, 2) == 0                 % even case
            for i = 1:(number_of_poles/2)
                hypotenuse1 = sqrt( distance.^2 + (diameter*i).^2 - 2.*distance.*(diameter*i).*cosd(angle) );
                hypotenuse2 = sqrt( distance.^2 + (diameter*i).^2 - 2.*distance.*(diameter*i).*cosd(180-angle) );
                B = ((u.*current_density)./(2.*pi.*abs(hypotenuse1))) + ((u.*current_density)./(2.*pi.*abs(hypotenuse2)));
            end
        else                                            % odd case
            for i = 1:floor(number_of_poles/2)
                hypotenuse1 = sqrt( distance.^2 + (diameter*i).^2 - 2.*distance.*(diameter*i).*cosd(angle) );
                hypotenuse2 = sqrt( distance.^2 + (diameter*i).^2 - 2.*distance.*(diameter*i).*cosd(180-angle) );
                B = ((u.*current_density)./(2.*pi.*abs(hypotenuse1))) + ((u.*current_density)./(2.*pi.*abs(hypotenuse2))) ...
                    + ((u.*current_density)./(2.*pi.*abs(distance)));
            end
        end
            

    end
	
end

