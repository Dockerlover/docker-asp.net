# docker-asp.net

Docker化Asp.Net

## 镜像特点

- 2015/8/19 继承基础镜像docker-asp.net

## 使用方法

- 获取代码并构建

        git clone https://github.com/Dockerlover/docker-asp.net.git
        cd docker-asp.net
        docker build -t docker-asp.net .

## 部署一个简单的ASP.NET应用

- clone实例代码

        git clone git@github.com:aspnet/Home.git aspnet-Home
        cd aspnet-Home/samples/HelloWeb

- 编写Dockerfile

        FROM docker-asp.net
        
        COPY . /app
        WORKDIR /app
        RUN ["dnu", "restore"]
        
        EXPOSE 5004
        ENTRYPOINT ["dnx", ".", "kestrel"]

- 构建镜像

        docker build -t myapp .

- 运行实例镜像

        docker run -it -d -p 80:5004 myapp

- 访问应用

        http://localhost:5004
