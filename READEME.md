#记录接触脚本以来用到的脚本
#主要是为了记录其中用到的语法，脚本没有上下文环境没有什么用


文件|备注
--|--
createCocosLuaFile.sh|根据lua的格式，传入文件名，父类，路径，创建一个符合坦克工程要求的lua文件
packPng.sh|将换图文件夹中的图片替换到为texturepacker使用而创建的文件夹中，名称匹配替换，然后打包图片
createFileNameToKey.sh|说明见文件中，用到了awk,grep查找字符串，uniq去重，创建map和使用
localizationCsb.sh|文件注释