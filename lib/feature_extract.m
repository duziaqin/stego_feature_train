function featureF = feature_extract(algorithm, PATH, imageSeriers, imageType, bpp,  prefix)
	algorithmFunc = str2func(algorithm);

	startPoint = imageSeriers(1);
	endPoint = imageSeriers(2);

	% 调用隐写算法，生成隐写图片features
		featureF = [];
		for single = startPoint:endPoint
			if nonzeros(bpp)
				imagePath = fullfile(PATH, imageType,  bpp,  [generatePicName(single), '.', prefix]);
			else
				imagePath = fullfile(PATH, imageType,  [generatePicName(single), '.', prefix]);
			end

			try
				featureVector = transform2Vector(algorithmFunc(imagePath));
				featureF = [featureF; featureVector];
			catch ME
				disp(['errors(feature ', single, ');errorBpp(', num2str(bpp), ');']);
			end
		end

	function columnVector = transform2Vector(matrix)
		% rowVector = matrix(:);
		% columnVector = rowVector';
		columnVector = matrix;
	end
end
