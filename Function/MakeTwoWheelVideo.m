%構造体を作っておいて後で動画化するパターン
function MakeTwoWheelVideo(dt, hXYrefPoint, hXYLog, TwoWheel, xref, yref,  x, y, theta, velocity, angvelocity)
    clear frame_vec;
    frame_vec(length(x)) = struct('cdata', [], 'colormap',[]);

    for i = 1:length(x)

    %% X:
        
        X = x(i);
        Y = y(i);
        Theta = theta(i);
        Velocity = velocity(i);
        AngVelocity = angvelocity(i);
        hXYrefPoint.XData = xref(i);
        hXYrefPoint.YData = yref(i);
        hXYLog.XData = x(1:i);
        hXYLog.YData = y(1:i);

        TwoWheel.X = X;
        TwoWheel.Y = Y;
        TwoWheel.Theta = Theta;
        TwoWheel.Velocity = Velocity;
        TwoWheel.AngVelocity = AngVelocity;

        TwoWheel.redraw();

        %drawnow;
        frame_vec(i) = getframe(TwoWheel.hfig);
    end

    vidObj = VideoWriter('result.mp4','MPEG-4');
    vidObj.FrameRate = 1/dt;
    open(vidObj);
    writeVideo(vidObj, frame_vec);
    close(vidObj);
end