%%% setup
mfilepath=fileparts(which(mfilename));
addpath(fullfile(mfilepath, './lib'));
addpath(fullfile(mfilepath, './conf'));

[~, IMAGES_PATH, ALGORITHMS_PATH, FEATURES_PATH, MODEL_PATH,	IMAGE_PREFIX, type, imageTypes, imageLength, bpps, algorithms]  = spatial();
addpath(genpath(ALGORITHMS_PATH));

imageType = imageTypes{2};
algorithm = algorithms{1};
 bpp = num2str(bpps(4));
 pic = '00080.pgm';

stegoFunc = str2func(algorithm);
stegoF = stegoFunc([IMAGES_PATH, 'stego/', imageTypes{1}, '/', bpp, '/', pic]);
coverF = stegoFunc([IMAGES_PATH, 'cover/', pic]);

F = [stegoF; coverF];
load([MODEL_PATH, 'spatial/', algorithm,  '_stego_',  imageType, '_' , bpp, '_model.mat'], 'model');
[label, ~, ~] = predict(model, F);

disp(strcat('bpp: ', bpp, ' algorithm: ', algorithm, ' pic: ', pic));
disp(strcat('stego图片(1): ', num2str(label(1)), ' cover图片(-1): ', num2str(label(2))));
