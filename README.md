# wlst-generic
WebLogic generic and standalone wlst cli with Jython 2.7.1

## 【特点】
- 封装了2017年7月1日发布的Jython 2.7.1
- 独立于WebLogic软件运行, 使用该程序包无需安装WebLogic软件
- 原有的wlst/jython脚本几乎不用修改代码(99%不变)，还是熟悉的执行方式
- 支持wlst命令行模式，还是熟悉的命令行界面
- 目录结构布局清晰, 方便Jython版本更新及存放Python第三方Packages


## 【使用方法】
- 进入Release页面，下载wlst-generic.<版本号>.tar.gz
- 解压并进入wlst-generic/bin目录
- 使用vi编辑wlst_generic.sh脚本，修改JAVA_HOME=""为JAVA_HOME变量指定具体的JDK 1.7版本软件路径 , 例如: JAVA_HOME="/weblogic/jdk170_80"
- 执行脚本
进入WLST命令行模式:  ./wlst_generic.sh
执行wlst/jython脚本:  ./wlst_generic.sh  /path/to/xxx.py

ps.时间关系, 没搞Windows版的执行脚本, 感兴趣的朋友可以自行添加.

## 【执行样例】
![WebLogic域中Servers列表](https://github.com/tdy218/public-resources/blob/master/img/WLS_ServerList_Table.jpeg)

## 【问题反馈】
- 本Project的Issues页面 或 发邮件至作者E-mail <tdy218@gmail.com>
