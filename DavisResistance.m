classdef DavisResistance < matlab.System 

    % Pre-computed constants or internal states
    properties (Nontunable)
        
    end

    properties (Access = private)

        R_D
        train_mass
        config
        
    end

    methods (Access = protected)

        function [R_D,train_mass,Config] = stepImpl(~,V)

                %% Select configuration
                % 1 = loco only
                % 2 = loco + 1 wagon
                % 3 = loco + 2 wagons
                % 4 = loco + 3 wagons
                
                Config = 1;
                  
                
                %% Base masses
                mass_loco = 10.5;   % kg
                mass_wag  = 8.0;    % kg per wagon
                
                %% Base Davis coefficients

                % Locomotive
                A_loco = 1.4;     % N
                B_loco = 0.02;    % N·s/m
                C_loco = 0.002;   % N·s^2/m^2
                
                % Wagon
                A_wag  = 1.1;     % N
                B_wag  = 0.025;   % N·s/m
                                
                %% Determine number of wagons
                
                if Config == 1
                    N = 0;
                elseif Config == 2
                    N = 1;
                elseif Config == 3
                    N = 2;
                elseif Config == 4
                    N = 3;
                else
                    N = 0;
                end
                
                %% Compute Davis coefficients
                A = A_loco + N * A_wag;
                B = B_loco + N * B_wag;
                C = C_loco;
                
                %% Compute total train mass
                train_mass = mass_loco + (N * mass_wag);   % kg

                R_D = A + (B)*V + (C)*V^2;

           end
      end
end
