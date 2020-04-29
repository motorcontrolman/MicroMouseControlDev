classdef classTwoWheelGlaphic
    %% Public Parameters
    properties
        % Attitude
        X = 0;
        Y = 0;
        Theta = 0;    
        Velocity = 0;
        AngVelocity = 0;
        hfig;
    end
    
    %% Private Parameters
    properties  (Access = private) 
        % Attitude(Private)
        ThetaDeg = 0;
        
        % MicroMouse Parameters
        tireRadius;         % タイヤ半径
        shaftLengthHalf;    % シャフト1/2
        bodyLengthHalf;     % ボディ長さ1/2
        bodyWidthHalf;      % ボディ幅1/2
        
        % Graphics Parameters
        VectorExpansion = 1;
        AngVelocityMax = 2;
        AngVelocityRadius = 0.04;
        tireLineWidth = 2;
        
        % Handle for Graphics
        hLeftTire;
        hRightTire;
        hBody;
        hVec;
        hCircle;
        
        % Array for Drawing Graphics
        leftTireInitX;
        leftTireInitY;
        rightTireInitX;
        rightTireInitY;
        BodyInitX;
        BodyInitY;
        CircleX;
        CircleY;
    end

    methods
        %% Set micromouse parameters when the object is Created,
        function obj = classTwoWheelGlaphic(tireRadius, shaftLengthHalf, bodyLengthHalf, bodyWidthHalf, hfig)
            if nargin < 5
                obj.hfig = figure();
                hold on;
                axis equal;
                grid on;
            else
                obj.hfig = hfig;
            end
            
            obj.tireRadius = tireRadius;
            obj.shaftLengthHalf = shaftLengthHalf;
            obj.bodyLengthHalf = bodyLengthHalf;
            obj.bodyWidthHalf = bodyWidthHalf;
            
            obj.leftTireInitX = tireRadius * [-1, 1];
            obj.leftTireInitY = shaftLengthHalf * [1, 1];
            obj.rightTireInitX = tireRadius * [-1, 1];
            obj.rightTireInitY = shaftLengthHalf * [-1, -1];
            obj.BodyInitX = obj.bodyLengthHalf * [1 -1 -1 1 2 1];
            obj.BodyInitY = obj.bodyWidthHalf * [-1 -1 1 1 0 -1];
            
            obj.hLeftTire = plot(obj.leftTireInitX, obj.leftTireInitY, 'k', 'LineWidth', obj.tireLineWidth);
            obj.hRightTire = plot(obj.rightTireInitX, obj.rightTireInitY, 'k', 'LineWidth', obj.tireLineWidth);
            obj.hBody = plot(obj.BodyInitX, obj.BodyInitY, 'k');    
            obj.hVec = quiver(0, 0, 0, 0,'g','LineWidth', 2 ,'MaxHeadSize',0.8);
            
            th = linspace(0,2*pi,50);
            obj.CircleX = obj.AngVelocityRadius * cos(th);
            obj.CircleY = obj.AngVelocityRadius * sin(th);
            obj.hCircle = plot(obj.CircleX, obj.CircleY, 'b', 'LineWidth', 2);
            
        end
        
        %% Redraw Graphics
        function  redraw(obj)
            % ２輪台車の位置をX,Yへと移動
            obj.hLeftTire.XData = obj.X + obj.leftTireInitX;
            obj.hLeftTire.YData = obj.Y + obj.leftTireInitY;
            obj.hRightTire.XData = obj.X + obj.rightTireInitX;
            obj.hRightTire.YData = obj.Y + obj.rightTireInitY;
            obj.hBody.XData = obj.X + obj.BodyInitX;
            obj.hBody.YData = obj.Y + obj.BodyInitY;


            % Z軸を中心として角度theta回転
            obj.ThetaDeg = obj.Theta * 180 / pi;
            Z_AXIS = [0 0 1];
            rotateOrigin = [obj.X, obj.Y, 0];
            rotate(obj.hLeftTire, Z_AXIS, obj.ThetaDeg, rotateOrigin);
            rotate(obj.hRightTire, Z_AXIS, obj.ThetaDeg, rotateOrigin);
            rotate(obj.hBody, Z_AXIS, obj.ThetaDeg, rotateOrigin);

            % 速度ベクトルVecのプロット
            obj.hVec.XData = obj.X;
            obj.hVec.YData = obj.Y;
            obj.hVec.UData = obj.Velocity * obj.VectorExpansion * cosd(obj.ThetaDeg);
            obj.hVec.VData = obj.Velocity * obj.VectorExpansion * sind(obj.ThetaDeg);
            
            % 角速度AngVelocityを円でプロット
            redrawCircle(obj)
            drawnow;
        end
    end
    
    methods (Access = private) 
        function  redrawCircle(obj)
            Len = length(obj.CircleX);
            if obj.AngVelocity > 0
                color = [0 0 1];
                cMin = 1;
                cMax =  round( ( obj.AngVelocity / obj.AngVelocityMax ) * Len );
                if cMax > Len
                    cMax = Len;
                end
            else
                color = [1 0 0];
                cMax = 50;
                cMin =  round( ( 1 + ( obj.AngVelocity / obj.AngVelocityMax )) * Len );
                if cMin < 1
                    cMin = 1;
                end

                
            end
            obj.hCircle.XData = obj.CircleX(cMin:cMax) + obj.X;
            obj.hCircle.YData = obj.CircleY(cMin:cMax) + obj.Y;
            obj.hCircle.Color = color;
        end
    end
end

