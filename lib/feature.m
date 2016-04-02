function featureF = feature(algorithm, PATH, imageSeriers, imageType, bpp,  prefix)
	algorithmFunc = str2func(algorithm);
	startPoint = imageSeriers(1);
	endPoint = imageSeriers(2);

	disp(num2str(startPoint));
	% 调用隐写算法，生成隐写图片features
		featureF = [];
		for single = startPoint:endPoint
			if nonzeros(bpp)
				imagePath = fullfile(PATH, imageType,  bpp,  [generatePicName(single), '.', prefix]);
			else
				imagePath = fullfile(PATH, imageType,  [generatePicName(single), '.', prefix]);
			end
			disp(imagePath);
			featureVector = transform2Vector(algorithmFunc(imagePath));
			featureF = [featureF; featureVector];
			disp([imagePath, ' done~']);
		end

	function columnVector = transform2Vector(matrix)
		% rowVector = matrix(:);
		% columnVector = rowVector';
		columnVector = matrix;
	end
end
