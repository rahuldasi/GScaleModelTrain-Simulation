%% Introduction

% This script details all of the parameters required for the simulation of
% the scale model train mathematical models in Simulink. The file
% containing the Simulink models will be provided.

clc

%% DC Motor Parameters 

Rm = 2.1; % Motor Resistance
L = 0.001; % Motor Inductance
Ke = 0.01275; % Voltage Constant
Kt = 0.01275; % Torque Constant
num_motors = 2;
num_wheels = 8;
eff = 0.85; % Drivetrain Efficiency
r = 0.017; % Wheel Radius
G = 30; % Gear Ratio

Vtrack = 20; % Track Voltage (Max 25V)

%% Train Parameters

% Positions for Distributed Model (0 taken as reference for locomotive)

x01 = 0; % Locomotive
x02 = -0.5225; % Wagon 1
x03 = -1.1225; % Wagon 2
x04 = -1.7225; % Wagon 3
%% Train Mass Configuration
Config = 1;
mass_loco = 10.5;
mass_wag = 8.0;
N = Config - 1;
train_mass = mass_loco + (N * mass_wag);

if Config == 1
    shutdown_time = 8.0;
elseif Config == 2
    shutdown_time = 7.5;
elseif Config == 3
    shutdown_time = 7.0;
elseif Config == 4
    shutdown_time = 7.5;
else
    shutdown_time = 8.0;
end
