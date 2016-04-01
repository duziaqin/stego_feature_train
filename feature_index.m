% 断点续提 特征矩阵脚本
function  feature_index(conf, imageSeriersFromCommad)
	disp('-----------------提取开始-------------------------');
	% 计数
	TotalT = [];

	mfilepath=fileparts(which(mfilename));
	addpath(fullfile(mfilepath, './lib'));
	addpath(fullfile(mfilepath, './conf'));

	confFunc = str2func(conf);

	[~, IMAGES_PATH, ALGORITHMS_PATH, FEATURES_PATH, MODEL_PATH,	IMAGE_PREFIX, type, imageTypes, imageSeriers, bpps, algorithms]  = confFunc();

	% 优先考虑命令行启动
	if isempty(imageSeriersFromCommad) < 1
		imageSeriers = imageSeriersFromCommad;
	end

	addpath(genpath(ALGORITHMS_PATH));

	[algorithms_length, ~] = size(algorithms) ;
	[imageTypes_length, ~] = size(imageTypes);
	bpps_length = length(bpps);

	% --遍历
	for algorithmIndex = 1:algorithms_length
		algorithm = algorithms{algorithmIndex};

		%保存路径
		saveCoverFPath = [FEATURES_PATH, 'cover/', algorithm, '_cover_feature.mat' ];

		% 如果不是从1开始，就load写好的矩阵回来
		coverF = [];
		if imageSeriers(1) > 1
			load(saveCoverFPath);
		end;

		% 提取cover feature
		coverPeriodF = feature(algorithm, IMAGES_PATH, imageSeriers, 'cover', 0,  IMAGE_PREFIX);
		coverF = [coverF; coverPeriodF];
		save(saveCoverFPath, 'coverF');

		for imageTypesIndex = 1:imageTypes_length
			imageType = imageTypes{imageTypesIndex};
			for bppIndex = 1:bpps_length
			tic;
			bpp = num2str(bpps(bppIndex));
			%保存路径
			saveStegoFPath = [FEATURES_PATH, 'stego/', type, '/', algorithm, '_stego_',  imageType, '_' , num2str(bpp), '_feature.mat' ];
			stegoF = [];

			% 如果不是从1开始，就load写好的矩阵回来
			if imageSeriers(1) > 1
				load(saveStegoFPath);
			end;

			% 提取stego feature
			[stegoPeriodF] = feature(algorithm, [IMAGES_PATH, 'stego/'], imageSeriers, imageType, bpp,  IMAGE_PREFIX);
			stegoF = [stegoF; stegoPeriodF];
			save(saveStegoFPath, 'stegoF');

			T = toc;
			TotalT = [TotalT; T];
			fprintf('algorithm %s, imageType %s, bpp %s: %.4f seconds\n', algorithm, imageType, num2str(bpp),T);
		end
	end
end

	disp(strcat('----------------- 提取结束!-------------------------'));
	disp([num2str(sum(TotalT(:))), ' seconds in total~']);
end
