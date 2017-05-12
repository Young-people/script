##　变量的引用
当引用一个变量时，通常最好是用双引号将变量名括起来。例如，"$variable"。这样可以防止被引用的变量值中的特殊字符（除：$、'和\）被解释为其他错误含义。  
使用双引号可以防止变量值中由多个单词组成的字符串分离。一个用双引号括起来的变量使它自身变成一个单一词组，即使它的值中包含空格。我们用一个实例来了解一下双引号在引用变量中的作用，如下所示：  
```shell
	LIST="one two three"
	for var in $LIST      #将变量LIST的值分成了3个参数传递给了for循环
	do
	  echo "$var"
	done
	one
	two
	three
	$ for var in "$LIST"    #将变量LIST的值作为一个整体传入for循环
	do
	    echo "$var"
	done
	one two three
```

##单引号
单引号的操作类似于双引号，但是它不允许引用变量，因为在单引号中字符“$”的特殊含义将会失效。每个特殊的字符，除了字符'，都将按字面含义解释。  

	$ echo {a..z}            #按字母表顺序显示a～z的字母
	a b c d e f g h i j k l m n o p q r s t u v w x y z
	$ echo {0..10}           #显示0～10的数字
	$ echo {a,b{1..3},c}
	a b1 b2 b3 c
	$ echo {1..10..2}
	1 3 5 7 9
	$ echo {0001..10..3}
	0001 0004 0007 0010
	$ echo {h..a..-3}
	h e b

##文件名匹配  

*——匹配任何字符串，包括空字符串。  
?——匹配任意单个字符。  
[…]——匹配方括号内的任意字符。  
比如，显示/etc目录下的所有配置文件：  
`$ ls /etc/*.conf`  
或是列出所有以字母a或b开头的配置文件：  
`$ ls /etc/[ab] *.conf`  
显示所有jpg文件（image1.jpg、image2.jpg..image9.jpg）：  
`$ls image?.jpg`  


##文件内容输出
cat  
Linux下还有一个tac命令，从命令的名字你可能已经想到，tac命令与cat命令相反，它将以倒序的形式（先显示文件的最后一行）显示文件的内容  
你也可以通过管道流将cat命令显示的内容输出到more命令。比如，有时你想输出一个文件的全部内容，但要慢慢地查看它： 
`$ cat README | more`  


##find

在当前目录下，查找名称为inittab的文件：  

```shell
# find . -name inittab  
-iname不区分大小写  
找出当前目录下，目录名是tmp的目录：  
$ find . -type d -name tmp  
./tmp  
找出当前目录下，文件权限是777的所有文件：
$ find . -type f -perm 0777
找出当前目录下，文件权限不是777的所有文件：
$ find . -type f ! -perm 777
找出/etc/目录下所有只读文件：
# find . -type f ! -perm /a+w
找出你账号的主目录下的所有可执行文件：
$ find ~ -type f -perm /a+x
找出/tmp目录下的.log文件并将其删除：
$ find /tmp/ -type f -name "*.log" -exec rm -f {} \;
找出当前目录下的所有空文件：
$ find . -type f -empty
找出当前目录下的所有空目录：
$ find . -type d –empty
找出/tmp目录下，所有者是root的文件和目录：
$ find /tmp/ -user root
找出/tmp目录下，用户组是developer的文件和目录：
$ find /tmp/ -group developer
找出你账号的主目录下，3天前修改的文件：
$ find ~ -type f -mtime 3
# find /etc -type f –cmin -60
找出/etc目录下，一小时以内访问过的文件：
# find /etc -type f -amin -60
找出你账号的主目录下，大小是50MB的所有文件：
$ find ~ -type f -size 50MB
找出你账号的主目录下，大于50MB小于100MB的所有文件：
$ find ~ -type f -size +50MB -size -100MB
找出你账号的主目录下，大于100MB的文件并将其删除：
$ find ~ -type f -size +100MB -exec rm –rf {} \;
```

##文本排序
```shell
	默认按字符序排序  
	使用-u选项，sort命令可以移除所有重复的行
	直接简单地使用sort命令，将得到如下结果：
	$ sort example.txt
	10
	100
	20
	35
	69
	83
	在上例中，100被直接排到了10的下面，而不是按照数字的大小排在末尾。这与sort命令的默认排序机制有关。
	使用-n选项，可以使sort命令将数字按数值的大小排序：
	$ sort -n example.txt
	10
	20
	35
	69
	83
	使用-r选项，可以使sort命令以倒序方式排序
	指定sort命令按照第二列的字符串顺序将文件内容排序：
	$ sort -t ',' -k2,2 example.txt
	def,10
	jkl,100
	abc,20
	ghi,35
	mno,69
	def,83
	上例中，-t选项用于指定列的分隔符，上例中的列分隔符是逗号“，”；-k选项用于指定进行排序的列，这里我们指定的是第二列。
	指定sort命令按照第二列的数值顺序将文件内容排序：
	$ sort -t ',' -k2n,2 example.txt
	def,10
	abc,20
	ghi,35
	mno,69
	def,83
	jkl,100
	上例逆序参数 -k2nr
```

##文本去重
```shell
	uniq命令用于移除或发现文件中重复的条目。
	现在有一个文件，其内容如下所示：
	$ cat example.txt
	aaa
	aaa
	bbb
	bbb
	bbb
	ccc
	使用uniq命令，不带有任何选项时，它将移除文件中重复的行并显示单一行：
	$ uniq example.txt 
	aaa
	bbb
	ccc
	使用-c选项，可以统计重复行出现的次数：
	$ uniq -c example.txt 
	2 aaa
	3 bbb
	1 ccc
	使用-d选项，只显示文件中有重复的行并只显示一次：
	$ uniq -d example.txt
	aaa
	bbb
	使用-D选项，与-d选项类似，但它显示文件中所有重复的行：
	$ uniq -D example.txt
	aaa
	aaa
	bbb
	bbb
	bbb
	使用-u选项，只显示文件中不重复的行：
	$ uniq -u example.txt
	ccc
	现在我们将示例文件修改成如下内容：
	$ cat example.txt
	aaa bbb
	aaa ccc
	bbb aaa
	bbb ccc
	ccc ccc
	使用-w选项，可以限制uniq命令只比较每行的前N个字符。例如，下面的实例中，限制uniq命令只比较每行的前3个字符是否重复：
	$ uniq -w 3 example.txt
	aaa bbb
	bbb aaa
	ccc ccc
	使用-s选项，可以避免uniq命令比较每行的前N个字符，即跳过每行的前N个字符，只比较后面的字符。例如，下面的实例中，避免uniq命令比较每行的前3个字符，只比较后面的字符是否重复：
	$ uniq -s 3 example.txt
	aaa bbb
	aaa ccc
	bbb aaa
	bbb ccc
	使用-f选项，可以避免uniq命令比较前N列，即跳过前N列（这里列以空格分隔），只比较后面的字符。例如，下面的实例中，避免uniq命令比较第一列的内容，只比较后面的字符是否重复：
	$ uniq -f 1 example.txt
	aaa bbb
	aaa ccc
	bbb aaa
	bbb ccc
```

#tr命令实例：替换或删除字符

	tr命令用于转换字符、删除字符和压缩重复的字符。它从标准输入读取数据并将结果输出到标准输出。
	tr命令的语法如下所示：
	$ tr [OPTION]… SET1 [SET2]
	我们首先了解一下tr命令的转换字符的功能。如果参数SET1和SET2同时指定，并且没有指定-d选项，那么tr命令将把SET1中指定的每个字符替换为SET2中相同位置的字符。
	下面这个实例用于将字符串中所有的小写字母转换为大写字母：
	$ echo linuxShell | tr abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ
	LINUXSHELL
	下面的实例同样可以将字符串中的所有小写字母转换为大写字母：
	$ echo linuxShell | tr [:lower:] [:upper:]
	LINUXSHELL
	还有一种方法可以得到和上例同样的结果：
	$ echo linuxShell | tr a-z A-Z
	LINUXSHELL
	使用tr命令转换一个文件中的内容，并将转换的结果输出到另一个文件：
	$ cat inputfile
	{linuxShell}

	$ tr '{}' '()' < inputfile > outputfile

	$ cat outputfile
	(linuxShell)
	上例中，使用tr命令将文件inputfile中的大括号转换为了小括号，并将转换的结果输出到了文件outputfile中。
	将字符串中的空格转换为制表符：
	$ echo "This is for testing" | tr [:space:] '\t'
	This   is     for     testing
	如果上例中有两个以上空格同时出现，那么tr命令将把每个空格都转换为制表符，类似如下所示：
	$ echo "This  is   for testing" | tr [:space:] '\t'
	This           is                  for    testing
	这时，我们可以使用-s选项压缩这些重复的空格：
	$ echo "This  is   for testing" | tr -s [:space:] '\t'
	This   is      for     testing
	下面我们来学习使用tr命令删除指定的字符。使用-d选项，tr命令可以删除指定的字符：
	$ echo "The Linux Shell" | tr -d a-z
	T L S
	上例中，使用tr命令删除了字符串中的所有小写字母。
	使用-d选项，删除字符串中的所有数字：
	$ echo "my username is yantaol123" | tr -d [:digit:]
	my username is yantaol
	将-c和-d选项结合使用，删除字符串中除数字以外的所有字符：
	$ echo "my username is yantaol123" | tr -cd [:digit:]
	123

#grep 搜索匹配字符串
	$ grep yantaol /etc/passwd
	会得到类似如下的输出：
	yantaol:x:12107:25:SDE-LiuYanTao:/home/yantaol:/bin/bash
	使用-i选项，可以强制grep命令忽略搜索关键字的大小写：
	使用-r选项，可以递归搜索指定目录下的所有文件：
	将-r选项与-l选项结合使用，grep命令可以只打印输出包含匹配指定模式的行的文件的名字：
	$ grep -rl yantaol /etc/
	/etc/passwd
	/etc/shadow
	默认情况下，当搜索字符串yantaol时，grep命令也会匹配yantaol123、yantaolb和liuyantaol等字符串。使用-w选项，就可以强制grep命令只匹配包含指定单词的行。比如，查找文件/etc/passwd中只包含指定单词yantaol的行
	使用-c选项，grep命令可以报告文件或文本中模式被匹配的次数：
	使用-n选项，grep命令可以显示每一个匹配的行的行号
	使用-v选项，grep命令可以输出除匹配指定模式的行以外的其他所有行：
	使用--color选项，grep命令在输出中将匹配的字符串以彩色的形式标出：
	grep -q 搜索到字符串会返回0 可以用$?判断grep命令是否搜索到字符串，作为if判断很好用

#diff 文件差异对比
	我们以如下两个文件为例，其文件内容如下：
	$ cat -n nsswitch.conf
	1  passwd:     files nis
	2  shadow:     files nis
	3  group:      files nis
	4
	5
	6  # Example - obey only what nisplus tells us...
	7  #services:  nisplus [NOTFOUND=return] files
	8  #networks:  nisplus [NOTFOUND=return] files
	9  #protocols: nisplus [NOTFOUND=return] files
	10  #rpc:      nisplus [NOTFOUND=return] files
	11  #ethers:   nisplus [NOTFOUND=return] files

	$ cat -n nsswitch.conf.org 
	1  passwd:     files
	2  shadow:     files
	3  group:      files
	4
	5  #hosts:     db files nisplus nis dns
	6  hosts:      files dns
	7
	8  # Example - obey only what nisplus tells us...
	9  #services:   nisplus [NOTFOUND=return] files
	10  #networks:  nisplus [NOTFOUND=return] files
	11  #protocols: nisplus [NOTFOUND=return] files
	12  #rpc:       nisplus [NOTFOUND=return] files
	13  #ethers:    nisplus [NOTFOUND=return] files
	简单地使用diff命令比较上述两个文件的方法如下所示：
	$ diff nsswitch.conf nsswitch.conf.org
	1,3c1,3
	< passwd:     files nis
	< shadow:     files nis
	< group:       files nis
	---
	> passwd:     files
	> shadow:     files
	> group:       files
	4a5,6
	> #hosts:     db files nisplus nis dns
	> hosts:      files dns
	7,11c9,13
	< #services:  nisplus [NOTFOUND=return] files
	< #networks:  nisplus [NOTFOUND=return] files
	< #protocols: nisplus [NOTFOUND=return] files
	< #rpc:       nisplus [NOTFOUND=return] files
	< #ethers:    nisplus [NOTFOUND=return] files
	---
	> #services:  nisplus [NOTFOUND=return] files
	> #networks:  nisplus [NOTFOUND=return] files
	> #protocols: nisplus [NOTFOUND=return] files
	> #rpc:       nisplus [NOTFOUND=return] files
	> #ethers:    nisplus [NOTFOUND=return] files
	上例中，“1,3c1,3”表示第一个文件的1～3行与第二个文件的1～3行在内容上有差别。“<”表示第一个文件的行，“>”表示第二个文件的行。“4a5,6”表示第二个文件与第一个文件相比，在第4行后多了5、6两行内容。“7,11c9,13”表示第一个文件的7～11行与第二个文件的9～13行在内容上有差别。
	你可能已经注意到，上例中的第一个文件的7～11行与第二个文件的9～13行相比，只是在“:”和“nisplus”之间多了一个空格。如果想在比较两个文件时忽略这些空格，该如何处理呢？
	使用-w选项，diff命令就将在比较两个文件时忽略这些空格：	
	使用-y选项，diff命令可以并排的格式输出两个文件的比较结果：
	$ diff -yw nsswitch.conf nsswitch.conf.org 
	passwd:     files nis                              | passwd:     files
	shadow:     files nis                              | shadow:     files
	group:      files nis                              | group:      files

	                                              > #hosts:    db files nisplus nis dns
	                                              > hosts:      files dns

	# Example - obey only what nisplus tells us...
	                            # Example - obey only what nisplus tells us...
	#services:  nisplus [NOTFOUND=return] files
	                            #services:  nisplus [NOTFOUND=return] files
	#networks:  nisplus [NOTFOUND=return] files
	                            #networks:  nisplus [NOTFOUND=return] files
	#protocols: nisplus [NOTFOUND=return] files
	                            #protocols: nisplus [NOTFOUND=return] files
	#rpc:       nisplus [NOTFOUND=return] files
	                            #rpc:       nisplus [NOTFOUND=return] files
	#ethers:    nisplus [NOTFOUND=return] files
	                            #ethers:    nisplus [NOTFOUND=return] files
	上例中，“|”表示内容有差异的行，“>”表示第二个文件中多出的行。如果是“<”，则表示第一个文件中多出的行。
	如果使用-y选项时，每行显示的内容不完整，可以与-W选项结合使用，指定并列输出格式的列宽，使每行的内容可以完整地显示：
	$ diff -yw –W 160 nsswitch.conf nsswitch.conf.org
	使用-c选项，diff命令会以上下对比的格式输出两个文件的比较结果：
	$ diff -cw nsswitch.conf nsswitch.conf.org
	*** nsswitch.conf       2013-09-24 10:09:19.000000000 +0800
	--- nsswitch.conf.org   2013-09-24 10:09:58.000000000 +0800
	***************
	*** 1,7 ****
	! passwd:     files nis
	! shadow:     files nis
	! group:      files nis


	  # Example - obey only what nisplus tells us...
	  #services:  nisplus [NOTFOUND=return] files
	--- 1,9 ----
	! passwd:     files
	! shadow:     files
	! group:      files

	+ #hosts:     db files nisplus nis dns
	+ hosts:      files dns

	  # Example - obey only what nisplus tells us...
	  #services:   nisplus [NOTFOUND=return] files
	上例中，“!”表示两个文件中内容有差别的行，“+”表示第二个文件比第一个文件多出的行。


第三章总结
----
	ls命令可以列出文件和目录的信息，包括文件类型、所有者、大小、修改日期和时间、权限等等。
	cat命令可以查看文件的内容、连接文件、创建一个或多个文件和重定向输出到终端或文件。
	more命令在你使用小的xterm窗口时，或是想不使用文本编辑器而只是简单地阅读一个文件时是很有用的。它是一个用于一次翻阅一整屏文件的过滤器。
	less命令与more命令类似，但less命令向前和向后翻页都支持，而且less命令不需要在查看前加载整个文件，即less命令查看文件更快速。当你尝试使用Vim编辑器和less打开同一个大的log文件，你会发现速度是不同的。
	head命令用于打印指定输入的开头部分内容。默认情况下，打印每个指定输入的前10行内容。
	tail命令与head命令相反，它打印指定输入的结尾部分的内容。默认情况下，它打印指定输入的最后10行内容。
	file命令用于接收一个文件作为参数，并执行某些测试以确定正确的文件类型。
	wc命令用于查看文件的行数、单词数和字符数等信息。
	find命令用于根据你指定的参数搜索和定位文件和目录的列表。find命令可以在多种情况下使用，比如你可以通过权限、用户、用户组、文件类型、日期、大小和其他可能的条件来查找文件。
	touch命令用于创建、变更和修改文件的时间戳。它是Linux操作系统的标准程序。
	mkdir命令用于创建一个新目录。
	cp命令用于将文件从一个地方复制到另一个地方。原来的文件保持不变，新文件可能保持原名或用一个不同的名字。
	ln命令用于创建软链接或硬链接。
	mv命令用于将文件和目录从一个位置移到另外一个位置。除了移动文件，mv命令还可用于修改文件或目录的名字。
	rm命令用于删除指定的文件和目录。
	chmod命令用于修改文件或目录的权限。
	chown命令用于修改文件或目录的所有者和用户组信息。
	chgrp命令与chown命令类似，但chgrp命令只用于修改文件或目录的用户组（不能修改所有者）。
	setuid（设置用户标识）是允许用户以文件所有者的权限执行一个程序的权限位。setgid（设置组标识）是允许用户以用户组成员的权限执行一个程序的权限位。
	sort命令用于将文本文件的行排序。默认情况下，sort命令是按照字符串的字母顺序排序。
	uniq命令用于移除或发现文件中重复的条目。
	tr命令用于转换字符、删除字符和压缩重复的字符。它从标准输入读取数据并将结果输出到标准输出。
	grep命令用于搜索文本或指定的文件中与指定的字符串或模式相匹配的行。
	diff命令用于比较两个文件，并找出它们之间的不同。
	hostname命令用于查看系统的主机名，或是修改系统的主机名。
	w命令用于显示登录的用户及他们当前运行的进程。who命令有与w命令类似的用途，但它的功能比w命令更强大一些。
	uptime命令用于打印系统的运行时间等信息。
	uname命令用于打印内核名称和版本、主机名等系统信息。
	date命令用于以多种格式显示日期和时间，或设置系统的日期和时间。
	id命令用于打印输出用户的uid、gid、用户名和组名等用户身份信息。

第四章总结
-----
	paste命令用于合并一个文件或多个文件中的行。
	dd命令可用于备份一个分区、DVD或是U盘的数据，转换数据文件，或是做一些简单的硬盘或CPU速度的测试。它可以通过可能的转换格式复制指定的输入文件到指定的输出。
	gzip命令用于压缩文件，以减少文件的大小，可以节省文件通过网络传输时所占的带宽。它可以指定从1～9的9个压缩级别，级别1是最快的压缩速度，但压缩率较低，而级别9是最慢的压缩速度，但压缩率最好。默认的压缩级别是6。
	bzip2命令也同样用于压缩或解压缩文件。与gzip相比，bzip2命令具有更好的压缩率，但bzip2的压缩速度比gzip稍慢。bzip2以可接受的速度提供较高的压缩率。bzip2同样有9个压缩级别，其含义与gzip的含义类似。但它的默认压缩级别是9。
	gunzip和bunzip2命令分别用于解压缩由gzip和bzip2生成的压缩包。
	tar命令是Linux系统中主要的归档工具。使用tar命令归档后生成的文件被我们称作tar包。
	mount命令用于挂载一个文件系统。挂载和卸载一个文件系统，通常都需要root账户权限。使用mount命令挂载一个文件系统时，需要目标目录（即挂载点）已存在。
	umount命令用于卸载一个文件系统或设备。在卸载指定的文件系统或设备前，要确保其没有被任何进程占用，否则会卸载失败。
	df命令用于显示文件系统的可用的磁盘空间的数量。
	du命令用于概述每个文件和目录所占磁盘空间的大小。
	cron是执行定时计划任务的守护进程。cron进程会周期性地在目录/var/spool/cron/crontabs/下搜索由crontab命令生成的（也可能由用户使用文本编辑器生成，但建议使用crontab命令）定时计划任务文件（定时计划任务文件以创建此任务的账户名命名），并将找到的这些定时计划任务载入内存。
	crontab命令用于创建、修改、删除和查看定时计划任务。
	at命令用于安排一个任务在指定的时间运行。at命令可以从标准输入读入命令，也可以从指定的文件中读入，然后在指定的时间运行这些命令。
	字符“&”用于将命令放在后台运行。它是Bash内置的用于并行处理进程的一个控制操作符。
	nohup命令可以防止当你退出系统时，在后台运行的进程被终结。它能让你运行的命令或脚本在你退出系统后继续在后台运行。
