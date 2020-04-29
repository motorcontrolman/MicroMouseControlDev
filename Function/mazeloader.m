%% https://kerikeri.top/posts/2018-07-04-maze-img-parser/
%% 要 Image Processing ToolBox
% 壁が黒じゃない場合に応じて修正（赤）

clear all;
close all;

%% 入力
[filename, pathname] = uigetfile({'*.bmp;*.jpg;*.png;*.gif'}, 'Select the Maze Imgae');

%% 二値化＆色反転(壁を1にするため)
img = imread([pathname, filename]);
binariImg = imbinarize(rgb2gray(img));
%binariImg = imcomplement(binariImg);
imshow(binariImg);

%% 迷路の輪郭を抽出
% 横長さをLength, 縦長さをWidthとして定義
[mazeWidth, mazeLength] = size(binariImg);
mazeWidthHalf = mazeWidth / 2;
mazeLengthHalf = mazeLength / 2;

colSum = sum(binariImg);
rowSum = sum(binariImg, 2);

[~, idxLeft] = max( colSum(1 : mazeLengthHalf) );
[~, idxRightFromHalf] = max( colSum( mazeLengthHalf : end) );
idxRight = idxRightFromHalf + mazeLengthHalf;
[~, idxTop] = max( rowSum(1 : mazeWidthHalf) );
[~, idxBottomFromHalf] = max( rowSum(mazeWidthHalf : end) );
idxBottom = idxBottomFromHalf + mazeWidthHalf;

trimImg = binariImg( idxTop : idxBottom, idxLeft : idxRight );
trimImg = imresize(trimImg, [1600 1600]);

%% ノイズの除去と壁の膨張
trimImg = imopen(trimImg, ones(5));   % 白点線を除去
trimImg = imdilate(trimImg, ones(5)); % 白線を太くする
imshow(trimImg);

%% 迷路サイズを検出
trimsum = sum(trimImg);
trimsum = trimsum < sum(trimsum) / length(trimsum);
maze_size = sum(([trimsum 0]-[0 trimsum])>0);
msgbox(sprintf('迷路サイズは %d です', maze_size)); % 迷路サイズの表示

%% 壁の抽出
segsize = size(trimImg)/maze_size;
vwall = trimImg(round(segsize(1)/2:segsize(1):end), round(1:segsize(2):end-segsize(2)/3));
hwall = trimImg(round(1:segsize(1):end-segsize(1)/3), round(segsize(2)/2:segsize(2):end));
vwall = [vwall, ones(maze_size, 1)];
hwall = [hwall; ones(1, maze_size)];

%% 壁の合成
wall =        1 * vwall(:, 2:end);      % 東 0 bit
wall = wall + 2 * hwall(1:end-1, :);    % 北 1 bit
wall = wall + 4 * vwall(:, 1:end-1);    % 西 2 bit
wall = wall + 8 * hwall(2:end, :);      % 南 3 bit

%% ファイルに保存
output = reshape(sprintf('%x',wall), maze_size, maze_size);
output = ['"'*ones(maze_size, 1) output '",'.*ones(maze_size,1)];
new_filename = sprintf('%s.txt', filename);
dlmwrite(new_filename, output, 'precision', '%c', 'delimiter', '');