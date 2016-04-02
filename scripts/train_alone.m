% 单独养成脚本
function  feature_alone(conf, params)
	disp('----------------- 养成开始 -------------------------');
	% 计数
	TotalT = [];

	mfilepath=fileparts(which(mfilename));
	addpath(fullfile(mfilepath, '../lib'));
	addpath(fullfile(mfilepath, '../conf'));

	confFunc = str2func(conf);

	[ type, imageTypes, imageSeriers, bpps, algorithms, ~, IMAGES_PATH, ALGORITHMS_PATH, ...
		FEATURES_PATH, MODEL_PATH,	IMAGE_PREFIX, ~]  = confFunc();

	% 用于外部调用，比如说其他程序调用
	if ~isempty(params)
		algorithms = params(1);
		imageTypes = params(2);
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
			fprintf('algorithm %s, imageType %s, bpp %s: %.4f seconds\n', algorithm, imageType, num2str(bpp),T);
		end
	end
end

	disp(strcat('-----------------养成结束! -------------------------'));
	disp([num2str(sum(TotalT(:))), ' seconds in total~']);
end
