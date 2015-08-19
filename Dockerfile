# 基础镜像
FROM docker-ubuntu
# 维护人员
MAINTAINER liuhong1.happy@163.com
# 添加环境变量
ENV USER_NAME admin
ENV SERVICE_ID asp.net
ENV DNX_VERSION 1.0.0-beta6
ENV DNX_USER_HOME /opt/dnx
ENV PATH $PATH:$DNX_USER_HOME/runtimes/default/bin
# 安装mono-beta
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/debian wheezy main" > /etc/apt/sources.list.d/mono-xamarin.list \
  && apt-get update && apt-get install -y mono-devel ca-certificates-mono fsharp mono-vbnc nuget zip autoconf automake libtool \
	&& rm -rf /var/lib/apt/lists/*
# 安装DNVM
RUN curl -sSL https://raw.githubusercontent.com/aspnet/Home/dev/dnvminstall.sh | DNX_USER_HOME=$DNX_USER_HOME DNX_BRANCH=v$DNX_VERSION sh
RUN bash -c "source $DNX_USER_HOME/dnvm/dnvm.sh \
	&& dnvm install $DNX_VERSION -a default \
	&& dnvm alias default | xargs -i ln -s $DNX_USER_HOME/runtimes/{} $DNX_USER_HOME/runtimes/default"
# 安装libuv
RUN LIBUV_VERSION=1.4.2 \
	&& curl -sSL https://github.com/libuv/libuv/archive/v${LIBUV_VERSION}.tar.gz | tar zxfv - -C /usr/local/src \
	&& cd /usr/local/src/libuv-$LIBUV_VERSION \
	&& sh autogen.sh && ./configure && make && make install \
	&& rm -rf /usr/local/src/libuv-$LIBUV_VERSION \
	&& ldconfig
# 设定工作路径
RUN mkdir -p /app
WORKDIR /app
# 默认暴露80端口
EXPOSE 80
# 复制supervisord.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# 启动supervisord
CMD ["/usr/bin/supervisord"]
