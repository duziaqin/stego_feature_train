function stego(algorithm, conf, params)
	tic;
	
	% 优先考虑命令行启动
	% 用于外部调用，比如说其他程序调用
	% 约定一级分割符是 &
	% 二级分割符是  ;
	if and(~isempty(params), ischar(params))
		params = strsplit(params, '&');
		imageSeriers = str2num(params{1});
	end
	
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
				image = stegoFunc(coverFile, single(str2num(bpp)))
			catch ME
				disp(['error(stego ',  fileName,  ' ', ME, ');']);
			end

			imwrite(image, saveFile);
		end
	end

	T = toc;
	disp(['time(', num2str(T), ');']);
end
