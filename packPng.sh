#/bin/sh

packType=$1
pathCh="chinese"
pathEn="english"
fixPath=""
if [[ $packType == 1 ]]; then
	packType=$packCh
	fixPath="pic/pic_ch"
else
	packType=$packEn
	fixPath="pic/pic_en"
fi

function replacePic()
{
	local fileName=$1
	for file in ../* 
	do	
		local fRet=false

		if  [ -d $file && ${file##*/} ]; then
			for pic in $file/* 
			do
				if [[ ${pic##*/} == ${fileName##*/} ]]; then
					cp -f $fileName $file
					fRet=true
					break
				fi
			done
		fi

		if  $fRet; then
			break
		fi
	done
}


#遍历换图文件夹，将图片替换到texturepacker用的文件夹中
function ergodicPic()
{
	local ePath=$1
	for file in $ePath/*
	do
		if test -f $file; then
			replacePic $file
		elif test -d $file; then
			ergodicPic $file
		fi
	done
}


#根据路径和文件名查找文件并返回
function findFile()
{
	local filename = $1
	local findPath = $2

	for file in findPath; do
		if [ -f $file ]; then
			if [[ ${file##*/} == $filename ]]; then
				return file
			fi
		elif [ -d $file ]; then
			local findRet = findFile filename $findPath/$file
			if [[ ${#findRet} > 1 ]]; then
				return findRet
			fi
		fi
	done
}

function compressPng()
{
	for floder in ../*; do
		if [ -d $floder ];then
			local fileName=${floder##*/}
			echo $fileName
			TexturePacker  --texture-format png --data "output/$fileName.plist" --format cocos2d --sheet "output/$fileName.png" "../$fileName"
		fi
	done
}



# function replaceAll()
# {
# 	for file in output/* 
# 	do	
# 		if  [ -d $file ]; then

# 			for pic in ../../Resources; do
				
# 			done

# 			for pic in $file/* 
# 			do
# 				if [[ ${pic##*/} == ${fileName##*/} ]]; then
# 					cp -f $fileName $file
# 					fRet=true
# 					break
# 				fi
# 			done
# 		fi

# 		if  $fRet; then
# 			break
# 		fi
# 	done
# }

	ergodicPic $fixPath

	compressPng


