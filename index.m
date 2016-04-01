
function  index(conf)
	disp('----------------- start -------------------------');
	% 计数
	TotalT = [];

	mfilepath=fileparts(which(mfilename));
	addpath(fullfile(mfilepath, './lib'));
	addpath(fullfile(mfilepath, './conf'));

	confFunc = str2func(conf);

	[~, IMAGES_PATH, ALGORITHMS_PATH, FEATURES_PATH, MODEL_PATH,	IMAGE_PREFIX, type, imageTypes, imageSeriers, bpps, algorithms]  = confFunc();

	addpath(genpath(ALGORITHMS_PATH));

	[algorithms_length, ~] = size(algorithms) ;
	[imageTypes_length, ~] = size(imageTypes);
	bpps_length = length(bpps);

	% --遍历
	for algorithmIndex = 1:algorithms_length
		algorithm = algorithms{algorithmIndex};

		% 提取cover feature
		coverF = feature(algorithm, IMAGES_PATH, imageSeriers, 'cover', 0,  IMAGE_PREFIX);
		% 为什么要保存呢，为什么呢，我也不造瓦
		% save([FEATURES_PATH, 'cover/', algorithm, '_cover_feature.mat' ], 'coverF');

		for imageTypesIndex = 1:imageTypes_length
			imageType = imageTypes{imageTypesIndex};
			for bppIndex = 1:bpps_length
			tic;
			bpp = num2str(bpps(bppIndex));
			% 提取stego feature
			[stegoF] = feature(algorithm, [IMAGES_PATH, 'stego/'], imageSeriers, imageType, bpp,  IMAGE_PREFIX);

			% 为什么要保存呢，为什么呢，我也不造瓦
			save([FEATURES_PATH, 'stego/', type, '/', algorithm, '_stego_',  imageType, '_' , num2str(bpp), '_feature.mat' ], 'stegoF');

			% svm训练
			[model, score, medv, disv] = train(coverF, stegoF);

			% 保存训练集model供后期使用
			save([MODEL_PATH, type, '/', algorithm,  '_stego_',  imageType, '_' , num2str(bpp), '_model.mat'], 'model', 'score', 'medv', 'disv');

			T = toc;
			TotalT = [TotalT; T];
			fprintf('algorithm %s, imageType %s, bpp %s: %.4f seconds\n', algorithm, imageType, num2str(bpp),T);
		end
	end
end

	disp(strcat('----------------- done! -------------------------'));
	disp([num2str(sum(TotalT(:))), ' seconds in total~']);
end
