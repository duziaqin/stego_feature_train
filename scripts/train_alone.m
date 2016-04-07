% 单独养成脚本
function  train_alone(conf, params)
	% disp('----------------- 养成开始 -------------------------');
	% 计数
	TotalT = [];

	if ~isdeployed
		mfilepath=fileparts(which(mfilename));
		addpath(fullfile(mfilepath, '../lib'));
		addpath(fullfile(mfilepath, '../conf'));
	end
	confFunc = str2func(conf);

	[ type, imageTypes, imageSeriers, bpps, algorithms, ~, IMAGES_PATH, ALGORITHMS_PATH, ...
		FEATURES_PATH, MODEL_PATH,	IMAGE_PREFIX, ~]  = confFunc();

	% 用于外部调用，比如说其他程序调用
	% 约定一级分割符是 .
	% 二级分割符是  ;
	if and(~isempty(params), ischar(params))
		params = strsplit(params, '.');
		algorithms = strsplit(params{1}, ';')';
		imageTypes = strsplit(params{2}, ';')';
	end

	[algorithms_length, ~] = size(algorithms) ;
	[imageTypes_length, ~] = size(imageTypes);
	bpps_length = length(bpps);

	% --遍历
	for algorithmIndex = 1:algorithms_length
		algorithm = algorithms{algorithmIndex};

		% 提取cover feature
		load(fullfile(FEATURES_PATH, 'cover', [algorithm, '_cover_feature.mat' ]), 'coverF');

		for imageTypesIndex = 1:imageTypes_length
			imageType = imageTypes{imageTypesIndex};
			for bppIndex = 1:bpps_length
			tic;
			bpp = num2str(bpps(bppIndex));
			% 提取stego feature
			load(fullfile(FEATURES_PATH, 'stego', type, [algorithm, '_stego_',  imageType, '_' , num2str(bpp), '_feature.mat' ]), 'stegoF');

			% svm训练
			[model, score, medv, disv] = train(coverF, stegoF);

			% 保存训练集model供后期使用
			save(fullfile(MODEL_PATH, type, [algorithm,  '_stego_',  imageType, '_' , num2str(bpp), '_model.mat']), 'model', 'score', 'medv', 'disv');

			T = toc;
			TotalT = [TotalT; T];
			fprintf('algorithm(%s); imageType(%s); bpp(%s); trainTime(%.4f); \n', algorithm, imageType, num2str(bpp),T);
		end
	end
end

	% disp(strcat('-----------------养成结束! -------------------------'));
	% disp('totalTime(', [num2str(sum(TotalT(:))), ');']);
end
