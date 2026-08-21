% plot_fcv_comparison.m
% Script to compare averaged experimental fuel cell voltage data 
% with the simulated output (FCV) from the workspace.

% 1. Load the Averaged CSV data
% You can change the filename below to compare against different configurations
csv_filename = 'Fuel Cell and 14V Converter\Straight\Fuel Cell Voltage\trimmed_LocomotiveOnly.csv';

try
    actual_data = readtable(csv_filename);
    t_actual = (actual_data.Index - 1) * 0.5; % 0.5s intervals based on Index
    actual_voltage = actual_data.Measurement;
catch ME
    error(['Could not load ' csv_filename '. Please ensure you are in the GScaleModel directory.']);
end

% 2. Retrieve simulated data from workspace
try
    % FCV is stored inside the Simulink.SimulationOutput object 'out'
    sim_out = evalin('base', 'out');
    fcv_var = sim_out.get('FCV');
    
    if isa(fcv_var, 'timeseries')
        t_sim_raw = fcv_var.Time;
        v_sim_raw = fcv_var.Data;
    elseif isa(fcv_var, 'struct') && isfield(fcv_var, 'time') && isfield(fcv_var, 'signals')
        t_sim_raw = fcv_var.time;
        v_sim_raw = fcv_var.signals.values;
    else
        if size(fcv_var, 2) > 1
            t_sim_raw = fcv_var(:, 1);
            v_sim_raw = fcv_var(:, 2);
        else
            error('FCV format not recognized. Please use Timeseries or Array with time format.');
        end
    end
catch
    error('Could not find FCV in the base workspace. Please ensure the simulation has run and FCV is saved in the "out" variable.');
end

% 3. Extract the Minimum Voltage over 0.5s intervals
% To perfectly capture the initial dip without missing it between samples,
% we divide the continuous simulation time into 0.5s bins and find the min() in each bin.
bin_size = 0.5;
max_t = max(t_sim_raw);
t_sim = (0:bin_size:max_t)';
v_sim = zeros(length(t_sim), 1);

for i = 1:length(t_sim)
    if i == 1
        % Preserve exactly 1 sample of OCV at the beginning
        v_sim(1) = v_sim_raw(1);
    else
        % For subsequent points, take the absolute minimum voltage 
        % in the preceding 0.5s window to capture the dip
        start_time = t_sim(i-1);
        end_time = t_sim(i);
        idx = (t_sim_raw >= start_time) & (t_sim_raw < end_time);
        
        if any(idx)
            v_sim(i) = min(v_sim_raw(idx));
        else
            % If window is empty, carry over previous value
            v_sim(i) = v_sim(i-1);
        end
    end
end

% 4. Plot the results
figure('Name', 'Fuel Cell Voltage Comparison', 'Position', [100, 100, 800, 500]);

% Plot Averaged Experimental Data
plot(t_actual, actual_voltage, 'o-', 'LineWidth', 2, 'MarkerSize', 4, 'Color', '#D95319', 'DisplayName', 'Averaged Experimental Data');
hold on;

% Plot Simulated Data (Minimum-binned)
plot(t_sim, v_sim, '-', 'LineWidth', 2, 'Color', '#0072BD', 'DisplayName', 'Simulated Data (0.5s Min-Binned)');

hold off;

% Formatting
title(['Fuel Cell Voltage: Averaged Experimental vs Simulated - Config: 1']);
xlabel('Time (s)');
ylabel('Voltage (V)');
grid on;
legend('Location', 'best');

% Set x-axis limit based on whichever is longer
xlim([0 max(max(t_actual), max(t_sim))]);

% 5. Data Alignment & Split Statistical Metrics
% Interpolate the simulated data exactly at the experimental time steps
v_sim_aligned = interp1(t_sim, v_sim, t_actual, 'linear', 'extrap');

% Split Threshold
T_SPLIT = 2.5;
idx_transient = (t_actual <= T_SPLIT);
idx_steady = (t_actual > T_SPLIT);

% Global Error
err_global = v_sim_aligned - actual_voltage;
rmse_global = sqrt(mean(err_global.^2));
mae_global = mean(abs(err_global));

% Transient Error
err_trans = v_sim_aligned(idx_transient) - actual_voltage(idx_transient);
rmse_trans = sqrt(mean(err_trans.^2));
mae_trans = mean(abs(err_trans));

% Steady-State Error
err_steady = v_sim_aligned(idx_steady) - actual_voltage(idx_steady);
rmse_steady = sqrt(mean(err_steady.^2));
mae_steady = mean(abs(err_steady));

% 6. Display Results
disp('----------------------------------------------------');
disp(['Configuration File: ' csv_filename]);
disp('----------------------------------------------------');
fprintf('GLOBAL RMSE: %.4f V | MAE: %.4f V\n', rmse_global, mae_global);
disp('----------------------------------------------------');
fprintf('TRANSIENT (t <= %.1fs) RMSE: %.4f V | MAE: %.4f V\n', T_SPLIT, rmse_trans, mae_trans);
disp('----------------------------------------------------');
fprintf('STEADY-STATE (t > %.1fs) RMSE: %.4f V | MAE: %.4f V\n', T_SPLIT, rmse_steady, mae_steady);
disp('----------------------------------------------------');
