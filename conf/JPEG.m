function [type, imageTypes, imageSeriers, bpps, algorithms, BASE_PATH, IMAGES_PATH, ALGORITHMS_PATH, FEATURES_PATH, MODEL_PATH,	IMAGE_PREFIX, STEGO_PATH] = JPEG()
	% 基本路径
	BASE_PATH = '/home/mona/Documents/stego_feature_train/';

	% 图像所在路径
	IMAGES_PATH = fullfile(BASE_PATH , 'jpeg');

	% 隐写分析针对
	type = 'JPEG';

	% 隐写分析算法所在路径
	ALGORITHMS_PATH = fullfile(BASE_PATH, 'algorithms', 'JPEG');

	% 要生成的特征矩阵文件存储位置
	FEATURES_PATH = fullfile(BASE_PATH, 'features');

	% 要生成的model文件存储位置
	MODEL_PATH = fullfile(BASE_PATH, 'models');

	% 隐写算法文件存储位置
	STEGO_PATH = fullfile(BASE_PATH, 'stego');
	
	% 图片后缀
	IMAGE_PREFIX = 'jpeg';

	% 图片类型
	imageTypes= cell(3,1);
	imageTypes{1} = 'HUGO';
	imageTypes{2} = 'S-UNIWARD';
	imageTypes{3} = 'WOW';

	%每一类(一个嵌入率)起始和终止数
	imageSeriers = [1; 2];

	% 嵌入率
	bpps = [0.2; 0.3; 0.4; 0.5];

	% 算法列表
	algorithms = cell(1,1);
	algorithms{1} = 'Ah_T3';
end
