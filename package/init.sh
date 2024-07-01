#!/bin/sh

# 换源
# sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

# 安装一些必备工具
apk add --no-cache tzdata

# 修改时钟
date +'%Y-%m-%d %H:%M:%S'
ln -sfv /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
date +'%Y-%m-%d %H:%M:%S'

# 换成 bash
apk add --no-cache bash shadow gcc python3-dev musl-dev linux-headers tar pv xz procps
chsh -s /bin/bash

# 安装 glibc alpine 编译包
mkdir -pv /etc/apk/keys

if [ "$(uname -m)" = "aarch64" ];then
    echo aarch64
    # aarch64 alpine
    #cp -fv ljfranklin-glibc.pub /etc/apk/keys/ljfranklin-glibc.pub
    cp -fv smallflowercat199508@gmail.com-660c0ab9.rsa.pub /etc/apk/keys/smallflowercat199508@gmail.com-660c0ab9.rsa.pub
    # aarch64 alpine
    #apk add --force-overwrite -q --no-cache glibc-2.32-r0.apk glibc-bin-2.32-r0.apk glibc-i18n-2.32-r0.apk
    apk add --force-overwrite -q --no-cache glibc-2.39-r0.apk glibc-bin-2.39-r0.apk glibc-i18n-2.39-r0.apk
elif [ "$(uname -m)" = "x86_64" ];then
    echo x86_64
    # x86_64 alpine
    cp -fv sgerrand.rsa.pub /etc/apk/keys/sgerrand.rsa.pub
    # x86_64 alpine
    apk add --force-overwrite -q --no-cache glibc-2.34-r0.apk glibc-bin-2.34-r0.apk glibc-i18n-2.34-r0.apk
else
    echo "不支持，请自定义编写判断条件，并编译自己设备架构的 alpine glibc 包，退出"
    exit 1
fi

apk fix --allow-untrusted --force-overwrite -q --no-cache
/usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true
echo "export LANG=$LANG" > /etc/profile.d/locale.sh

# 尝试用 bash 环境运行 install.sh
bash install.sh
rm -fv /bin/sh ; echo -e '#!/bin/bash\nbash' > /bin/sh ; chmod -v +x /bin/sh
