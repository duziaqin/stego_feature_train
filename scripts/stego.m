function stego(algorithm, conf, params)
	tic;

	if ~isdeployed
		mfilepath=fileparts(which(mfilename));
		addpath(fullfile(mfilepath, '../lib'));
		addpath(fullfile(mfilepath, '../conf'));
	end

	confFunc = str2func(conf);
	[ ~, ~, imageSeriers, bpps, ~, ~, ...
		IMAGES_PATH, ~, ~, ~,	IMAGE_PREFIX, STEGO_PATH]  = confFunc();

		% 优先考虑命令行启动
		% 用于外部调用，比如说其他程序调用
		if and(~isempty(params), ischar(params))
			params = str2num(params);
			imageSeriers = params(1);
		end

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

			try
				image = stegoFunc(coverFile, single(str2num(bpp)), params)
			catch ME
				disp(['error(stego ',  fileName,  ' ', ME, ');']);
			end

			imwrite(image, saveFile);
		end
	end

	T = toc;
	disp(['time(', num2str(T), ');']);
end
