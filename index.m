function index(conf, params)
		if and(~isempty(params), ischar(params))
			params = str2num(params);
		end

		if ~isdeployed
			mfilepath=fileparts(which(mfilename));
			addpath(fullfile(mfilepath, './scripts'));
		end
		
		tic;
		feature_extract_alone(conf, params);
		T = toc;
		disp(['feature extract:', num2str(T)]);

		tic;
		train_alone(conf, params);
		T = toc;
		disp(['train and predict:', num2str(T)])
end
