% https://qiita.com/sanmojih/items/5ac9ed1510da863d42f2 ����ꕔ�ύX

function simpleMouseDraw()

%% ���ʕϐ��̒�`
ButtonState = false;      % �}�E�X�{�^���̉������
curLineH    = gobjects(); % ���݂�Line�̃I�u�W�F�N�g
curLineX    = [];         % ���݂�Line��X���W
curLineY    = [];         % ���݂�Line��Y���W

%% Figure�̕\��
figH                       = figure();                     % figH: Figure�I�u�W�F�N�g
figH.MenuBar               = 'none';                       % ���j���[���I�t
figH.WindowButtonDownFcn   = @WindowButtonDownFcn_figH;    % �}�E�X�{�^���������̃R�[���o�b�N�֐����w��
figH.WindowButtonMotionFcn = @WindowButtonMotionFcn_figH;  % �}�E�X�{�^���ړ����̃R�[���o�b�N�֐����w��
figH.WindowButtonUpFcn     = @WindowButtonUpFcn_figH;      % �}�E�X�{�^�������[�X���̃R�[���o�b�N�֐����w��

%% Axes�̕\��
axH               = axes(figH);    % axH: ���I�u�W�F�N�g
axH.XTick         = [];            % X���ڐ����I�t
axH.YTick         = [];            % Y���ڐ����I�t
axH.Units         = 'normalized';  % Position�̒P�ʎw��
axH.Position      = [0,0,1,1];     % Figure�S�̂�Axes��\��
axH.XLim          = [0,1];         % X���͈͂��w��
axH.YLim          = [0,1];         % Y���͈͂��w��

    %% �R�[���o�b�N�֐��̒�`
    function WindowButtonDownFcn_figH(~,~)
        %% �}�E�X�{�^���������̃R�[���o�b�N        
        ButtonState = true; % ������Ԃ�ۑ�

        % �}�E�X�̈ʒu�̎擾
        curLineX = axH.CurrentPoint(1,1);
        curLineY = axH.CurrentPoint(1,2);

        % ���̕`��
        curLineH = line(axH,curLineX, curLineY);
    end

    function WindowButtonMotionFcn_figH(~,~)
        %% �}�E�X�{�^���ړ����̃R�[���o�b�N
        if ButtonState
            % �}�E�X�{�^�����������ɂ́ALine�̕`����X�V

            % ���݂̃}�E�X�̈ʒu
            X = axH.CurrentPoint(1,1);
            Y = axH.CurrentPoint(1,2);

            % ���̍��W�l���X�V
            curLineX = [curLineX;X];
            curLineY = [curLineY;Y];

            % �`��̍X�V
            curLineH.XData = curLineX;
            curLineH.YData = curLineY;
        end
    end

    function WindowButtonUpFcn_figH(~,~)
        %% �}�E�X�{�^�������[�X���̃R�[���o�b�N
        ButtonState = false;  % �{�^��������Ԃ�����
        save('XY.mat','curLineX','curLineY')
    end
end