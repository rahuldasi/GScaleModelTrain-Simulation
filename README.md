# Hydrogen-Powered G-Scale Model Train: Physical Simulation & Validation

This repository contains the simulation files, initialisation scripts, and experimental validation data for my MSc Project: **Validation of a Mathematical Model of a Hydrogen-Powered Scale Model Train.**

The primary objective of this project was to migrate a purely mathematical train simulation into a strict multi-domain physical architecture using **Simscape**. By replacing idealized power sources with a dynamic **Hydrogen PEM Fuel Cell** and an **Average-Value DC-DC Buck Converter**, this model natively enforces the conservation of energy between mechanical rigid-body kinematics and electrical domain. 

The simulation was statistically validated against real-world hardware data (a Horizon H-60 Fuel Cell and a G-scale locomotive) across four varying mass configurations.

## Repository Structure

### 1. Main Simulation Files
* `GScaleModelTrain_FuelCell.slx` - The final, fully validated hybrid physical-mathematical model. It contains the Fuel Cell, power regulation, DC motors, and rigid-body mass coupling.
* `GScaleModelMatlab.m` - The initialisation script. **Run this first.** It populates the MATLAB base workspace with all necessary geometric variables, gear ratios, Davis Resistance constants, and the calibrated Fuel Cell parameters (Tafel slope, internal resistance).
* `Track.m` - Script defining the track gradient profiles
* `DavisResistance.m` - Script calculating Davis Resistance. Edit the `Config` variable to change the mass configuration.

### 2. Validation & Data Processing
* `Fuel Cell and 14V Converter/` - Directory containing the raw and trimmed experimental CSV data logs gathered from the physical G-scale train runs.
* `plot_fcv_comparison.m` - The primary validation script. This script dynamically pulls the `FCV` (Fuel Cell Voltage) from the simulation workspace, applies a **0.5s Min-Binning** technique, and aligns it against the experimental data. It splits the data at $t = 2.5s$ to independently calculate Transient and Steady-State RMSE and MAE metrics.

### 3. Legacy Files (For Reference)
* `GScaleModelSimulinkOriginal.slx` - The original, inherited pure-mathematical baseline model.

## How to Run the Simulation

1. **Initialise the Workspace:** Open MATLAB and run `GScaleModelMatlab.m`. 
   *(Note: You can change the `Config` variable inside this script to switch between Locomotive Only, +1 Wagon, +2 Wagons, or +3 Wagons to alter the physical mass).*
2. **Open the Model:** Open `GScaleModelTrain_FuelCell.slx` in Simulink.
3. **Run the Simulation:** Press the Run button in Simulink. The model will simulate the train's 10-second run profile and export the continuous Fuel Cell Voltage array (`FCV`) to the base workspace.
4. **Validate:** Open `plot_fcv_comparison.m`. Update the `csv_filename` string at the top of the script to point to the matching configuration's CSV file. Run the script to generate the overlay plot and view the split statistical metrics (Transient vs Steady-State) in the command window.

## Key Findings

Through rigorous bifurcated statistical analysis (isolating the first 2.5 seconds of transient start-up from the steady-state cruising), this model proved exceptional steady-state accuracy. For the heaviest configuration, the steady-state Mean Absolute Error (MAE) was just **$0.1052V$ on a $14.4V$ operating level** (less than $1\%$ error). This validates that the Simscape rigid-body mass coupling translates physical Davis Resistance into strict electrical power draw.

*Note: Transient inaccuracies during the t=0 start-up sequence are documented in the report, stemming from unmodeled mechanical stiction in the locomotive gears and a lack of electrical double-layer capacitance in the first-order DC-DC converter.*
