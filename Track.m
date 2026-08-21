classdef Track < matlab.System

% This object will generate the track topologies for use in the models.
% This includes the curved sections of track and gradients.

    % properties (Access = private)
    % 
    %     Curvature
    %     theta
    % 
    % end

    methods (Access = protected)

        function [Curvature,theta] = stepImpl(~,x,y,CurveEntry1,CurveExit1,CurveEntry2,CurveExit2)

%% Curvature

% This section of the code generates the changes in the track curvature
% relative to the earth-fixed frame position of the curves. 

% Main Loop 

CurveFlag = 0;

% Standard R1 Curve 

if CurveFlag == 1

            if (x < 5.4) && (y == 0)

                Curvature = 0;

            elseif (5.4 <= x) && (y < 0.6)

                Curvature = 1/0.6;

            elseif (y >= 0.6)

                Curvature = 0;

            % elseif (4.24 < y) && (y <= 4.84)
            % 
            %     Curvature = CurveEntry2;
            % 
            % elseif  (y > 4.84)
            % 
            %     Curvature = CurveExit2;

            else

                Curvature = 0;

            end

            % if x >= 5
            % 
            %     Curvature = CurveEntry1;
            % 
            % else 
            % 
            %     Curvature = 0;
            % 
            % end

else

    Curvature = 0;

end

% if CurveFlag == 1
% 
%             if (x <= 25) && (y == 0)
% 
%                 Curvature = 0;
% 
%             elseif (25 < x) && (y <= 0.92154)
% 
%                 Curvature = CurveEntry1;
% 
%             elseif (y > 0.92154) && (y <= 4.24)
% 
%                 Curvature = CurveExit1;
% 
%             elseif (4.24 < y) && (y <= 4.84)
% 
%                 Curvature = CurveEntry2;
% 
%             elseif  (y > 4.84)
% 
%                 Curvature = CurveExit2;
% 
%             else
% 
%                 Curvature = 0;
% 
%             end
% 
% else
% 
%     Curvature = 0;
% 
% end

%% Gradients

% This section of the code varies the angle that the track makes with the
% horizontal. 

% Gradient Flag to turn gradients on and off

GradientFlag = 1;

% Main Loop

% Validation Incline

           % if GradientFlag == 1
           % 
           %  if x < 2.4
           % 
           %      theta = 0;
           % 
           %  elseif (2.4 <= x) && (x < 3)
           % 
           %      theta = asind(1/60);
           % 
           %      % m = 10/3;
           %      % 
           %      % theta = m*x - 8;
           % 
           %      % theta = 0;
           % 
           %  elseif (3 <= x) && (x < 4.8)
           % 
           %      theta = asind(1/60);
           % 
           %      % theta = 2;
           % 
           %  else
           % 
           %      theta = 0;
           % 
           %  end
           % 
           % else 
           % 
           %      theta = 0;
           % 
           % end

% Intelligent Vehicle Paper

           % if GradientFlag == 1
           % 
           %     if x < 5
           % 
           %         theta = 0;
           % 
           %     elseif (5 <= x) && (x < 10)
           % 
           %         theta = asind(1/60);
           % 
           %     elseif (10 <= x) && (x < 15)
           % 
           %         theta = 0;
           % 
           %     elseif (15 <= x) && (x < 20)
           % 
           %         theta = -(asind(1/60));
           % 
           %     elseif (20 <= x) 
           % 
           %         theta = 0;
           % 
           %     else
           % 
           %         theta = 0;
           % 
           %     end
           % 
           % else
           % 
           %     theta = 0;
           % 
           % end

% Standard Incline

           if GradientFlag == 1

               if (10 <= x) && (x < 15)

                   theta = asind(1/60);

               % elseif (5 <= x) && (x < 8)
               % 
               %     theta = -asind(1/50);

               else

                   theta = 0;

               end

           else

               theta = 0;

           end

       end

    end

end
