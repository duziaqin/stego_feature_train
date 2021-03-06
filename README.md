## For
调用隐写分析算法，对隐写特征矩阵进行svm训练，并存储model文件

逻辑步骤如下：

1. 配置conf `//TODO：写cpp脚本遍历拿到目录下的文件`
2. 通过遍历algorithms和images生成feature，存于feature文件夹下
	 * cover & stego；
	 * 生成文件名规则：`{{algorithms}}_{{stego || cover}}_{{隐写类型}}_{{bpp}}_feature.mat`
3. 遍历调用train对feature矩阵进行训练，存于models文件夹下
	* 生成文件名规则：`{{algorithms}}_{{stego || cover}}_{{隐写类型}}_{{bpp}}_model.mat`

## 运行
matlab基础运行：
* matlab下直接输入需要执行的文件名（路径）
* matlab下打开要执行的文件，点击运行按钮

由于不会cpp，所以只能首先配置conf文件，conf中指明algorithms的名称和images的名称，具体看配置文件。
配置完就可以运行了。

1. 运行
	* 直接运行：运行`index.m {{conf}}` || `index.sh {{conf}}`;  conf是配置在conf文件夹下的，其实就是隐写分析算法所对应的对象；
	* 分步执行：由于直接执行是对每一个算法-隐写类型-嵌入率进行特征提取->svm训练，大批量情况下，会比较慢，可以选择分步执行，可断点跑。
		* 运行`feature_index.m {{conf}} imageSeriers`;
		* 运行`train_index.m {{conf}}`;
		* imageSeriers取[start, end]的图像排序，如[1, 500]则是取images下编号为00001至00500

## 打包
利用`pack.sh`打包，打包目标包括`index.m`、`scripts/stego.m`、`scripts/feature_extract_alone`以及`scripts/train_alone`主要是为了其他程序调用方便

具体运行参数可通过 `pack.sh -h`查看

## 各种默认配置规范
图片命名要按照一定规范，还有文件夹命名。
目录如下：

	├── algorithms
	│   ├── JPEG
	│   │   └── Ah_T3
	│   └── spatial
	│       ├── SPAM
	│       └── WAM
	├── conf
	│   ├── JPEG.m
	│   └── spatial.m
	├── features
	│   ├── cover
	│   │   ├── Ah_T3_cover_feature.mat //生成的特征矩阵文件
	│   │   └── WAM_cover_feature.mat
	│   └── stego
	│       ├── JPEG
	│       └── spatial
	├── images
	│   ├── cover
	│   │   ├── 00001.pgm //图片命名规则，如第500张：00500
	│   │ 	└── 00002.pgm
	│   └── stego
	│       ├── HUGO
	│       ├── nsf5_simulation
	│       ├── S-UNIWARD
	│       └── WOW
	├── index.m
	├── jpeg
	│   ├── cover
	│   │   └── 00001.jpeg
	│   └── stego
	│       ├── HUGO
	│       ├── S-UNIWARD
	│       └── WOW
	├── lib
	│   ├── feature.m
	│   ├── generatePicName.m
	│   └── train.m
	├── models
	│   ├── JPEG
	│   └── spatial
	│       └── WAM_stego_WOW_0.5_model.mat //生成的model文件
	├── README.md
	├── scripts
	│   ├── convert_pgm_2_jpeg.m
	│   ├── feature_alone.m
	│   ├── stego.m
	│   └── train_alone.m
	├── stego
	│   └── WOW
	│       ├── WOW.m
	│       └── WOW.mexa64
	└── test.m
