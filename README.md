# docker-asp.net

Docker化Asp.Net

## 镜像特点

- 2015/8/19 继承基础镜像docker-asp.net

## 直接pull镜像

    docker pull liuhong1happy/docker-asp.net

## 使用方法

- 获取代码并构建

        git clone https://github.com/Dockerlover/docker-asp.net.git
        cd docker-asp.net
        docker build -t docker-asp.net .

## 部署一个简单的ASP.NET应用

- clone实例代码

        git clone git@github.com:aspnet/Home.git aspnet-Home
        cd aspnet-home/samples/latest/HelloWeb

- 编写 supervisord.conf

        [supervisord]
        
        nodaemon=true
        
        [program:home-app]
        
        command=dnx . kestrel

- 编写Dockerfile

        # 基础镜像
        FROM docker-asp.net
        # 维护人员
        MAINTAINER  liuhong1.happy@163.com
        # 复制代码
        COPY . /app
        # 安装依赖包
        RUN dnu restore
        # 暴露5004
        EXPOSE 5004
        # 复制supervisord.conf
        COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
        # 启动supervisord
        CMD ["/usr/bin/supervisord"]

- 构建镜像

        docker build -t myapp .

- 运行实例镜像

        docker run -it -d -p 80:5004 myapp

- 访问应用

        http://localhost:5004
