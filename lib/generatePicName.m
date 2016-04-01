function name = generatePicName(num)
	name = num2str(num);
	len = length(name);
	for i = 1:5-len
		name = ['0', name];
	end
end
