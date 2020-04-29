%% https://kerikeri.top/posts/2018-07-04-maze-img-parser/
%% �v Image Processing ToolBox
% �ǂ�������Ȃ��ꍇ�ɉ����ďC���i�ԁj

clear all;
close all;

%% ����
[filename, pathname] = uigetfile({'*.bmp;*.jpg;*.png;*.gif'}, 'Select the Maze Imgae');

%% ��l�����F���](�ǂ�1�ɂ��邽��)
img = imread([pathname, filename]);
binariImg = imbinarize(rgb2gray(img));
%binariImg = imcomplement(binariImg);
imshow(binariImg);

%% ���H�̗֊s�𒊏o
% ��������Length, �c������Width�Ƃ��Ē�`
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

%% �m�C�Y�̏����ƕǂ̖c��
trimImg = imopen(trimImg, ones(5));   % ���_��������
trimImg = imdilate(trimImg, ones(5)); % �����𑾂�����
imshow(trimImg);

%% ���H�T�C�Y�����o
trimsum = sum(trimImg);
trimsum = trimsum < sum(trimsum) / length(trimsum);
maze_size = sum(([trimsum 0]-[0 trimsum])>0);
msgbox(sprintf('���H�T�C�Y�� %d �ł�', maze_size)); % ���H�T�C�Y�̕\��

%% �ǂ̒��o
segsize = size(trimImg)/maze_size;
vwall = trimImg(round(segsize(1)/2:segsize(1):end), round(1:segsize(2):end-segsize(2)/3));
hwall = trimImg(round(1:segsize(1):end-segsize(1)/3), round(segsize(2)/2:segsize(2):end));
vwall = [vwall, ones(maze_size, 1)];
hwall = [hwall; ones(1, maze_size)];

%% �ǂ̍���
wall =        1 * vwall(:, 2:end);      % �� 0 bit
wall = wall + 2 * hwall(1:end-1, :);    % �k 1 bit
wall = wall + 4 * vwall(:, 1:end-1);    % �� 2 bit
wall = wall + 8 * hwall(2:end, :);      % �� 3 bit

%% �t�@�C���ɕۑ�
output = reshape(sprintf('%x',wall), maze_size, maze_size);
output = ['"'*ones(maze_size, 1) output '",'.*ones(maze_size,1)];
new_filename = sprintf('%s.txt', filename);
dlmwrite(new_filename, output, 'precision', '%c', 'delimiter', '');