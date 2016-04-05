function [model, score, medv, disv] =  train(cover, stego)
AU = stego;
SP = cover;

[xa,~]=size(AU);
[xb,yb]=size(SP);

au_nan = isnan(AU);
au_inf = isinf(AU);
sp_nan = isnan(SP);
sp_inf = isinf(SP);

error_sum = max(max(au_nan)) + max(max(au_inf)) + max(max(sp_nan)) + ...
    max(max(sp_inf));
if(error_sum ~= 0)
    disp('errors(特征有异常);');
    return;
end

tic;
%%特征归一化处理
maxvau=max(AU);
minvau=min(AU);
maxvsp=max(SP);
minvsp=min(SP);
maxv = max(maxvau,maxvsp);
minv = min(minvau,minvsp);
medv = (maxv+minv)/2;
disv = (maxv-minv)/2;
for i=1:xa
    AU(i,:)=(AU(i,:)-medv)./disv;
end
for i=1:xb
    SP(i,:)=(SP(i,:)-medv)./disv;
end

%% 生成随机序列
% load('index.mat');
RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));
indexA=randperm(xa);
indexB=randperm(xb);

%% 训练集的比例
% disp('==========================================================');
per = 1.0 / 2.0;
anum = xa;
snum = xb;
atnum=round(anum*per);
stnum=round(snum*per);
% disp(strcat('特征数为：',num2str(yb)));
% disp(strcat('训练样本数(',num2str(100*per),'%)：',num2str(atnum+stnum),'(',num2str(atnum),'+',num2str(stnum),')'));
% disp(strcat('测试样本数(',num2str(100*(1-per)),'%)：',num2str((xa+xb)-(atnum+stnum)),'(',num2str(anum-atnum),'+',num2str(snum-stnum),')'));

AU1=AU(indexA(1:atnum),:);
AU2=AU(indexA(atnum+1:anum),:);
SP1=SP(indexB(1:stnum),:);
SP2=SP(indexB(stnum+1:snum),:);
%% LIBSVM

y1 = double(ones(atnum,1));
y2 = double(-ones(stnum,1));
TrainLabel=[y1;y2];
% AU1:隐写; SP1:载体图片
TrainData=[AU1;SP1];
model = fitcsvm(TrainData, TrainLabel);

T = toc;
disp(['trainTime(', T, ')']);

tic;
TestData=[AU2;SP2];
[isstego, score] = predict(model, TestData);

T = toc;
disp(['classifyTime(', T, ')']);

% 简易判断隐写分析效果，不准确哒
% disp(num2str(sum(isstego(:))));

% 准确判断
[isstego_length, ~] = size(isstego);

truePredict = 0;
TP = 0;
FP = 0;
isstego_half =  isstego_length * per;

for i = 1:isstego_length
	if i >= isstego_half
		if isstego(i) == -1
			truePredict = truePredict + 1;
		else
			% disp([num2str(isstego(i)), '  ', num2str(i)]);
			FP = FP + 1;
		end
		% disp(['predict cover? ', num2str(isstego(i) == -1) ]);
	else
		if isstego(i) == 1
			truePredict = truePredict + 1;
			TP = TP + 1;
		end
		% disp(['predict stego? ', num2str(isstego(i) == 1)])
	end
end

disp(['sum(', num2str(isstego_length), ':',  num2str(truePredict), '); TP', '(', num2str(isstego_half), ':' , num2str(TP), ');  FP', '(', num2str(isstego_half), ':' ,num2str(FP), ');']);
end
