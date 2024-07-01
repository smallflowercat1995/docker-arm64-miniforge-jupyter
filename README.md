# docker-arm64-miniforge-jupyter
在 arm64v8 上使用的 miniforge Jupyter docker构建材料

## dockerhub
镜像仓库链接：[https://hub.docker.com/r/smallflowercat1995/alpine-miniforge-jupyter](https://hub.docker.com/r/smallflowercat1995/alpine-miniforge-jupyter)  
[![GitHub Workflow update Status](https://github.com/smallflowercat1995/docker-arm64-miniforge-jupyter/actions/workflows/actions.yml/badge.svg)](https://github.com/smallflowercat1995/docker-arm64-miniforge-jupyter/actions/workflows/actions.yml)[![GitHub Workflow dockerbuild Status](https://github.com/smallflowercat1995/docker-arm64-miniforge-jupyter/actions/workflows/docker-image.yml/badge.svg)](https://github.com/smallflowercat1995/docker-arm64-miniforge-jupyter/actions/workflows/docker-image.yml)![Watchers](https://img.shields.io/github/watchers/smallflowercat1995/docker-arm64-miniforge-jupyter) ![Stars](https://img.shields.io/github/stars/smallflowercat1995/docker-arm64-miniforge-jupyter) ![Forks](https://img.shields.io/github/forks/smallflowercat1995/docker-arm64-miniforge-jupyter) ![Vistors](https://visitor-badge.laobi.icu/badge?page_id=smallflowercat1995.docker-arm64-miniforge-jupyter) ![LICENSE](https://img.shields.io/badge/license-CC%20BY--SA%204.0-green.svg)
<a href="https://star-history.com/#smallflowercat1995/docker-arm64-miniforge-jupyter&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=smallflowercat1995/docker-arm64-miniforge-jupyter&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=smallflowercat1995/docker-arm64-miniforge-jupyter&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=smallflowercat1995/docker-arm64-miniforge-jupyter&type=Date" />
  </picture>
</a>

## 描述
1.为了实现 actions workflow 自动化更新 ijava 和 OpenJDk ，需要添加 `GITHUB_TOKEN` 环境变量，这个是访问 GitHub API 的令牌，可以在 GitHub 主页，点击个人头像，Settings -> Developer settings -> Personal access tokens ，设置名字为 GITHUB_TOKEN 接着要勾选权限，勾选repo、admin:repo_hook和workflow即可，最后点击Generate token，如图所示  
![account_token](https://github.com/smallflowercat1995/docker-arm64-miniforge-jupyter/assets/144557489/c203c3cf-f8c9-4bbe-97f1-f09c36f4c968) 

2.赋予 actions[bot] 读/写仓库权限 -> Settings -> Actions -> General -> Workflow Permissions -> Read and write permissions -> save，如图所示  
![repository_authorized](https://github.com/smallflowercat1995/docker-arm64-miniforge-jupyter/assets/144557489/499bd62a-a814-408d-a1ae-dcd7d6e29e7d)   

3.添加 hub.docker.com 仓库账号 DOCKER_USERNAME 在 GitHub 仓库页 -> Settings -> Secrets -> actions -> New repository secret   
4.添加 hub.docker.com 仓库密码 DOCKER_PASSWORD 在 GitHub 仓库页 -> Settings -> Secrets -> actions -> New repository secret  
5.以上流程如图所示  
![docker](https://github.com/smallflowercat1995/docker-arm64-miniforge-jupyter/assets/144557489/5dc1b446-6516-424b-9fdc-46b4a24ff7fe)  

6.转到 Actions  

    -> update ijava OpenJDK and miniforge 并且启动 workflow，实现自动化下载 ijava 、 OpenJDK 和 miniforge 文件   
    -> Clean Git Large Files 并且启动 workflow，实现自动化清理 .git 目录大文件记录  
    -> Docker Image CI 并且启动 workflow，实现自动化构建镜像并推送云端  
    -> Remove Old Workflow Runs 并且启动 workflow，实现自动化清理 workflow 并保留最后三个  
    
7.这是包含了 miniforge 和 jupyter 的 docker 构建材料  
8.主要目的是为了使用 jupyter 本来没想这么复杂，我就是觉得 miniforge 好，为了自己的追求，只能辛苦一下  
9.以下是思路：    
  * 先构建 miniforge 配置最新的 python 环境并安装 jupyter 然后维持其运行，这样容器就不会自己停止，实在太慢，我都哭了 >_<  

10.目录结构：  

      .                                                       
      ├── Dockerfile                                         # 这个是 构建 miniforge+jupyter 的 Dockerfile 配置文件  
      ├── README.md                                          # 这个是 描述 文件  
      ├── docker-compose.yml                                 # # 这个是构建 miniforge+jupyter 的 docker-compose.yml 配置文件  
      ├── package                                            # 这个是构建 miniforge+jupyter 的脚本文件材料所在目录   
      │   ├── glibc-2.39-r0.apk                              # 这个是构建 glibc 包     
      │   ├── glibc-bin-2.39-r0.apk                          # 这个是构建 glibc 的 bin 包     
      │   ├── glibc-i18n-2.39-r0.apk                         # 这个是构建 glibc 的 i18n 包     
      │   ├── smallflowercat199508@gmail.com-660c0ab9.rsa.pub# 这个是构建 glibc 的公钥    
      │   ├── OpenJDK-jdk_alpine-linux_hotspot.tar.gz.00     # 这个是构建依赖 OpenJDK-jdk_alpine-linux_hotspot.tar.gz.00 拆分包      
      │   ├── OpenJDK-jdk_alpine-linux_hotspot.tar.gz.01     # 这个是构建依赖 OpenJDK-jdk_alpine-linux_hotspot.tar.gz.01 拆分包  
      │   ├── OpenJDK-jdk_alpine-linux_hotspot.tar.gz.02     # 这个是构建依赖 OpenJDK-jdk_alpine-linux_hotspot.tar.gz.02 拆分包  
      │   ├── OpenJDK-jdk_alpine-linux_hotspot.tar.gz.03     # 这个是构建依赖 OpenJDK-jdk_alpine-linux_hotspot.tar.gz.03 拆分包  
      │   ├── OpenJDK-jdk_alpine-linux_hotspot.tar.gz.04     # 这个是构建依赖 OpenJDK-jdk_alpine-linux_hotspot.tar.gz.04 拆分包  
      │   ├── Mambaforge-24.1.2-0-Linux-aarch64.sh.tar.xz.00 # 这个是构建依赖 Mambaforge-24.1.2-0-Linux-aarch64.sh.tar.xz.00 拆分包  
      │   ├── Mambaforge-24.1.2-0-Linux-aarch64.sh.tar.xz.01 # 这个是构建依赖 Mambaforge-24.1.2-0-Linux-aarch64.sh.tar.xz.01 拆分包  
      │   ├── ijava-1.3.0.zip                                # 这个是支持 java环境的内核文件  
      │   ├── init.sh                                        # 这个是初始化 bash shell 环境脚本文件  
      │   ├── install.sh                                     # 这个是构建 miniforge+jupyter 镜像的时候在容器内执行流程的脚本   
      │   ├── requirements.txt                               # 这个是 python 安装依赖库文件  
      │   └── run_jupyter                                    # 这个是启动 jupyter 的脚本无密码环境，第一次执行初始密码123456    
      └── update.sh                                          # 这个是 actions 所需要的自动更新 openjdk 和 ijava 脚本  

## 构建命令
### 编译 miniforge 环境并打包到 docker-arm64-debian-miniforge-jupyter/install-jupyter/package 中
    # clone 项目
    git clone https://github.com/smallflowercat1995/docker-arm64-miniforge-jupyter.git
    
    # 进入目录
    cd docker-arm64-miniforge-jupyter/
    
    # 无缓存构建
    docker build --no-cache --platform "linux/arm64/v8" -f Dockerfile -t smallflowercat1995/alpine-miniforge-jupyter:arm64v8 . ; docker builder prune -fa ; docker rmi $(docker images -qaf dangling=true)  
    # 或者这么构建也可以二选一
    docker-compose build --no-cache ; docker builder prune -fa ; docker rmi $(docker images -qaf dangling=true)
    
    # 构建完成后修改 docker-compose.yml 后启动享用，默认密码 123456
    # 初始密码修改环境变量字段 PASSWORD 详细请看 docker-compose.yml
    # 端口默认 8888
    docker-compose up -d --force-recreate
    
    # 也可以查看日志看看有没有问题 ,如果失败了就再重新尝试看看只要最后不报错就好   
    docker-compose logs -f

## 默认密码以及修改
    # 别担心我料到这一点了，毕竟我自己还要用呢
    # 首先访问 http://[主机IP]:8888 输入默认密码 123456
    # 然后如图打开终端 在终端内执行密码修改指令 需输入两次 密码不会显示属于正常现象 密码配置文件会保存到容器内的 $HOME/.jupyter/jupyter_server_config.json 
    jupyter-lab password
   ![dapj0](https://github.com/smallflowercat1995/docker-arm64-miniforge-jupyter/assets/144557489/f1cbc755-879f-4f8b-b896-b1419272b035)
   ![5](https://github.com/smallflowercat1995/docker-arm64-miniforge-jupyter/assets/144557489/352c47d3-d0ff-4241-8c4f-31871a694c00)

## 修改新增
    # 将在线克隆的方式注释了，太卡了，卡哭我了，哭了一晚上 >_< 呜呜呜
    # actions 自动获取 openjdk 和 ijava 内核文件
    # update.sh 脚本拆分 openjdk 包
    # 已经将树莓派4B卖了，性能还是不够用
    # 可是项目不管也不行，索性用 github 自带 action 构建镜像提交到 hub.docker.com 仓库即时更新镜像

# 关于支持 alpine glibc 编译包
## 编译 alpine arm64v8 的 glibc 包
    # 设备 CPU 架构 arm64v8 
    # 系统环境 alpine
      # MAINTAINER smallflowercat1995 <smallflowercat1995@hotmail.com>
      # 构建 arm64 glibc https://github.com/ljfranklin/docker-glibc-builder.git
      git clone "https://github.com/ljfranklin/docker-glibc-builder.git" --branch Jingzhao123-EnableArm64Images
      
      # 检查最新版本 glibc 源码 https://mirrors.kernel.org/gnu/libc/ 为 2.39 版本的 tar.gz
      cd docker-glibc-builder
      
      # LABEL MAINTAINER="smallflowercat1995 <smallflowercat1995@hotmail.com>"
      # 修改 Dockerfile 中的 alpine:3.9.2 为 --platform="linux/arm64/v8" alpine:latest
      # 删除 Dockerfile 中的 ARG IMAGEARCH
      # 修改 Dockerfile 中的 ${IMAGEARCH}ubuntu:20.04 为 --platform="linux/arm64/v8" ubuntu:latest
      # 修改 Dockerfile 中的 GLIBC_VERSION 为 2.39
      nano Dockerfile
      
      # 无代理运行 docker 构建镜像
      docker build --no-cache --platform "linux/arm64/v8" -f Dockerfile -t smallflowercat1995/glibc-builder:arm64v8-2.39 . --build-arg QEMUVERSION="v7.2.0-1" --build-arg QEMUARCH="aarch64" ; docker builder prune -fa ; docker rmi $(docker images -qaf dangling=true)
      # 代理运行 docker 构建镜像请自定义代理ip：192.168.255.140 http/https port：7893 socks port：7893
      export IP=192.168.255.140 H_P=7893 S_P=7893 ; docker build --no-cache --platform "linux/arm64/v8" -f Dockerfile -t smallflowercat1995/glibc-builder:arm64v8-2.39 . --build-arg QEMUVERSION="7.2.0-1" --build-arg QEMUARCH="aarch64" --build-arg http_proxy=http://${IP}:${H_P} --build-arg https_proxy=http://${IP}:${H_P} --build-arg all_proxy=socks5://${IP}:${S_P} ; docker builder prune -fa ; docker rmi $(docker images -qaf dangling=true)
      
      # 无代理运行 docker 镜像输出 glibc-bin-2.39-0-aarch64.tar.gz
      #docker run --platform "linux/arm64/v8" --rm -e "GLIBC_VERSION=2.39" -e "STDOUT=1" smallflowercat1995/glibc-builder:arm64v8-2.39 > glibc-bin-2.39-0-aarch64.tar.gz
      # 代理运行 docker 镜像输出 glibc-bin-2.39-0-aarch64.tar.gz请自定义代理ip：192.168.255.140 http/https port：7893 socks port：7893
      export IP=192.168.255.140 H_P=7893 S_P=7893 ; docker run --platform "linux/arm64/v8" --rm -e "GLIBC_VERSION=2.39" -e "STDOUT=1" -e "http_proxy=http://${IP}:${H_P}" -e "https_proxy=http://${IP}:${H_P}" -e "all_proxy=socks5://${IP}:${S_P}" smallflowercat1995/glibc-builder:arm64v8-2.39 > glibc-bin-2.39-0-aarch64.tar.gz
      
      # 赋权
      chmod -v +x glibc-bin-2.39-0-aarch64.tar.gz
      
      cd -
      
      # clone alpine-pkg-glibc 构建项目 https://github.com/ljfranklin/alpine-pkg-glibc.git
      git clone "https://github.com/ljfranklin/alpine-pkg-glibc.git" --branch arm64
      # 复制文件到项目目录
      cp -fv docker-glibc-builder/glibc-bin-2.39-0-aarch64.tar.gz alpine-pkg-glibc/
      cd alpine-pkg-glibc
      
      # 过滤 aarch64 文件
      tar -tvf glibc-bin-2.39-0-aarch64.tar.gz | grep ld-linux-
          ```显示内容得到 ld-linux-aarch64.so.1
          -rwxr-xr-x root/root   1144184 2024-04-02 16:02 usr/glibc-compat/lib/ld-linux-aarch64.so.1
          ```
      
      # MAINTAINER smallflowercat1995 <smallflowercat1995@hotmail.com>
      # 修改 APKBUILD 中的 pkgver="2.30" 为 pkgver="2.39"
      # 修改 APKBUILD 中的 source="https://github.com/Rjerk/docker-glibc-builder/releases/download/$pkgver-$_pkgrel/glibc-bin-$pkgver-$_pkgrel-aarch64.tar.gz 为 source="glibc-bin-$pkgver-$_pkgrel-aarch64.tar.gz
      nano APKBUILD
      
      # alpine 包构建搭建环境
      sudo apk add -q --no-cache alpine-sdk abuild-rootbld git
      
      # 配置 用户名 邮箱
      git config --global user.name "smallflowercat1995"
      git config --global user.email "smallflowercat199508@gmail.com"
      
      # 创建alpine构建包公钥
      abuild-keygen -a -i
      
      # 校验写入 sha512sum 到 APKBUILD 文件
      abuild checksum
      # 打包构建apk
      abuild -r
      
      # 如果没问题的话输出包会在 $HOME/packages/$USER/aarch64 路径
      ls -al $HOME/packages/$USER/aarch64
      cd $HOME/packages/$USER/aarch64

      # 检查包内公钥名 smallflowercat199508@gmail.com-660c0ab9.rsa.pub
      RSA_PUB=$(tar tvf APKINDEX.tar.gz | grep rsa | sed 's;.SIGN.RSA.;;g' | awk '{print $6}')
      tar tvf APKINDEX.tar.gz | grep rsa | sed 's;.SIGN.RSA.;;g' | awk '{print $6}'
          ```输出打包使用的公钥名 smallflowercat199508@gmail.com-660c0ab9.rsa.pub
          smallflowercat199508@gmail.com-660c0ab9.rsa.pub
          ```
  
      # 复制公钥到当前目录用于在其他设备安装使用
      cp -fv $HOME/.abuild/${RSA_PUB} $HOME/packages/$USER/aarch64/
      
      # 无代理方式在其它 alpine arm64v8 容器上安装 glibc 
      docker create --rm --name "alpine-test" --platform "linux/arm64/v8" -it alpine:latest
      # 代理方式在其它 alpine arm64v8 容器上安装 glibc请自定义代理ip：192.168.255.140 http/https port：7893 socks port：7893
      export IP=192.168.255.140 H_P=7893 S_P=7893 ; docker create --rm --name "alpine-test" --platform "linux/arm64/v8" -it -e "http_proxy=http://${IP}:${H_P}" -e "https_proxy=http://${IP}:${H_P}" -e "all_proxy=socks5://${IP}:${S_P}" alpine:latest
      
      # 假设 aarch64 文件夹已经复制到其他 alpine arm64v8 设备 $HOME/ 目录中
      docker cp $HOME/packages/$USER/aarch64 alpine-test:/root/
      
      # 启动测试容器
      docker start -i "alpine-test"
      cd $HOME/aarch64
      RSA_PUB=$(tar tvf APKINDEX.tar.gz | grep rsa | sed 's;.SIGN.RSA.;;g' | awk '{print $6}')
      # 先将公钥写入
      cp -fv $HOME/aarch64/${RSA_PUB} /etc/apk/keys/${RSA_PUB}
      
      # 安装编译好的包
      apk add -q --force-overwrite -q --no-cache glibc-2.39-r0.apk glibc-bin-2.39-r0.apk glibc-i18n-2.39-r0.apk
      
      # 修复一下
      apk fix --allow-untrusted --force-overwrite -q --no-cache
    
      # 删除公钥
      rm -fv /etc/apk/keys/${RSA_PUB}
      
      # 测试，如果没报错，应该就能用 glibc 了
      /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true
      echo "export LANG=$LANG" > /etc/profile.d/locale.sh
      
      cd -
      
      # 移除
      rm -rfv $HOME/aarch64

## 编译 alpine amd64 的 glibc 包
    # 设备 CPU 架构 amd64 
    # 系统环境 debian
        # MAINTAINER smallflowercat1995 <smallflowercat1995@hotmail.com>
        # 构建 amd64 glibc https://github.com/sgerrand/docker-glibc-builder.git
        git clone "https://github.com/sgerrand/docker-glibc-builder.git"
    
        # 选用版本 glibc 源码 https://mirrors.kernel.org/gnu/libc/ 为 2.34 版本的 tar.gz
        cd docker-glibc-builder
    
        # LABEL MAINTAINER="smallflowercat1995 <smallflowercat1995@hotmail.com>"
        # 修改 Dockerfile 中的 ubuntu:20.04 为 --platform="linux/amd64" ubuntu:20.04
        # 修改 Dockerfile 中的 GLIBC_VERSION 为 2.34
        nano Dockerfile
    
        # 无代理方式运行 docker 构建镜像
        docker build --no-cache --platform "linux/amd64" -f Dockerfile -t smallflowercat1995/glibc-builder:amd64-2.34 . ; docker builder prune -fa ; docker rmi $(docker images -qaf dangling=true)
        # 代理方式运行 docker 构建镜像请自定义代理ip：192.168.255.140 http/https port：7893 socks port：7893
        export IP=192.168.255.140 H_P=7893 S_P=7893 ; docker build --no-cache --platform "linux/amd64" -f Dockerfile -t smallflowercat1995/glibc-builder:amd64-2.34 . --build-arg http_proxy=http://${IP}:${H_P} --build-arg https_proxy=http://${IP}:${H_P} --build-arg all_proxy=socks5://${IP}:${S_P} ; docker builder prune -fa ; docker rmi $(docker images -qaf dangling=true)
    
    
        # 无代理方式运行 docker 镜像输出 glibc-bin-2.34-0-x86_64.tar.gz
        docker run --platform "linux/amd64" --rm -e "GLIBC_VERSION=2.34" -e "STDOUT=1" smallflowercat1995/glibc-builder:amd64-2.34 > glibc-bin-2.34-0-x86_64.tar.gz
        # 代理方式运行 docker 镜像输出 glibc-bin-2.34-0-x86_64.tar.gz请自定义代理ip：192.168.255.140 http/https port：7893 socks port：7893
        export IP=192.168.255.140 H_P=7893 S_P=7893 ; docker run --platform "linux/amd64" --rm -e "GLIBC_VERSION=2.34" -e "STDOUT=1" -e "http_proxy=http://${IP}:${H_P}" -e "https_proxy=http://${IP}:${H_P}" -e "all_proxy=socks5://${IP}:${S_P}" smallflowercat1995/glibc-builder:amd64-2.34 > glibc-bin-2.34-0-x86_64.tar.gz
    
        # 赋权
        chmod -v +x glibc-bin-2.34-0-x86_64.tar.gz
    
        cd -
    
        # clone alpine-pkg-glibc 构建项目 https://github.com/sgerrand/alpine-pkg-glibc
        git clone "https://github.com/sgerrand/alpine-pkg-glibc"
        # 复制文件到项目目录
        cp -fv docker-glibc-builder/glibc-bin-2.34-0-x86_64.tar.gz $HOME/alpine-pkg-glibc
    
        # 无代理创建 alpine amd64 环境 
        docker create --rm --name "alpine-test" --platform "linux/amd64" -it -v "$HOME/alpine-pkg-glibc:/alpine-pkg-glibc" alpine:latest
        # 代理创建 alpine amd64 环境 请自定义代理ip：192.168.255.140 http/https port：7893 socks port：7893
        export IP=192.168.255.140 H_P=7893 S_P=7893 ; docker create --rm --name "alpine-test" --platform "linux/amd64" -it -v "$HOME/alpine-pkg-glibc:/alpine-pkg-glibc" -e "http_proxy=http://${IP}:${H_P}" -e "https_proxy=http://${IP}:${H_P}" -e "all_proxy=socks5://${IP}:${S_P}" alpine:latest
    
        # 启动测试容器
        docker start -i "alpine-test"
    
        # alpine 包构建搭建环境
        apk add -q --no-cache alpine-sdk abuild-rootbld git nano sudo bash shadow
    
        # 设置默认 shell 环境
        chsh -s /bin/bash
    
        # 创建 smallflowercat1995 授权免密
        USERS=smallflowercat1995
        PASSWORD=123456
        echo -e "$PASSWORD\n$PASSWORD" | adduser "$USERS"
        echo "$USERS ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERS && chmod 0440 /etc/sudoers.d/$USERS
        usermod -aG ${USERS},$(id -G $USER | sed 's; ;,;g'),abuild ${USERS}
        id ${USERS}
    
        # 进入用户
        su ${USERS}
    
        # 进入项目目录修改权限
        sudo chmod -Rv 0755 /alpine-pkg-glibc
        sudo chown -Rv $USER:$USER /alpine-pkg-glibc
    
        # 进入构建目录
        cd /alpine-pkg-glibc
    
        # 过滤 x86_64 文件
        tar -tvf glibc-bin-2.34-0-x86_64.tar.gz | grep ld-linux-
            ```显示内容得到 ld-linux-x86-64.so.2
            -rwxr-xr-x root/root   1363088 2024-04-04 15:43 usr/glibc-compat/lib/ld-linux-x86-64.so.2
            ```
    
        # MAINTAINER smallflowercat1995 <smallflowercat1995@hotmail.com>
        # 修改 APKBUILD 中的 pkgver="2.30" 为 pkgver="2.34"
        # 修改 APKBUILD 中的 pkgrel="1" 为 pkgrel="0"
        # 修改 APKBUILD 中的 source="https://github.com/Rjerk/docker-glibc-builder/releases/download/$pkgver-$_pkgrel/glibc-bin-$pkgver-$_pkgrel-x86_64.tar.gz 为 source="glibc-bin-$pkgver-$_pkgrel-x86_64.tar.gz
        nano APKBUILD
    
        # 配置 用户名 邮箱
        git config --global user.name "smallflowercat1995"
        git config --global user.email "smallflowercat199508@gmail.com"
    
        # 创建查看alpine构建包公钥
        echo -e '\n' | abuild-keygen -a -i 
        ls $HOME/.abuild/*rsa*
    
        # 校验写入 sha512sum 到 APKBUILD 文件
        abuild checksum
        mkdir -pv $HOME/packages
    
        # 打包构建apk
        abuild -r
    
        # 复制打包文件到项目目录 
        cp -rfv $HOME/packages /alpine-pkg-glibc
    
        # 如果没问题的话输出包会在 /alpine-pkg-glibc/packages/$USER/x86_64 路径
        ls -al /alpine-pkg-glibc/packages/x86_64
        cd /alpine-pkg-glibc/packages/x86_64
    
        # 检查包内公钥名 smallflowercat199508@gmail.com-660e7a04.rsa.pub
        RSA_PUB=$(tar tvf APKINDEX.tar.gz | grep rsa | sed 's;.SIGN.RSA.;;g' | awk '{print $6}')
        tar tvf APKINDEX.tar.gz | grep rsa | sed 's;.SIGN.RSA.;;g' | awk '{print $6}'
            ```输出打包使用的公钥名 smallflowercat199508@gmail.com-660e7a04.rsa.pub
            smallflowercat199508@gmail.com-660e7a04.rsa.pub
            ```
    
        # 复制公钥到当前目录用于在其他设备安装使用
        cp -fv $HOME/.abuild/${RSA_PUB} /alpine-pkg-glibc/packages/x86_64/
    
        # 退出用户登陆
        exit
    
        cd /alpine-pkg-glibc/packages/x86_64/
    
        # 检查包内公钥名 smallflowercat199508@gmail.com-660e7a04.rsa.pub
        RSA_PUB=$(tar zxvf /alpine-pkg-glibc/packages/x86_64/APKINDEX.tar.gz | grep rsa | sed 's;.SIGN.RSA.;;g')
    
        # 先将公钥写入
        cp -fv /alpine-pkg-glibc/packages/x86_64/${RSA_PUB} /etc/apk/keys/
    
        # 安装编译好的包
        apk add -q --force-overwrite -q --no-cache glibc-2.34-r0.apk glibc-bin-2.34-r0.apk glibc-i18n-2.34-r0.apk
    
        # 修复一下
        apk fix --allow-untrusted --force-overwrite -q --no-cache
    
        # 删除公钥
        rm -fv /etc/apk/keys/${RSA_PUB}
    
        # 测试，如果没报错，应该就能用 glibc 了
        /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true
        echo "export LANG=$LANG" > /etc/profile.d/locale.sh
    
        cd -
    
        # 测试完成退出容器
        exit
    
        # 进入打包目录就会看到文件了
        cd $HOME/alpine-pkg-glibc/packages/x86_64/

# 声明
本项目仅作学习交流使用，用于查找资料，学习知识，不做任何违法行为。所有资源均来自互联网，仅供大家交流学习使用，出现违法问题概不负责。

## 感谢&参考
jupyter 官网：https://jupyter.org/install    
大佬 conda-forge：https://github.com/conda-forge/miniforge  
install jupyter-lab：https://jupyterlab.readthedocs.io/en/latest/getting_started/installation.html  
Common Extension Points：https://jupyterlab.readthedocs.io/en/latest/extension/extension_points.html   
miniforge for alpine：https://github.com/conda-forge/miniforge/issues/219#issuecomment-1003216514  
alpine Setting_up_the_build_environment：https://wiki.alpinelinux.org/wiki/Abuild_and_Helpers#Setting_up_the_build_environment  
gnu/libc：https://mirrors.kernel.org/gnu/libc/  
sgerrand/docker-glibc-builder：https://github.com/sgerrand/docker-glibc-builder  
sgerrand/alpine-pkg-glibc：https://github.com/sgerrand/alpine-pkg-glibc  
ljfranklin/docker-glibc-builder：https://github.com/ljfranklin/docker-glibc-builder/tree/Jingzhao123-EnableArm64Images  
alpine-pkg-glibc：https://github.com/ljfranklin/alpine-pkg-glibc/tree/arm64  
multiarch/qemu-user-static：https://github.com/multiarch/qemu-user-static  
