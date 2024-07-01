#!/bin/bash

OS_TYPE=$(uname -s)
ARCH_TYPE_MINIFORGE=$(uname -m)
# JDK if x86_64 -> x64
ARCH_TYPE_JDK=$(if [ "$(uname -m)" = "x86_64" ];then echo "x64";else echo $(uname -m);fi)


# 将执行脚本移动到可执行目录并授权
mv -fv run_jupyter /usr/bin/
chmod -v u+x /usr/bin/run_jupyter

# 汉化安装中文字体
apk add --no-cache font-noto-cjk font-wqy-zenhei

# 写入汉化配置环境
cat << SMALLFLOWERCAT1995 | tee -a /etc/environment
LANG=zh_CN.UTF-8
LC_CTYPE="zh_CN.UTF-8"
LC_NUMERIC="zh_CN.UTF-8"
LC_TIME="zh_CN.UTF-8"
LC_COLLATE="zh_CN.UTF-8"
LC_MONETARY="zh_CN.UTF-8"
LC_MESSAGES="zh_CN.UTF-8"
LC_PAPER="zh_CN.UTF-8"
LC_NAME="zh_CN.UTF-8"
LC_ADDRESS="zh_CN.UTF-8"
LC_TELEPHONE="zh_CN.UTF-8"
LC_MEASUREMENT="zh_CN.UTF-8"
LC_IDENTIFICATION="zh_CN.UTF-8"
LC_ALL=
SMALLFLOWERCAT1995

# 整合拆分包
cat ./OpenJDK-jdk_${ARCH_TYPE_JDK}_alpine-${OS_TYPE}_hotspot.tar.gz.* > /tmp/OpenJDK-jdk_${ARCH_TYPE_JDK}_alpine-${OS_TYPE}_hotspot.tar.gz

# 解压缩
tar xvf /tmp/OpenJDK-jdk_${ARCH_TYPE_JDK}_alpine-${OS_TYPE}_hotspot.tar.gz -C /opt/

# 写入 java 环境变量
cat << EOF | tee -a $HOME/.bashrc
export JAVA_HOME=/opt/$(ls -al /opt | grep jdk | awk '{print $9}' | tail -1)
export CLASSPATH=.:\$JAVA_HOME/lib/tools.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib
export PATH=\$PATH:\$JAVA_HOME/bin
EOF

# 合并拆分包
cat ./Mambaforge-*-${OS_TYPE}-${ARCH_TYPE_MINIFORGE}.sh.tar.xz.* > /tmp/Mambaforge-${OS_TYPE}-${ARCH_TYPE_MINIFORGE}.sh.tar.xz
pv /tmp/Mambaforge-${OS_TYPE}-${ARCH_TYPE_MINIFORGE}.sh.tar.xz | tar -PpJxv -C /tmp/
chmod -v +x /tmp/Mambaforge-*-${OS_TYPE}-${ARCH_TYPE_MINIFORGE}.sh

bash /tmp/Mambaforge-*-${OS_TYPE}-${ARCH_TYPE_MINIFORGE}.sh -b -p /opt/miniforge3
ln -s /opt/miniforge3/etc/profile.d/conda.sh /etc/profile.d/conda.sh
echo ". /opt/miniforge3/etc/profile.d/conda.sh" >> ~/.bashrc
echo "conda activate base" >> ~/.bashrc
find /opt/miniforge3/ -follow -type f -name '*.a' -delete
find /opt/miniforge3/ -follow -type f -name '*.js.map' -delete
/opt/miniforge3/bin/conda clean -afy

# 写入 miniforge 环境变量
cat << EOF | tee -a $HOME/.bashrc
export PATH=/opt/miniforge3/bin:\$PATH
EOF

export PATH=/opt/miniforge3/bin:$PATH

# 显示请求和进度条
conda config --set show_channel_urls yes

# 添加清华源
#conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge
#conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2
#conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda
#conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/menpo
#conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch
#conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch-lts
#conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/simpleitk
#conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
#conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
#conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r

# 排序
conda config --get channels

# 清理索引
conda clean -i -y

# 查看源
conda config --show-sources

# 尝试重新安装zlib包，更新mamba并清理缓存
mamba install -fy zlib
mamba update -n base -c defaults mamba -y
mamba clean --all -y

# 创建软链接
if [ -e $(command -v python3) ]
then
    ln -fsv $(command -v python3) /usr/bin/python
    ln -fsv $(command -v pip3) /usr/bin/pip
else
    echo "python3 没找到"
fi

# 获取Python版本
version=$(python --version 2>&1 | awk '{print $2}')
IFS='.' read -ra ADDR <<< "$version"

# 检查版本是否为2
if [[ ${ADDR[0]} -eq 2 ]]
then
    echo "版本过低 python2"
elif [[ ${ADDR[0]} -eq 3 ]]
then
    # 检查版本是否小于等于3.10
    if [[ ${ADDR[1]} -le 10 ]]
    then
        echo "python 版本 ${ADDR}"
        python -m pip --no-cache-dir install -v --upgrade pip
        python -m pip --no-cache-dir install -v -r requirements.txt
        # python -m pip --no-cache-dir install -v --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple
        # python -m pip --no-cache-dir install -v -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
    else
        echo "python 版本 ${ADDR}"
        python -m pip --no-cache-dir install -v --upgrade pip --break-system-packages
        python -m pip --no-cache-dir install -v -r requirements.txt --break-system-packages
        # python -m pip --no-cache-dir install -v --upgrade pip --break-system-packages -i https://pypi.tuna.tsinghua.edu.cn/simple
        # python -m pip --no-cache-dir install -v -r requirements.txt --break-system-packages -i https://pypi.tuna.tsinghua.edu.cn/simple
    fi
else
    echo "超出版本预期，脚本需要更新！！"
fi

# 生成 jupyter 默认配置文件
echo y | jupyter-notebook --generate-config --allow-root

# 查看 jupyter 版本
jupyter --version

# 安装 ijava 支持扩展
cp -fv ./ijava-1.3.0.zip /tmp/ijava.zip
unzip -o -d /tmp/ijava /tmp/ijava.zip
cd /tmp/ijava
python install.py --sys-prefix
cd -
# 安装 C 语言解释器，支持C
mamba install -c conda-forge xeus-cling -y --quiet

# 清理环境
rm -rfv *.apk *.rsa.pub /etc/apk/keys/smallflowercat199508@gmail.com.rsa.pub /tmp/OpenJDK-jdk_${ARCH_TYPE_JDK}_alpine-${OS_TYPE}_hotspot.tar.gz /tmp/Mambaforge-${OS_TYPE}-${ARCH_TYPE_MINIFORGE}.sh.tar.xz /tmp/Mambaforge-*-${OS_TYPE}-${ARCH_TYPE_MINIFORGE}.sh /tmp/ijava.zip /tmp/ijava OpenJDK-jdk_${ARCH_TYPE_JDK}_alpine-${OS_TYPE}_hotspot.tar.gz.* Mambaforge-*-${OS_TYPE}-${ARCH_TYPE_MINIFORGE}.sh.tar.xz.* ijava-1.3.0.zip requirements.txt
