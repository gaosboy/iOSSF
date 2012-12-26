SegmentFault
=============

SegmentFault为开发者提供高效的解决问题平台，网址是：http://segmentfault.com/ 或 http://sf.gg/。
这个工程是SegmentFault的iOS客户端，完全开源。
架构不断进化ing

特点
=============

SF iOS App使用URLManager，通过URL Scheme的方式管理ViewController，做到VC松耦合，不依赖。
使用Kache作为缓存控件，用来缓存网络数据。
以上两个控件是该项目自主研发，旨在打造轻量、好用的iOS开发控件。

开发
=============
这个工程使用Submodule管理所有第三方控件。目录结构如下：

####[iOSSF](https://github.com/gaosboy/iOSSF)/SegmentFault/Support/
#####|__ [AFNetworking](https://github.com/AFNetworking/AFNetworking)
#####|__ [JSONKit](https://github.com/johnezang/JSONKit)
#####|__ [Kache](https://github.com/gaosboy/kache) （自主开发的缓存控件）
#####|__ [SlimeRefresh](https://github.com/dbsGen/SlimeRefresh)
#####|__ [URLManager](https://github.com/gaosboy/urlmanager) （自主开发的NavigationViewController，用URL Scheme管理ViewControllers）

建议你使用[SourceTree](http://itun.es/cn/rFBIy.m)来管理工程。使用SourceTree Clone一个工程会自动加载Submodule。

如果你使用命令行Clone工程，请运行如下命令，加载Submodule

### # git clone https://github.com/gaosboy/iOSSF.git
```
Cloning into 'iOSSF'...
remote: Counting objects: 519, done.
remote: Compressing objects: 100% (376/376), done.
remote: Total 519 (delta 272), reused 367 (delta 120)
Receiving objects: 100% (519/519), 364.74 KiB | 180 KiB/s, done.
Resolving deltas: 100% (272/272), done.
```

### # cd iOSSF

### # git submodule init
```
Submodule 'SegmentFault/Support/AFNetworking' (https://github.com/AFNetworking/AFNetworking.git) registered for path 'SegmentFault/Support/AFNetworking'
Submodule 'SegmentFault/Support/JSONKit' (https://github.com/johnezang/JSONKit.git) registered for path 'SegmentFault/Support/JSONKit'
Submodule 'SegmentFault/Support/Kache' (https://github.com/gaosboy/kache.git) registered for path 'SegmentFault/Support/Kache'
Submodule 'SegmentFault/Support/SlimeRefresh' (https://github.com/dbsGen/SlimeRefresh.git) registered for path 'SegmentFault/Support/SlimeRefresh'
Submodule 'SegmentFault/Support/URLManager' (https://github.com/gaosboy/urlmanager.git) registered for path 'SegmentFault/Support/URLManager'
```
### # git submodule update
```
Cloning into 'SegmentFault/Support/AFNetworking'...
remote: Counting objects: 4796, done.
remote: Compressing objects: 100% (1613/1613), done.
remote: Total 4796 (delta 3278), reused 4541 (delta 3149)
Receiving objects: 100% (4796/4796), 1.34 MiB | 12 KiB/s, done.
Resolving deltas: 100% (3278/3278), done.
Submodule path 'SegmentFault/Support/AFNetworking': checked out 'a146a3bf66aa2b6bfee1f38fe24f5d3cd37de65a'
Cloning into 'SegmentFault/Support/JSONKit'...
remote: Counting objects: 263, done.
remote: Compressing objects: 100% (147/147), done.
remote: Total 263 (delta 123), reused 244 (delta 114)
Receiving objects: 100% (263/263), 160.79 KiB | 13 KiB/s, done.
Resolving deltas: 100% (123/123), done.
Submodule path 'SegmentFault/Support/JSONKit': checked out '82157634ca0ca5b6a4a67a194dd11f15d9b72835'
Cloning into 'SegmentFault/Support/Kache'...
remote: Counting objects: 39, done.
remote: Compressing objects: 100% (30/30), done.
remote: Total 39 (delta 7), reused 32 (delta 6)
Unpacking objects: 100% (39/39), done.
Submodule path 'SegmentFault/Support/Kache': checked out '926b791ca2c6832070c64632acb92ce76ddd8fc8'
Cloning into 'SegmentFault/Support/SlimeRefresh'...
remote: Counting objects: 541, done.
remote: Compressing objects: 100% (325/325), done.
remote: Total 541 (delta 245), reused 506 (delta 210)
Receiving objects: 100% (541/541), 394.46 KiB | 9 KiB/s, done.
Resolving deltas: 100% (245/245), done.
Submodule path 'SegmentFault/Support/SlimeRefresh': checked out '7b51e1b88551d2a9eb4cea6f4003cf3511091871'
Cloning into 'SegmentFault/Support/URLManager'...
remote: Counting objects: 69, done.
remote: Compressing objects: 100% (49/49), done.
remote: Total 69 (delta 28), reused 51 (delta 16)
Unpacking objects: 100% (69/69), done.
Submodule path 'SegmentFault/Support/URLManager': checked out '64319dd7c6f3e26917981025cc0088bd87d9bf9d'
```
