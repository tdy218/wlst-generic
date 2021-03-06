# wlst-generic
WebLogic generic and standalone wlst cli with Jython 2.7.1

## 【特点】
- 封装了2017年7月1日发布的Jython 2.7.1
- 封装了Oralce JRE 1.7 x86-64bit软件，使用该项目包时，无需安装JDK/JRE（目前包含的是Linux环境的）
- 独立于WebLogic软件运行, 使用该程序包无需安装WebLogic软件
- 原有的wlst/jython脚本几乎不用修改代码(99%不变)，还是熟悉的执行方式
- 支持wlst命令行模式，还是熟悉的命令行界面
- 从v1.1版本开始，支持t3s协议连接，支持pip和easy_install这两个包管理工具，可以在联网的环境下从Python的公共资源库PyPI站点下载和安装包

## 【目录结构】  
<img src="https://github.com/tdy218/public-resources/blob/master/img/project_tree.jpeg" alt="Project tree image" width="20%" height="20%">

## 【使用方法】
### 【WLST命令行及Jython脚本执行方法】
- 进入[Release](https://github.com/tdy218/wlst-generic/releases "Release")页面，下载wlst-generic.<版本号>.tar.gz
- 解压并进入wlst-generic/bin目录
- 执行脚本  
进入WLST命令行模式:  ./wlst_generic.sh  
执行wlst/jython脚本:  ./wlst_generic.sh  /path/to/xxx.py

### 【包安装工具使用方法 - 已连接互联网】 
- 进入wlst-generic/tools目录，执行pip或easy_install安装包（首次执行较慢，约2-3分钟才有反应）    
./pip install <包名>     #例如: ./pip install openpyxl  
./easy_install <包名>    #例如: ./easy_install openpyxl    

**pip安装第三方包样例**    
<img src="https://github.com/tdy218/public-resources/blob/master/img/pip_install_packages.jpeg" alt="Package install by pip image" width="60%" height="30%">

### 【包安装工具使用方法 - 未连接互联网】 
- 将你的Jython程序中需要的包手工拷贝至wlst-generic/jython/Lib/site-packages目录下即可，无需修改配置或脚本文件.   
ps.如果是在联网的情况下已经使用pip或easy_install安装了一些第三方的包（默认自动安装在wlst-generic/jython/Lib/site-packages目录下），则需要用该程序包部署在生产环境执行Jython脚本时，则直接将wlst-generic目录重新压缩打包，拷贝至生产环境即可（绿色无依赖）。

### 【t3s协议连接配置和使用方法】
- 将你要连接的域使用的SSL根证书（xxx.jks，也支持其他与JDK兼容的SSL证书格式）拷贝至wlst-generic/security/cacerts目录下     
例如：域开启"域管理端口(Administration Port)"之后，再用WLST连接域时，就需要用到t3s协议了。如果使用了WebLogic自带的DemoTrust证书，则需要将$WL_HOME/server/lib/DemoTrust.jks拷贝至wlst-generic/security/cacerts目录下.  
- 进入wlst-generic/bin目录    
编辑wlst_generic.sh脚本，修改WLST_SECURE_ROOT_CERTIFICATE变量值，指向你刚拷贝到wlst-generic/security/cacerts目录下的SSL根证书（默认指向10.3.6的DemoTrust，请根据实际情况改为实际的值）.    
```
export WLST_SECURE_ROOT_CERTIFICATE="${WORKING_DIR}/security/cacerts/WLS11gDemoTrust.jks"  
```      

ps.1. 如果你要连接的域的WebLogic版本是12.1.2及以上版本(SSL证书的实现方式从Certicom-based变为JSSE-based，所以脚本中需要手工开启JSSE证书的支持)，则还需要将WLS_SSL_ENABLE_JSSE和WLS_SECURITY_ENABLE_JSSE这两个变量值改为true  
```
export WLS_SSL_ENABLE_JSSE="false"   #改为true  
export WLS_SECURITY_ENABLE_JSSE="false"   #改为true     
```
ps.2. 如果你使用的SSL根证书格式不是JKS，请修改-Dweblogic.security.CustomTrustKeyStoreType属性参数值为你的根证书格式，其他地方不需要改（无论你使用的是DemoTrust还是CustomTrust，都不需要修改-Dweblogic.security.TrustKeyStore=CustomTrust，保持默认即可）  

**t3s连接样例**     
- WebLogic 10.3.6版本
<img src="https://github.com/tdy218/public-resources/blob/master/img/t3s_connect_1036.jpeg" alt="wls 10.3.6 t3s connection image" width="80%" height="80%">

- WebLogic 12.1.3版本
<img src="https://github.com/tdy218/public-resources/blob/master/img/t3s_connect_1213.jpeg" alt="wls 12.1.3 t3s connection image" width="80%" height="80%">   

ps.3. 时间关系, 没搞Windows版的执行脚本, 感兴趣的朋友可以自行添加.

## 【使用该Project并引入第三方Package的执行样例】  
<img src="https://github.com/tdy218/public-resources/blob/master/img/WLS_ServerList_Table.jpeg" alt="WebLogic域中Servers列表" width="80%" height="80%">

## 【高级用法】
- 自助问题诊断方法   
wlst-generic/bin/wlst_generic.sh脚本文件中预留了WLST连接及t3s连接的多个debug参数，默认都是关闭的，如果你在使用过程中遇到了问题，想知道更多的诊断信息，则请将这些debug参数值改为true  
WSLT连接debug参数: -Dwlst.debug.init=false   #需要使用时，将其置为true  
t3s连接debug参数: -Dssl.debug=false 和 -Dweblogic.StdoutDebugEnabled=false #需要使用时，将其置为true  
- 支持更多操作系统平台的方法   
该Project中与平台相关的几处地方:     
wlst-generic/bin/wlst_generic.sh   
wlst-generic/jre    
wlst-generic/tools   
请同步修改.  

## 【问题反馈】
- 本Project的Issues页面 或 发邮件至作者E-mail <tdy218@gmail.com>
