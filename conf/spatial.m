function [BASE_PATH, IMAGES_PATH, ALGORITHMS_PATH, FEATURES_PATH, MODEL_PATH,	IMAGE_PREFIX, type, imageTypes, imageSeriers, bpps, algorithms] = spatial()
	% 基本路径
		BASE_PATH = '/home/mona/Documents/stego_feature_train/';

	% 图像所在路径
	IMAGES_PATH = fullfile(BASE_PATH , 'images');

	% 隐写分析针对
		type = 'spatial';

	% 隐写分析算法所在路径
	ALGORITHMS_PATH = fullfile(BASE_PATH, 'algorithms', 'spatial');

	% 要生成的特征矩阵文件存储位置
	FEATURES_PATH = fullfile(BASE_PATH, 'features');

	% 要生成的model文件存储位置
	MODEL_PATH = fullfile(BASE_PATH, 'models/');

	% 图片后缀
	IMAGE_PREFIX = 'pgm';

	% 图片类型
	% imageTypes= cell(3,1);
	% imageTypes{1} = 'HUGO';
	% imageTypes{2} = 'S-UNIWARD';
	% imageTypes{3} = 'WOW';

	imageTypes = cell(1,1);
	imageTypes{1} = 'WOW';

	%每一类(一个嵌入率)起始和终止数
	imageSeriers = [1; 2];

	% 嵌入率
	% bpps = [0.2; 0.3; 0.4; 0.5];
	bpps = [0.5];

	% 算法列表
	algorithms = cell(1,1);
	% algorithms{1} = 'SPAM';
	algorithms{1} = 'WAM';
end
