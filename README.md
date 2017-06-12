### swift 打包工具

#### 1. 安装 fir-cli:  `$ gem install fir-cli` [详细](https://github.com/FIRHQ/fir-cli/blob/master/doc/install.md) 

#### 2. 登陆fir账号获取token, 并配置好adhoc证书 

-  命令行登陆 fir (eg): ` $ fir login XXXXXXXXXXX(token)`
-  验证登陆账号:` $ fir me`

#### 3. 将`ArchiveTool`可执行文件拷贝到`/usr/local/bin`

- eg: `cp ArchiveTool /usr/local/bin` 

#### 4. 进入到项目根目录(xx.xcworkspace所在文件夹, 保证项目在develop分支)下, 执行命令`$ ArchiveTool`

- `$ ArchiveTool -h` 调出帮助命令


- 默认build号递增,   反之: `$ ArchiveTool -v "false"`
- 默认上传到fir, 反之: `$ ArchiveTool -u "false" `
- 默认上传到fir没有填写信息  如若填写 则: `$ ArchiveTool -log "v1.1.0 测试服务器"`
- 默认上传完fir后, 在develop分支上提交一个commit, 反之: `ArchiveTool -c "false"`

> 一般的使用基本上为: `$ ArchiveTool -log "v1.1.0 测试服务器"`

v 1.0.1 TODO:  

- 将 `$ ArchiveTool -v "false"` 改为 `$ ArchiveTool -no-v` 一类的命令
- 加入编译时间等输出
- 加入`AppStore`包的支持



