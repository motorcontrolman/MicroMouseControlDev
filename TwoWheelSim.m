clear all;
close all;
addpath(genpath('./'));
logDir = string(pwd) + "\LogFile\";
movieDir = string(pwd) + "\Movie\";


%% Simulink基本設定
Simulation_Step = 0.1;
GoalTime = 20;
EndTime = GoalTime * 1.2;

%% マイクロマウス用パラメータの設定
%タイヤ用パラメータ
W = 20e-3;
R = 5e-3;
Rl = R;
Rr = R;

%ボディ用パラメータ
BODY_LENGTH_HALF = 30e-3;
BODY_WIDTH_HALF = 30e-3;

%% figureに軌跡を表示
fig = figure(1);
hold on;
axis equal;
grid on;
Max = 0.4;
Min = -0.4;
axis([Min Max Min Max]);

%% コースの描画
%x = [0 1 2 3 3 2 1 0 0] / 3 * 0.6 - 0.3;
%y = [0 1 0 0 3 3 3 3 0] / 3 * 0.6 - 0.3;

%simpleMouseDraw;
load XY
x = curLineX.';
y = curLineY.';
x = x * (Max - Min) * 0.8 / ( max(x) - min(x) );
y = y * (Max - Min) * 0.8 / ( max(x) - min(x) );

x = x + ( Min - min(x))*0.8;
y = y + ( Min - min(y))*0.8;

numPoints = length(x);

tt = [0 : Simulation_Step : GoalTime];
tp = [0:(numPoints - 1)] / (numPoints - 1) * GoalTime;

x = x.';
y = y.';
tp = tp.';
tt = tt.';
xx = interp1(tp, x, tt, 'spline');
yy = interp1(tp, y, tt, 'spline');
hXYref = plot(xx,yy);
hXYrefPoint = plot(xx(1),yy(1),'.k','MarkerSize',20);


% ２輪モデルクラスを定義
x0 = xx(1);
y0 = yy(1);
theta0 = 0;
v0 = 0;
w0 = 0;

%% グラフィック用のオブジェクトを作成

TwoWheel = classTwoWheelGlaphic(R, W, BODY_LENGTH_HALF, BODY_WIDTH_HALF, fig);
TwoWheel.X = x0;
TwoWheel.Y = y0;
TwoWheel.Theta = theta0;
TwoWheel.Velocity = v0;
TwoWheel.AngVelocity = w0;
TwoWheel.redraw();

strSim = "microMouseSimulator";
sim(strSim);

logTable = array2table(LOG, 'VariableNames', ...
                        {'time','xref','yref','x','y', ...
                        'theta','velocity','angvelocity'});
save(logDir + "logTable.mat","logTable");

%save()
%% 動画を作成
hXYLog = plot(logTable.x(1), logTable.y(1),'Color',[1 0 1]);
MakeTwoWheelVideo(Simulation_Step, hXYrefPoint, hXYLog, TwoWheel, ...
                        logTable.xref, logTable.yref, ...
                        logTable.x, logTable.y, logTable.theta, ...
                        logTable.velocity, logTable.angvelocity);
 movefile("result.mp4", movieDir);