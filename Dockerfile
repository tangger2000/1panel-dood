# 该Dockerfile用于构建1panel-dood。
# dood是指Docker out of Docker，其本质是在Docker容器内部直接使用主机的Docker而不是使用Docker容器内部的Docker
# dind是指Docker in Docker，其本质是在Docker容器内部进行套娃。

# 对于1panel而言，1panel软件本身是一个编译好的二进制程序文件，可以在任何对于架构的服务器上运行，
# 但在某些情况下[eg:群晖]，官方提供的安装程序不能很好的正常工作，而使用Docker安装就成为一种比较好的方式；
# 因此，我仅修改了官方的安装脚本，并编写了一个玩具式的Dockerfile和docker-compose文件，以供大家在Docker上安装1panel


# 使用ubuntu作为基础镜像
FROM ubuntu:latest

# 维护者信息
LABEL maintainer="2018211556@stu.cqupt.edu.cn"
LABEL description="1panel-dood"
LABEL version="1.5"

# 安装 Docker 及其依赖
RUN apt-get update && apt-get install ca-certificates curl gnupg dpkg wget unzip -y && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
	chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo \
	"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
	"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
	tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install docker-ce-cli -y && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 在容器中挂载主机上的 docker.sock
VOLUME /var/run/docker.sock

# 安装1panel
RUN cd /app && wget https://github.com/tangger2000/1panel-dood/raw/main/1panel-v1.5.1-linux-amd64.zip && \
	unzip 1panel-v1.5.1-linux-amd64.zip && cd 1panel-v1.5.1-linux-amd64 && mv 1panel-v1.5.1-linux-amd64 1panel
