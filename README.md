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

## 各种默认配置规范
图片命名要按照一定规范，还有文件夹命名。
