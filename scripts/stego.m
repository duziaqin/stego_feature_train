function stego(algorithm, conf)
	tic;

	if ~isdeployed
		mfilepath=fileparts(which(mfilename));
		addpath(fullfile(mfilepath, '../lib'));
		addpath(fullfile(mfilepath, '../conf'));
	end

	confFunc = str2func(conf);
	[ ~, ~, imageSeriers, bpps, ~, ~, ...
		IMAGES_PATH, ~, ~, ~,	IMAGE_PREFIX, STEGO_PATH]  = confFunc();

	if ~isdeployed
		addpath(genpath(STEGO_PATH));
	end

	stegoFunc = str2func(algorithm);

	startPoint = imageSeriers(1);
	endPoint = imageSeriers(2);

	coverPath = fullfile(IMAGES_PATH, 'cover');
	savePath = fullfile(IMAGES_PATH, 'stego', algorithm);
	params.p = -1;

	if ~exist(savePath, 'dir')
		mkdir(savePath);
	end

	bpps_length = length(bpps);

	for bppIndex = 1:bpps_length
		bpp = num2str(bpps(bppIndex));
		saveBppPath = fullfile(savePath, bpp);
		if ~exist(saveBppPath, 'dir')
			mkdir(saveBppPath);
		end

		for fileNumber = startPoint:endPoint
			fileName = [generatePicName(fileNumber), '.', IMAGE_PREFIX];
			coverFile = imread(fullfile(coverPath, fileName));
			saveFile = fullfile(saveBppPath, fileName);

			imwrite(stegoFunc(coverFile, single(str2num(bpp)), params), saveFile);
		end
	end

	T = toc;
	disp(['stego time: ', num2str(T)]);
end
