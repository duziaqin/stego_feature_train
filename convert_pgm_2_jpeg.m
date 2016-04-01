function  conver_pgm_2_jpeg(conf, imageSeriersFromCommad)
	disp('----------------- start -------------------------');
	% 计数
	tic;
	% 优先考虑命令行启动
	if isempty(imageSeriersFromCommad) < 1
		imageSeriers = imageSeriersFromCommad;
	end

	mfilepath=fileparts(which(mfilename));
	addpath(fullfile(mfilepath, './lib'));
	addpath(fullfile(mfilepath, './conf'));

	confFunc = str2func(conf);

	[BASE_PATH, IMAGES_PATH, ALGORITHMS_PATH, FEATURES_PATH, MODEL_PATH,	IMAGE_PREFIX, type, imageTypes, imageSeriers, bpps, algorithms]  = confFunc();

	[imageTypes_length, ~] = size(imageTypes);
	bpps_length = length(bpps);

	% --遍历
	startPoint = imageSeriers(1);
	endPoint = imageSeriers(2);


	for single = startPoint:endPoint
		coverPath = [BASE_PATH, '/images/cover/', generatePicName(single), '.', IMAGE_PREFIX];
		saveCoverPath = [IMAGES_PATH, 'cover/', generatePicName(single), '.jpeg'];
			convert2jpeg(coverPath, saveCoverPath);

			for imageTypesIndex = 1:imageTypes_length
				imageType = imageTypes{imageTypesIndex};
			for bppIndex = 1:bpps_length
				bpp = num2str(bpps(bppIndex));
				imagePath = [BASE_PATH, '/images/stego/', imageType, '/', bpp, '/', generatePicName(single), '.', IMAGE_PREFIX];
				savePath = [IMAGES_PATH, 'stego/', imageType, '/', bpp, '/', generatePicName(single), '.jpeg'];
				convert2jpeg(imagePath, savePath);
			end
	end
end

	T = toc;
	disp(strcat('----------------- done! -------------------------'));
	disp([num2str(T), ' seconds in total~']);

	function jpeg = convert2jpeg(path, toPath)
		im = imread(path);
		imwrite( im , toPath);
	end
end
