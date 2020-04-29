clear all;
close all;

%% �}�C�N���}�E�X�p�p�����[�^�̐ݒ�
%�^�C���p�p�����[�^
W = 20e-3;
R = 10e-3;

%�{�f�B�p�p�����[�^
BODY_LENGTH_HALF = 30e-3;
BODY_WIDTH_HALF = 30e-3;

%% �V�~�����[�V��������ѓ���쐬�p�p�����[�^
% ode45�\���o�̐ݒ�
opts = odeset('RelTol',1e-6,'AbsTol',1e-8);
% ����̐ݒ�
frameRate = 20; % [frame/sec]
endTime = 10;

Ts = 1 / frameRate;
t1 = [0:Ts:endTime];

%% �Q�փ��f�����쐬
TwoWheel = classTwoWheelGlaphic(R, W, BODY_LENGTH_HALF, BODY_WIDTH_HALF);

%% ����u���K��
u1 = 0.1 + 0.02 * t1;
u2 = 2 * sin(t1 * 2 * pi /endTime);

%% ode45�Ŕ���`��ԕ�����������
[t,xi]= ode45(@(t,xi) TwoWheelEquation(t,xi,t1,u1,u2),[0 10],[0;0;0],opts);

%% ����쐬�p�ɓ��}
xi_out=zeros(length(t1),3);
xi_out(:,1) = interp1(t,xi(:,1),t1);
xi_out(:,2) = interp1(t,xi(:,2),t1);
xi_out(:,3) = interp1(t,xi(:,3),t1);
x = xi_out(:,1);
y = xi_out(:,2);
theta = xi_out(:,3);

%% figure�𒲐�
Max = max( [max(x) max(y)] ) + 0.2;
Min = min( [min(x) min(y)] ) - 0.2;
axis([Min Max Min Max]);

%% �t�B�[�h�t�H���[�h�œ��������߁A�w�ߒl�͂Ƃ肠�����[���ݒ�
xref = zeros(size(x));
yref = zeros(size(y));
hXYrefPoint = plot(0,0);
hXYLog = plot(x(1), y(1),'Color',[1 0 1]);

% ��������ѓ��扻���֐����ɂĎ��{
MakeTwoWheelVideo(Ts, hXYrefPoint, hXYLog, TwoWheel, ...
                        xref, yref, ...
                        x, y, theta, ...
                        u1, u2);