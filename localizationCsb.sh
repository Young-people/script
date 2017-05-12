#!/bin/zsh

# Description:
# 		遍历tank_res/proj下ui工程的slg文件夹下的文件，取label控件的名字和值，写入到CSBNodeLocalResHelper.lua的csbFileLabels中，创建UI控件
# 		时读取csbFileLabels，为创建出的节点的每个Label子节点的值都加上 T()标签
#		注：所有操作的文件都应该已经在Res.lua文件中存在，否则exit 1
# Author:Wangkun
# Version:1.0
# CreateTime:2017-05-12 14:13:42

# 辅助文件，如果存在，清空内容 （这是三个辅助文件）
cat /dev/null > ../temp.lua
cat /dev/null > t1
cat /dev/null > t2


# 把传入的第一个值作为字符串拼接到temp.lua的末尾  （这是一个辅助文件）
function catToTempLua()
{
	echo "$1 \n" >> ../temp.lua
}

# lua中table的命名
catToTempLua "
csbFileLabels = 
{
"

# 遍历slg下的所有文件，找出含有文本：LabelText=的文件名
for fileFullPath in `grep -rl LabelText= ../../tank_res/proj/ui/cocosstudio/ui/slg/`;
do
#不能删，虽然我也不知道为啥
	IFS=$OLDIFS
#去除路径
	filename=${fileFullPath##*/}						
#文件名的.csd改为_csb
	filename=`echo $filename|sed "s/.csd/_csb/" `   	
#查找Res.lua中有没有此文件名
	grep -q $filename ../src/Res.lua    				
	if [ $? -eq 0 ]; then
: # echo "find ---------->"${filename}
	else
#没有找到 退出
		echo "not find $filename，exit 1"   
		exit 1
	fi
#取该文件在Res.lua中记录的路径
	temp=`grep $filename ../src/Res.lua| awk -F '"' '{print $2}'`   
#写入csbFileLabels第一级孩子的key	
	catToTempLua "	\"""$temp""\""\ "="     				
#第二级孩子表头		
	catToTempLua "	{"												

#取出所有Name标签的值 ,注：csd的节点记录，Name总在第一位，所以$2就是Name节点的值写入 t1
	grep -on LabelText= $fileFullPath|grep 'LabelText="[^\"]*"' $fileFullPath|awk -F '"' '{print $2}' > t1  
#取出LabelText标签的值 写入图
	grep -on LabelText= $fileFullPath|grep -o 'LabelText="[^\"]*"' $fileFullPath|awk -F '"' '{print $2}' > t2 


	num=0
	cat t1 |while read line
	do
		((++num))
		valueStr=`sed -n ${num}p t2`		
if [ ${#valueStr} -eq 0 ];then
# 按行号，从t2取值，如果取出空串，lua表中值为nil
			valueStr="nil"				
		else
#否则，两端拼上”“
			valueStr="\""${valueStr}"\"" 
		fi
#拼接完整的 Key:Value,写入lua表，这是第二级孩子的值
		catToTempLua "		\""$line"\""\ =\ ${valueStr}","  
		valueStr=""										  
	done
	num=0

#二级孩子表尾
	catToTempLua "	}"  
done


#lua表尾
catToTempLua "
}
"

#拼接CSBNodeLocalResHelper类， 写入文件
tolua_str="CSBNodeLocalResHelper = CSBNodeLocalResHelper or {}\n"
tolua_str=${tolua_str}`cat ../temp.lua`
tolua_str=${tolua_str}"\nfunction CSBNodeLocalResHelper:createLocalNode( filename,belongNode )	
	local node = UI.nodeFromCSB(filename,belongNode)
	local values = csbFileLabels[ filename ]
	for k,v in pairs(values) do
		node.k:setString(T(v))
	end
	return node
end

return CSBNodeLocalResHelper "
echo $tolua_str > ../src/slg/manager/CSBNodeLocalResHelper.lua

清除临时文件
rm ../temp.lua t1 t2
