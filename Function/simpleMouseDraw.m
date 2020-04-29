% https://qiita.com/sanmojih/items/5ac9ed1510da863d42f2 から一部変更

function simpleMouseDraw()

%% 共通変数の定義
ButtonState = false;      % マウスボタンの押下状態
curLineH    = gobjects(); % 現在のLineのオブジェクト
curLineX    = [];         % 現在のLineのX座標
curLineY    = [];         % 現在のLineのY座標

%% Figureの表示
figH                       = figure();                     % figH: Figureオブジェクト
figH.MenuBar               = 'none';                       % メニューをオフ
figH.WindowButtonDownFcn   = @WindowButtonDownFcn_figH;    % マウスボタン押下時のコールバック関数を指定
figH.WindowButtonMotionFcn = @WindowButtonMotionFcn_figH;  % マウスボタン移動時のコールバック関数を指定
figH.WindowButtonUpFcn     = @WindowButtonUpFcn_figH;      % マウスボタンリリース時のコールバック関数を指定

%% Axesの表示
axH               = axes(figH);    % axH: 軸オブジェクト
axH.XTick         = [];            % X軸目盛をオフ
axH.YTick         = [];            % Y軸目盛をオフ
axH.Units         = 'normalized';  % Positionの単位指定
axH.Position      = [0,0,1,1];     % Figure全体にAxesを表示
axH.XLim          = [0,1];         % X軸範囲を指定
axH.YLim          = [0,1];         % Y軸範囲を指定

    %% コールバック関数の定義
    function WindowButtonDownFcn_figH(~,~)
        %% マウスボタン押下時のコールバック        
        ButtonState = true; % 押下状態を保存

        % マウスの位置の取得
        curLineX = axH.CurrentPoint(1,1);
        curLineY = axH.CurrentPoint(1,2);

        % 線の描画
        curLineH = line(axH,curLineX, curLineY);
    end

    function WindowButtonMotionFcn_figH(~,~)
        %% マウスボタン移動時のコールバック
        if ButtonState
            % マウスボタンを押下時には、Lineの描画を更新

            % 現在のマウスの位置
            X = axH.CurrentPoint(1,1);
            Y = axH.CurrentPoint(1,2);

            % 線の座標値を更新
            curLineX = [curLineX;X];
            curLineY = [curLineY;Y];

            % 描画の更新
            curLineH.XData = curLineX;
            curLineH.YData = curLineY;
        end
    end

    function WindowButtonUpFcn_figH(~,~)
        %% マウスボタンリリース時のコールバック
        ButtonState = false;  % ボタン押下状態を解除
        save('XY.mat','curLineX','curLineY')
    end
end