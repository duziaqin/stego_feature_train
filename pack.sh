#!/bin/sh
# 打包index.m和scripts里的独立脚本到dest里，供其他程序调用
while getopts "a:s:h" arg
do
	case $arg in
		a)
			algorithm=${OPTARG}
			echo "选定打包algorithm为：${OPTARG}"
			;;
		s)
			singlePack=${OPTARG}
			echo "只打包文件：${OPTARG}"
			;;
		h)
			echo `帮助提示：
			打包index.m, scripts, feature_extract_alone, train_alone里的独立脚本到dest里，供其他程序调用
			-a {algorithm} 指定要依赖的算法文件
			-s {file} 只打包单个文件`
			;;
	esac
done

if [ $singlePack ]
then
	targetFile=(${singlePack})
else
	targetFile=('index' 'stego' 'feature_extract_alone' 'train_alone')
fi

# 切换到脚本所在位置执行
cd $(dirname "$0");

for file in ${targetFile[@]}
do
	case $file in
		index)
			mcc -m "./index.m" -a "./scripts" -a "./conf" -d "./dest"
			;;
		stego)
			mcc -m "./scripts/stego.m" -a "./lib/generatePicName.m" -a "./conf" -a "./stego/${algorithm}" -d "./dest"
			;;
		feature_extract_alone)
			echo "feature_extract_alone"
			mcc -m "./scripts/feature_extract_alone.m" -a "./lib" -a "./scripts" -a "./conf" -a "./algorithms/spatial/${algorithm}" -d "./dest"
			;;
		train_alone)
			mcc -m "./scripts/train_alone.m" -a "./lib" -a "./scripts" -a "./conf"  -d "./dest"
		;;
		esac
done
echo "done~"
