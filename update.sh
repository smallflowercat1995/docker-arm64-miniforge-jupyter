#!/usr/bin/env bash
cd package/

# 清空一切
rm -fv *.tar.xz* *.tar.gz* *.zip

# 系统环境
OS_TYPE=$(uname -s)
# 获取架构
ARCH_TYPE_MINIFORGE=$(uname -m)
# 获取架构 JDK x86_64 -> x64
ARCH_TYPE_JDK=$(if [ "$(uname -m)" = "x86_64" ];then echo "x64";else echo $(uname -m);fi)

# github 项目 SpencerPark/IJava
URI="SpencerPark/IJava"
# 从 SpencerPark/IJava github中提取全部 tag 版本，获取最新版本赋值给 VERSION 后打印
VERSION=$(curl -sL "https://github.com/$URI/releases" | grep -oP '(?<=\/releases\/tag\/)[^"]+' | head -n 1)
echo $VERSION
# 拼接下载链接 URI_DOWNLOAD 后打印 v1.3.0
URI_DOWNLOAD="https://github.com/$URI/releases/download/$VERSION/ijava-$(echo $VERSION | sed 's;^v;;g').zip"
echo $URI_DOWNLOAD
# 获取文件名 FILE_NAME 后打印
FILE_NAME=$(basename $URI_DOWNLOAD)
echo $FILE_NAME

# 下载 jupyter 扩展 ijava 支持java语言环境
wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "${URI_DOWNLOAD}" -O"${FILE_NAME}"

# github 项目 conda-forge/miniforge
URI="conda-forge/miniforge"
# 从 conda-forge/miniforge github中提取全部 tag 版本，获取最新版本赋值给 VERSION 后打印
VERSION=$(curl -sL "https://github.com/$URI/releases" | grep -oP '(?<=\/releases\/tag\/)[^"]+' | head -n 1)
echo $VERSION
# 拼接下载链接 URI_DOWNLOAD 后打印 24.1.2-0
URI_DOWNLOAD="https://github.com/$URI/releases/download/$VERSION/Mambaforge-$VERSION-${OS_TYPE}-${ARCH_TYPE_MINIFORGE}.sh"
echo $URI_DOWNLOAD
# 获取文件名 FILE_NAME 后打印
FILE_NAME=$(basename $URI_DOWNLOAD)
echo $FILE_NAME
wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "${URI_DOWNLOAD}" -O"${FILE_NAME}"

# 压缩
tar -PJpcf - ${FILE_NAME} | (pv -p --timer --rate --bytes > ${FILE_NAME}.tar.xz)

# 拆分大型压缩包使 github 可以存储 47MB
split -d -b 47m ${FILE_NAME}.tar.xz ${FILE_NAME}.tar.xz.

# 删除文件
rm -fv ${FILE_NAME} ${FILE_NAME}.tar.xz

# 下载 alpine openjdk
wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "https://github.com/adoptium/temurin22-binaries/releases/download/jdk-22.0.1%2B8/OpenJDK22U-jdk_${ARCH_TYPE_JDK}_alpine-${OS_TYPE}_hotspot_22.0.1_8.tar.gz" -O"OpenJDK-jdk_${ARCH_TYPE_JDK}_alpine-${OS_TYPE}_hotspot.tar.gz"

# 拆分大型压缩包使 github 可以存储 47MB
split -d -b 47m OpenJDK-jdk_${ARCH_TYPE_JDK}_alpine-${OS_TYPE}_hotspot.tar.gz OpenJDK-jdk_${ARCH_TYPE_JDK}_alpine-${OS_TYPE}_hotspot.tar.gz.

# 删除 OpenJDK-jdk_${ARCH_TYPE_JDK}_alpine-${OS_TYPE}_hotspot.tar.gz
rm -fv OpenJDK-jdk_${ARCH_TYPE_JDK}_alpine-${OS_TYPE}_hotspot.tar.gz

if [ "${ARCH_TYPE_MINIFORGE}" = "aarch64" ];then
    echo aarch64
    # 下载支持 aarch64 alpine 的glibc
    # rm -fv *.apk *.pub
    # wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "https://github.com/ljfranklin/alpine-pkg-glibc/releases/download/2.32-r0-arm64/glibc-2.32-r0.apk" -O"glibc-2.32-r0.apk"
    # wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "https://github.com/ljfranklin/alpine-pkg-glibc/releases/download/2.32-r0-arm64/glibc-bin-2.32-r0.apk" -O"glibc-bin-2.32-r0.apk"
    # wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "https://github.com/ljfranklin/alpine-pkg-glibc/releases/download/2.32-r0-arm64/glibc-i18n-2.32-r0.apk" -O"glibc-i18n-2.32-r0.apk"
    # wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "https://github.com/ljfranklin/alpine-pkg-glibc/releases/download/2.32-r0-arm64/ljfranklin-glibc.pub" -O"ljfranklin-glibc.pub"
elif [ "${ARCH_TYPE_MINIFORGE}" = "x86_64" ];then
    echo x86_64
    # 下载支持 x86_64 alpine 的glibc
    rm -fv *.apk *.pub
    wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk" -O"glibc-2.34-r0.apk"
    wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-bin-2.34-r0.apk" -O"glibc-bin-2.34-r0.apk"
    wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-i18n-2.34-r0.apk" -O"glibc-i18n-2.34-r0.apk"
    wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub" -O"sgerrand.rsa.pub"
else
    echo "不支持，请自定义编写判断条件，并编译自己设备架构的 alpine glibc 包，退出"
    exit 1
fi

# 返回目录
cd -
