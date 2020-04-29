clear all;
close all;

%% マイクロマウス用パラメータの設定
%タイヤ用パラメータ
W = 20e-3;
R = 10e-3;

%ボディ用パラメータ
BODY_LENGTH_HALF = 30e-3;
BODY_WIDTH_HALF = 30e-3;

%% シミュレーションおよび動画作成用パラメータ
% ode45ソルバの設定
opts = odeset('RelTol',1e-6,'AbsTol',1e-8);
% 動画の設定
frameRate = 20; % [frame/sec]
endTime = 10;

Ts = 1 / frameRate;
t1 = [0:Ts:endTime];

%% ２輪モデルを作成
TwoWheel = classTwoWheelGlaphic(R, W, BODY_LENGTH_HALF, BODY_WIDTH_HALF);

%% 入力uを規定
u1 = 0.1 + 0.02 * t1;
u2 = 2 * sin(t1 * 2 * pi /endTime);

%% ode45で非線形状態方程式を求解
[t,xi]= ode45(@(t,xi) TwoWheelEquation(t,xi,t1,u1,u2),[0 10],[0;0;0],opts);

%% 動画作成用に内挿
xi_out=zeros(length(t1),3);
xi_out(:,1) = interp1(t,xi(:,1),t1);
xi_out(:,2) = interp1(t,xi(:,2),t1);
xi_out(:,3) = interp1(t,xi(:,3),t1);
x = xi_out(:,1);
y = xi_out(:,2);
theta = xi_out(:,3);

%% figureを調整
Max = max( [max(x) max(y)] ) + 0.2;
Min = min( [min(x) min(y)] ) - 0.2;
axis([Min Max Min Max]);

%% フィードフォワードで動かすため、指令値はとりあえずゼロ設定
xref = zeros(size(x));
yref = zeros(size(y));
hXYrefPoint = plot(0,0);
hXYLog = plot(x(1), y(1),'Color',[1 0 1]);

% 可視化および動画化を関数内にて実施
MakeTwoWheelVideo(Ts, hXYrefPoint, hXYLog, TwoWheel, ...
                        xref, yref, ...
                        x, y, theta, ...
                        u1, u2);