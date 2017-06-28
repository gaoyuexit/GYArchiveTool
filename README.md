### swift 打包工具

#### 1. 安装 fir-cli:  `$ gem install fir-cli` [详细](https://github.com/FIRHQ/fir-cli/blob/master/doc/install.md) 

#### 2. 登陆fir账号获取token, 并配置好adhoc证书 

-  命令行登陆 fir (eg): ` $ fir login XXXXXXXXXXX(token)`
-  验证登陆账号:` $ fir me`

#### 3. 将`ArchiveTool`可执行文件拷贝到`/usr/local/bin`

- eg: `cp ArchiveTool /usr/local/bin` 


#### 4. 进入到项目根目录(xx.xcworkspace所在文件夹)

- `$ ArchiveTool -h` 调出帮助命令

- 默认build号递增,   反之: `$ ArchiveTool -no-v`或`$ ArchiveTool -no-version`
- 默认上传到fir, 反之: `$ ArchiveTool -no-u`或`$ ArchiveTool -no-upload`
- 默认上传到fir没有填写信息  如若填写 则: `$ ArchiveTool -log "v1.1.0 测试服务器"`
- 默认上传完fir后, 会提交一个commit, 反之: `$ ArchiveTool -no-c`或`$ ArchiveTool -no-commit`


> 完成步骤1,2,3之后, 以后每次打包只需要进行第4步骤
> 我们公司的一般的使用基本上为: `$ ArchiveTool -log "v1.1.0 测试服务器"`
> 其余用户使用为`$ ArchiveTool -i "xxx项目工程中info.plist的路径" -log "v1.1.0 测试服务器"`
> 打包输入的ipa在项目根目录的上一级会出现一个docs文件夹, 里面包含打包形成的`ipa`和`xcarchive`文件


v 1.0.2 TODO:  

- 加入编译时间等输出
- 加入`AppStore`包的支持
- 使用xcodebuild -showBuildSettings 自动找到info.plist路径, 不用用户直接输入了, 去掉 -i 参数, 使其余用户也可以直接`$ ArchiveTool -log "v1.1.0 测试服务器"`进行简单操作


