# 1panel-dood
Running a 1panel panel in docker via dood.  
1panel is a very modern, easy to use, efficient and beautiful server management panel. 1panel itself is a compiled binary, but 1panel does not provide a Docker image to install, while the one-click install script provided by 1panel does not install properly on systems lacking systemctl.
1panel uses systemctl to manage 1panel services (including starting, restarting, turning on daemons, and bootstrapping), which is fine on operating systems that include systemctl.
In order to allow 1panel to install 1panel on Docker, I modified the installation script provided officially by 1panel and packaged a docker image.
Next I will provide you with several ways to install it:

1panel是一个非常现代化、易用、高效、漂亮的服务器管理面板。1panel本身是一个编译好的二进制文件，但是1panel没有提供Docker镜像安装，同时1panel提供的一键式安装脚本不能在缺乏sytemctl的系统上正常安装。
1panel使用systemctl来管理1panel服务（包括启动、重启、开启守护、开机自启），这在包含systemctl的操作系统上是毫无问题的。
为了让1panel可以在Docker上安装1panel，我修改了1panel官方提供的安装脚本，并打包了一个docker镜像。
接下来我将为你提供几种安装方式：

## DooD Install Methods
DooD stands for Docker out of Docker, and he is a form of using Docker on the host inside a Docker container. The benefit of this is that we can directly use the host Docker's resources, such as the network stack.
In docker-compose, we just need to mount the host's docker.sock to the Docker container's docker.sock. Of course, the Docker container also needs to install the Docker software, but uses the host Docker's resources.

DooD是指Docker out of Docker，他是在Docker容器内部使用主机上的Docker的一种形式。这种的好处是，我们可以直接使用主机Docker的资源、例如网络栈。
在docker-compose中，我们只需要将主机的docker.sock挂载到Docker容器的docker.sock即可。当然，Docker容器也需要安装Docker软件，但使用的却是主机Docker的资源。

1. 创建如下docker-compose.yml文件,修改*<your_data_dir>*为你想要持久化的文件路径：
```
version: '3'
services:
  1panel-dood:
    image: tangger/1panel-dood:latest
    command: sh -c "echo <your_data_dir> | bash /app/1panel-v1.5.1-linux-amd64/install.sh"
    network_mode: "host"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - <your_data_dir>:<your_data_dir>
    restart: always
```

2.运行：
```
sudo docker-compose up -d
```

## DinD Install Methods
[Not recommended] DinD means Docker in Docker, which is Docker nesting compared to the DooD approach. It's very well understood.
This installation method does not need to mount the host's Docker.sock to the container, but it needs to mount a large number of port numbers.
First of all, there is a network stack in DinD itself, and you need to map DinD's service ports to the containers running 1panel (which of course can be solved by the host approach). Then you also need to expose those ports to a specified port on the host on the host's Docker configuration.
[OK, my head is spinning just thinking about this approach, I haven't written the docker-compose file yet, I don't want to ~~]

【不推荐】DinD是指Docker in Docker，相比于DooD方式而言就是Docker套娃。很好理解。
这种安装方式不需要挂载主机的Docker.sock到容器，但是需要挂载大量的端口号。
首先，DinD本身存在一个网络栈，你需要将DinD的服务端口映射到运行1panel的容器（当然可以用host方式解决）。然后你还需要在主机的Docker配置上将这些端口暴露到主机的指定端口。
【好吧，我想到这个方式就头大，暂时还没写docker-compose文件，不想写~~】

## 80, 443 port occupation problem
Users who use NAS servers such as Synology or Unraid should pay attention to this point, Synology itself runs an NGINX/Apache, which will occupy ports 80 and 443 of the host computer.  
If you choose host mode, please choose to free up port 80 and 443 of Synology and Unraid. Please Bing it by yourself.  [Synology free 80/443 Port](https://www.cnblogs.com/zhengdaojie/p/16019318.html)
Otherwise, choose bridge mode for network mode and map the ports by yourself.

80、443端口占用问题  
使用群晖、Unraid等NAS服务器的用户尤其需要注意这点，群晖本身运行了一个NGINX/Apache，会占用宿主机的80、443端口。  
如果网络模式选择host模式，请选择将群晖、Unraid等系统的80、443端口解放。请自行Bing一下。  
否则网络模式选择bridge模式，并自行映射端口。
