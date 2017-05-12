#!/bin/zsh

# $ cat /Users/Wangkun/Desktop/new.txt
# slg/ui/slg_warehouse_01.csd:           Name="Text_1" LabelText="临时仓库"
# slg/ui/slg_warehouse_01.csd:           Name="lbl_money_text" LabelText="空闲中，点击箱子开启"
# slg/ui/slg_warehouse_02.csd:           Name="lbl_desc" LabelText="00:00:00"
# slg/ui/slg_warehouse_02.csd:               Name="lbl_left_lebel" LabelText="快速开启"
# slg/ui/slg_warehouse_02.csd:               Name="lbl_money" LabelText="00000"

# $cat /Users/Wangkun/work/tank_work/tank/src/Res.lua
# Res.FileNames.res_ui_warehouse2_warehouse_choose_csb = "res/ui/warehouse2/warehouse_choose.csb"
# Res.FileNames.res_ui_warehouse2_warehouse_home_csb = "res/ui/warehouse2/warehouse_home.csb"
# Res.FileNames.res_ui_warehouse2_warehouse_sell_csb = "res/ui/warehouse2/warehouse_sell.csb"
# Res.FileNames.res_ui_warehouse2_warehouse_sell_02_csb = "res/ui/warehouse2/warehouse_sell_02.csb"
# map类型必须在4.2版本后才能使用，这里zsh的版本ok
# 该脚本主要功能是从new.txt中只取文件的名字不带后缀，然后去Res.lua中查找对应的key-value的值，吧名字和该key存入map中，方便查询使用
# #slg/battle_field/slg_battle_field_prop.csd:

declare -A map  # map

function getFileNameFormFilePath()
{
		local str=$1
		str=${str##*/}
		str=${str%.*}
		findStr=`grep $str /Users/Wangkun/work/tank_work/tank/src/Res.lua`
		findStr=${findStr%%\ *}
		map[$str]=$findStr
}
	

for line in `cat /Users/Wangkun/Desktop/new.txt|awk -F ':' '{print $1}'|uniq`; do
	getFileNameFormFilePath $line
done

echo ${map[slg_black_market_03]} #-> Res.FileNames.res_ui_slg_ui_slg_black_market_03_csb