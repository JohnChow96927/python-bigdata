# Git版本控制

## 项目开发中的版本问题

> 目标：了解项目开发中遇到的开发版本问题

- **举例：你在大学中写论文**

  - 问题1：==直接在一个文件上不断修改，但如果我想回到之前某个版本怎么办==？
  - 手动的管理和记录每个版本之间的变化

  ![image-20211207171314412](assets/image-20211207171314412.png)

  - 问题2：如果我让别人帮我写，我自己也写，我==想将别人写的部分和我写的部分合并怎么办==？
    - 论文有10个部分，10个人来写，我需要合并
    - 我觉得有个人写的不好，我要重写它的，再合并
  - 问题：所有的操作都在手动管理，极其容易出现错误

- **项目开发会存在同样的问题**

  - 整个项目由多个人共同开发，每个人开发的模块可能一样也可能不一样
    - 不一样：每个人负责不同的 功能模块
    - 一样：多个人共同负责一个模块
  - 代码会产生多个版本
    - 版本如何控制？
    - 这个版本中没有这个功能，但是我下个版本想要这个功能，下下一个版本这个功能又不需要了
    - 产品
      - v1：A、B
        - 原来的版本，有A和B两个功能
      - v2：A、C
        - 去掉了B功能，添加了C功能
      - v3：A、B、C
        - 添加了B这个功能

- ==如何实现多个人共同开发一个项目，能将项目的多个版本进行自由方便的管理==

  - 甲：今天开发了一个版本，保存这个版本
  - 乙：基于甲昨天开发的版本，进行继续开发
  - 丙：负责开发另外一个版本

## Git的诞生及特点

> 了解Git的诞生背景及特点

- 项目版本管理工具：能**==自动的将多个版本进行管理存储==**，类似于快照，多个人共享版本

- **Git诞生**：**分布式**项目管理工具，目前整个行业内最流行最受欢迎的项目版本管理工具

  - 开发者：Linus Torvalds 

    - Linux的创始人

    - Linux诞生以后，全球很多开发者开发了 很多个版本的Linux，提交给Linus Torvalds 

    - Linus Torvalds 将优秀的代码集成在Linux内核中，手动管理所有的代码

    - Linus Torvalds 不喜欢传统的免费CVS等工具，因为这些工具不好用，好用的都收费

    - Linus Torvalds 选择了一个商业化的工具，达成协议可以免费使用

    - 于是团队中的一个哥们有个想法：能不能破解这个东西？

    - 被发现了：Linus Torvalds 保证不再破解

    - 两周以后，Linus Torvalds 自己用C语言开发了Git，使用了类似于Linux的管理方式

    - Linus Torvalds ：将Linux的版本控制切换到Git上

      - Git的开发汲取了其他的版本控制工具的优点，避免了缺点

        

- **同类型工具的对比：SVN**

  - **集中式：SVN**

    ![image-20210516163734497](assets/image-20210516163734497.png)

    - 所有版本的代码都集中在SVN的服务器上

    - 任何一个开发者，都只能连接SVN服务器，下载代码和上传新的版本

    - 集中式：所有的开发都围绕SVN服务器为核心

    - 缺点

      - 必须联网

        - 局域网：还是比较快的，但是回家以后就没办法开发了
          - 在公司下载好
          - 回家开发，只能开发一个版本
          - 回到公司上传这个版本
        - 互联网：特别慢
          - 在任何一个地方连接SVN服务器，进行下载和上传

      - 自己无法自动管理多个版本

      - SVN服务器存在单点故障

        

  - **分布式：Git**

    ![image-20210516163758497](assets/image-20210516163758497.png)

    - **==去中心化模式==**
    - 优点
      - 不需要联网，自己的笔记本就是个本地版本库，直接利用自己的笔记本实现版本的管理
      - 自己可以管理任意多个版本
      - 不需要担心公共的版本库故障，每个人的本地都有版本库

- **Git的特点**

  - 适合于分布式开发，多人可以共同开发，强调个体
  - 公共的版本库服务器的压力不会太大
  - 速度快、更加灵活
  - 任意的开发者之间如果产生冲突也容易解决
  - 不需要联网也可以实现多版本管理

## Git及辅助工具安装

> 实现Git及辅助工具的安装

- **实施**

  - **需要安装的工具**

    ![image-20210516164002374](assets/image-20210516164002374.png)

    - Git-2.13.0-64-bit.exe：==Windows版本的Git工具安装包==
    - TortoiseGit-2.4.0.2-64bit.msi：==Git的可视化工具安装包==
    - TortoiseGit-LanguagePack-2.4.0.0-64bit-zh_CN.msi：TortoiseGit工具的汉化包

  - **安装Git**

    - 参考安装文档

  - **安装TortoiseGit**

    - 参考安装文档

  - **安装TortoiseGit汉化包**

    - 参考安装文档

## Git管理的组成结构

> 掌握Git管理版本的组成结构

- 图示

  ![image-20210516165144693](assets/image-20210516165144693.png)

  - 本地版本控制Git服务器
    - ==**工作区**【Work Dir】==：就是你开发和修改代码的地方
    - ==**暂存区**【Index】==：临时存放你即将提交的版本的地方
      - 所有需要保存的版本必须先添加到暂存区
    - ==**本地版本仓库**【HEAD】==：本地的版本库，实现本地的版本的管理
      - 所有暂存区的版本会被提交到本地版本库
  - ==**远程版本仓库**==：用于共享项目代码版本
    - GitHub、Gitee

## 本地仓库构建几种方式

> 基于自己的笔记本，在本地操作系统中实现Git本地仓库的构建

- **step1：准备**

  - 每个项目都可以基于Git构建版本库，每个项目都可以做版本管理

  - 先创建一个目录，再创建三个子目录【三个本地库】

    ![image-20210518101521041](assets/image-20210518101521041.png)

    

  - 本地库只要构建成功就会创建一个 隐藏目录.git

    > 修改配置 打开显示隐藏的项目

    ![image-20210518101705126](assets/image-20210518101705126.png)

    

- **step2：构建**

  - **方式一：通过Git自带的图形化界面进行构建**

    ![image-20210516165653517](assets/image-20210516165653517.png)

    ![image-20210516165724371](assets/image-20210516165724371.png)

    ![image-20210516165755822](assets/image-20210516165755822.png)

    ![image-20210516165817162](assets/image-20210516165817162.png)

    ![image-20210516165847065](assets/image-20210516165847065.png)

    ![image-20210516165911532](assets/image-20210516165911532.png)

    ![image-20210516165939369](assets/image-20210516165939369.png)

    ![image-20210516172327549](assets/image-20210516172327549.png)

  - **方式二：通过Git命令来构建**

    ![image-20210516172508429](assets/image-20210516172508429.png)

    ![image-20210516172548327](assets/image-20210516172548327.png)

    ```shell
    git init
    ```

    ![image-20210516172607619](assets/image-20210516172607619.png)

  - **方式三：通过TortoiseGit构建**

    ![image-20210516172640292](assets/image-20210516172640292.png)

    ![image-20210516172744765](assets/image-20210516172744765.png)

    ![image-20210516172757520](assets/image-20210516172757520.png)

    ![image-20210516172808434](assets/image-20210516172808434.png)

## Git基本操作 -- 添加、提交

> 实现在Git本地工作区，添加文件到本地仓库

- **step1：创建文件**

  ![image-20210516173659338](assets/image-20210516173659338.png)

  

- **添加到暂存区**

  ```shell
  #添加一个或者多个文件到暂存区
  git add [file1] [file2] ...
  
  #添加指定目录到暂存区，包括子目录
  git add [dir]
  
  #添加当前目录下的所有文件到暂存区
  git add .
  
  #如何嫌命令难记，也可以使用下述的tortoiseGit工具操作
  ```

  ![image-20210516173752142](assets/image-20210516173752142.png)

  ![image-20210516174333634](assets/image-20210516174333634.png)

  注意啊，这里==点确定表示添加到暂存区==，点击提交就一步提交到仓库了。

- **提交到本地库**

  ```shell
  #前面我们使用 git add 命令将内容写入暂存区。
  
  #git commit 命令将暂存区内容添加到本地仓库中。
  
  #master涉及分支的管理，我们后面细说。
  
  git commit -m [message]
  
  提交的时候最好写上提交日志  便于后续浏览排查。
  ```

  ![image-20210516174741284](assets/image-20210516174741284.png)

  ![image-20210516174826311](assets/image-20210516174826311.png)

  ![image-20210516174839812](assets/image-20210516174839812.png)

- **查看本地版本库**

  ![image-20210516174936630](assets/image-20210516174936630.png)

  ![image-20210516175009323](assets/image-20210516175009323.png)

## Git基本操作--修改、还原

> 实现基于本地版本库的修改提交

- **step1：修改文件**

  ![image-20210516175627148](assets/image-20210516175627148.png)

  ![image-20210516175845516](assets/image-20210516175845516.png)

- **step2：提交第二个版本**

  ![image-20210516175918667](assets/image-20210516175918667.png)

  ![image-20210516175944495](assets/image-20210516175944495.png)

- **step3：修改并提交第三个版本**

  ![image-20210517063831963](assets/image-20210517063831963.png)

- **step4：查看版本日志**

  ![image-20210517063940649](assets/image-20210517063940649.png)

  ![image-20210517064003538](assets/image-20210517064003538.png)

- **还原：修改文件，但未提交**

  > 使用tortoiseGit工具，可以将工作区的内容还原至最后一个提交的版本。

  ![image-20210517064147228](assets/image-20210517064147228.png)

  ![image-20210517064159195](assets/image-20210517064159195.png)

  ![image-20210517064234166](assets/image-20210517064234166.png)

  ![image-20210517064615881](assets/image-20210517064615881.png)

  ![image-20210517064626982](assets/image-20210517064626982.png)

  ![image-20210517064636601](assets/image-20210517064636601.png)

## Git基本操作--版本差异比较、回退

- **修改文件**

  ![image-20210517065330008](assets/image-20210517065330008.png)

- **工作区与最新版本的差异**

  ![image-20210517065359249](assets/image-20210517065359249.png)

  ![image-20210517065432612](assets/image-20210517065432612.png)

- **工作区与倒数第二个版本的差异**

  ![image-20210517065541582](assets/image-20210517065541582.png)

  ![image-20210517065610757](assets/image-20210517065610757.png)

- **工作区与之前任意版本的差异比较**

  > 可以使用tortoiseGit工具选中文件、右键查看日志信息。
  >
  > 在日志信息中选中想要比较的版本和工作区的之间的差异。

  ![image-20211208204301485](assets/image-20211208204301485.png)

- **版本回退**

  > ​	有时候用Git的时候，有可能commit提交代码后，发现这一次commit的内容是有错误的，那么有两种处理方法：
  > ​	1、修改错误内容，再次commit一次
  >
  > ​	2、使用git reset 命令撤销这一次错误的commit
  > ​	第一种方法比较直接， 但会多次一次commit记录。
  > ​    第二种方法会显得干净清爽，因为错误的commit没必要保留下来。但是使用的时候等慎重，对于新手而言。

  ```shell
  git reset 命令用于回退版本，可以指定退回某一次提交的版本，有3种模式可供选择，详见画图。
  ```

  ![image-20211208211244802](assets/image-20211208211244802.png)

  ![image-20210517070559858](assets/image-20210517070559858.png)

  ![image-20210517073354508](assets/image-20210517073354508.png)

  ![image-20210517073440961](assets/image-20210517073440961.png)

  ![image-20210517073617431](assets/image-20210517073617431.png)

  ![image-20210517073632997](assets/image-20210517073632997.png)

- **小结**

  - **==注意==**：如果重置回到某个版本时，关闭了tortoiseGit日志窗口，这个版本之后的版本全部会被删除，无法再次回到之后的版本

  - 重置git reset，只能倒退回退，如果有前进的需求怎么办？

    导出需要重置到的版本，重新提交版本，将原来的一个老版本变成最新版本

## Git基本操作--删除

- **情况1：文件删除**

  > 直接将工作区的已经提交的文件删除之后，不做提交动作，可以使用还原操作。![image-20210517074958638](assets/image-20210517074958638.png)

  ![image-20210517075027918](assets/image-20210517075027918.png)

- **情况2：删除版本**

  > 将工作区的已经提交的文件删除之后，做提交动作，可以通过日志还原。

  ![image-20210517080635930](assets/image-20210517080635930.png)

  ![image-20210517075849984](assets/image-20210517075849984.png)

  ![image-20210517075915898](assets/image-20210517075915898.png)

  ![image-20210517080705706](assets/image-20210517080705706.png)

- **情况3：删除管理**

  > 也就是所谓的摆脱Git的控制

  ![image-20210517080132034](assets/image-20210517080132034.png)

  ![image-20210517080155781](assets/image-20210517080155781.png)

  ![image-20210517080236174](assets/image-20210517080236174.png)

  ![image-20210517080301511](assets/image-20210517080301511.png)

## 添加整个项目

- **复制工程到本地库**

  ![image-20210517081930576](assets/image-20210517081930576.png)

- **添加到暂存区**

  ![image-20210517082006509](assets/image-20210517082006509.png)

  ![image-20210517082041890](assets/image-20210517082041890.png)

- **忽略不需要做控制的目录**

  ![image-20210517082651292](assets/image-20210517082651292.png)

  ![image-20210517082717748](assets/image-20210517082717748.png)

  ![image-20210517082740130](assets/image-20210517082740130.png)

  ![image-20210517082749828](assets/image-20210517082749828.png)

- **提交到本地库**

  ![image-20210517082817275](assets/image-20210517082817275.png)

  ![image-20210517082838486](assets/image-20210517082838486.png)

  ![image-20210517082853559](assets/image-20210517082853559.png)

## 暂存区的设计

- 没有暂存区
  - 在提交的时候，会让你选择那些文件需要提交
  - 我们所提交的必然是一个完整的版本
  - 毛病1
    - 文件特别多，挨个选非常麻烦
  - 毛病2
    - 版本1：ABC
    - 版本2：ABD
    - 想要一个版本：ACD
- 设计暂存区
  - 设计Git的时候考虑到上面两个问题的主要原因是提交版本修改的颗粒度太大了
  - 将可能需要提交的版本放入暂存区
  - 每一次只放一个部分
    - 第一次：A
    - 第二次：B
    - 提交一次：AB
    - 第三次：A，B，C
    - 提交一次：ABC版本
    - 第四次：A，C，D
    - 提交一次：ACD版本
  - 理解：
    - ==暂存区：相当于你买东西的先添加购物车==
      - 将商品放入购物车的自由组合进行支付
    - 版本：就是一次支付

## Git远程仓库--GitHub创建公共仓库

> 了解Git远程仓库的设计

- **问题**

  - 如何实现多台机器之间共同协作开发版本的管理？

- **解决**

  - 公共代码版本托管平台

- **商业代码托管平台**

  - 国外：==GitHub==
  - 国内：Gitee
  - 可以将代码发布到这个平台上进行托管，其他的人可以从这个平台下载代码
    - 公共代码库：大家都可以看到的
    - 私有代码库：可以控制访问权限，但是收费

- **注册GitHub，并登陆**

  - 参考附录一：https://github.com/

  - 如果访问不了，添加DNS解析

    ```
    #GitHub
    140.82.114.4 github.com
    199.232.69.194 github.global.ssl.fastly.net
    ```

- **创建公共仓库**

  ![image-20210517144706076](assets/image-20210517144706076.png)

  ![image-20210517144720378](assets/image-20210517144720378.png)

  ![image-20210517144909777](assets/image-20210517144909777.png)

## 本地与GitHub的SSH连接

> 实现本地仓库与GitHub公共仓库的连接

- **需求**

  - 即使是public的公共仓库，也只是所有人可读，但不是所有人可写
  - 哪些人可写呢？
    - 需要配置SSH认证
    - 需要将本地机器的公钥填写在GitHub中，只有填写公钥的机器才能推送

- **本地秘钥生成**

  - step1：在自己Windows本地生成一对公私钥

    ```
    ssh-keygen -t rsa
    ```

    ![image-20210517145351543](assets/image-20210517145351543.png)

  - step2：找到自己的公钥的位置：当前用户的家目录下：C:\user\用户名 \ .ssh

    ![image-20210517145433498](assets/image-20210517145433498.png)

  - step3：打开公钥的文件，并复制公钥的内容

    ![image-20210517145416695](assets/image-20210517145416695.png)

- **配置GitHub**

  ![image-20210517145626349](assets/image-20210517145626349.png)

  ![image-20210517145634196](assets/image-20210517145634196.png)

  ![image-20210517145640396](assets/image-20210517145640396.png)

  - 将整个公钥的所有内容配置到SSH的key中，添加保存即可

- **小结**

  - 实现本地仓库与GitHub公共仓库的连接

## 同步到远程仓库

> 实现本地仓库代码同步到远程仓库

- **方式一：命令同步**

  ```shell
  #添加一个远程仓库的地址叫origin
  git remote add origin git@github.com:Frank-itcast/repository1.git
  
  练习中替换成自己的仓库地址
  #git remote add origin git@github.com:AllenWoon/xls_1.git
  
  #将本地master同步到远程的origin
  git push -u origin master
  ```

  ![image-20210517150234875](assets/image-20210517150234875.png)

  ![image-20210517150254482](assets/image-20210517150254482.png)

  ![image-20210517150527813](assets/image-20210517150527813.png)

- **方式二：工具同步：SSH**

  ![image-20210517150823651](assets/image-20210517150823651.png)

  ![image-20210517150829584](assets/image-20210517150829584.png)

  ![image-20210517150836165](assets/image-20210517150836165.png)

  ![image-20210517150843104](assets/image-20210517150843104.png)

  ![image-20210517150849593](assets/image-20210517150849593.png)

  ![image-20210517150856019](assets/image-20210517150856019.png)

  ![image-20210517150902303](assets/image-20210517150902303.png)

  ![image-20210517150911265](assets/image-20210517150911265.png)

  ![image-20210517150917212](assets/image-20210517150917212.png)

  ![image-20210517150924391](assets/image-20210517150924391.png)

  ![image-20210517150930184](assets/image-20210517150930184.png)

  ![image-20210517150936557](assets/image-20210517150936557.png)

- **方式三：工具同步：HTTPS**

  ![image-20210517151915868](assets/image-20210517151915868.png)

  ![image-20210517151921960](assets/image-20210517151921960.png)

  ![image-20210517151928273](assets/image-20210517151928273.png)

  ![image-20210517151933625](assets/image-20210517151933625.png)

  ![image-20210517151939695](assets/image-20210517151939695.png)

  ![image-20210517151944745](assets/image-20210517151944745.png)

  ![image-20210517152302103](assets/image-20210517152302103.png)

  ![image-20210517151949836](assets/image-20210517151949836.png)

  ![image-20210517151955494](assets/image-20210517151955494.png)

  ![image-20210517152003315](assets/image-20210517152003315.png)

  

- **小结**

  - 实现本地仓库代码同步到远程仓库

## 从远程仓库克隆

> 实现从远程仓库克隆到本地仓库

- **方式一：命令**

  ```shell
  git clone git@github.com:Frank-itcast/reps1.git
  
  
  #git clone git@github.com:AllenWoon/xls_2.git
  ```

  ![image-20210517152534543](assets/image-20210517152534543.png)

  ![image-20210517152543973](assets/image-20210517152543973.png)

  ![image-20210517152549668](assets/image-20210517152549668.png)

- **方式二：工具**

  ![image-20210517152555739](assets/image-20210517152555739.png)

  ![image-20210517152626955](assets/image-20210517152626955.png)

  ![image-20210517152632997](assets/image-20210517152632997.png)

- **小结**

  - 实现从远程仓库克隆到本地仓库

## 冲突问题

> 了解版本管理的冲突问题及解决方案

- **问题**

  ![image-20210517153139256](assets/image-20210517153139256.png)

  - step1：用户1本地是版本3，Github也是版本3
  - step2：用户2克隆了Github中版本3，用户2的本地是版本3
  - step3：用户1本地是版本4，GitHub也是版本4
  - step4：用户2基于版本3开发了用户2的版本4推动给GitHub
  - 产生了冲突，如何解决？

- **举例**

  - 本地reps3

    > 添加一个文件demo01.java，先提交到本地仓库；
    >
    > 然后同步到GitHub远程仓库中
    >
    > git@github.com:AllenWoon/remote1.git

    ```
    this is a good file
    ```

  - 本地reps4：克隆刚才的远程仓库

    - 本地修改文件，提交到本地仓库

      ```
      this is a bad file
      
      ```

    - 同步到远程仓库

  - 本地reps3：demo01.java，进行了修改

    ```
    this is a file
    
    ```

    - 同步到远程仓库
    - 提交失败

  - 解决

    - 本地reps3：拉取远程reps1中的版本，发现冲突的文件
    - 修改冲突的文件
    - 解决冲突
    - 提交本地仓库
    - 提交远程仓库

    

- **解决**

  - 如果别人已经提交了某个版本，自己再次提交这个版本，会失败
  - 将两个冲突的版本合并，由开发者自行选择到底应该 使用哪个版本
    - step1：先拉取远程仓库中的当前的这个版本
  - step2：与自己的版本做比较
    - step3：调整好确认的版本以后，再次提交

  ![image-20210517154217277](assets/image-20210517154217277.png)

  ![image-20210517154223310](assets/image-20210517154223310.png)

  ![image-20210517154240371](assets/image-20210517154240371.png)

  ![image-20210517154246803](assets/image-20210517154246803.png)![image-20210517154257298](assets/image-20210517154257298.png)

  ![image-20210517154302602](assets/image-20210517154302602.png)

  ![image-20210517154308871](assets/image-20210517154308871.png)

  ![image-20210517154315564](assets/image-20210517154315564.png)

  ![image-20210517154321143](assets/image-20210517154321143.png)

  ![image-20210517154337957](assets/image-20210517154337957.png)

  ![image-20210517154343917](assets/image-20210517154343917.png)

- **小结**

- 了解版本管理的冲突问题及解决方案

## 分支的功能与分支管理

- **业务场景**

  - 开发一个APP
    - 普通的开发线
      - A、B、C
      - v1/v2/v3
    - VIP的开发线
      - A、B、C、D
      - v1/v2/v3
    - 测试开发线
      - A、B、C、D、E
      - v1/v2/v3
  - 问题：如果一个项目中多条开发线都需要做版本控制怎么办？
  - 解决：分支管理

- **分支管理**

  - 一个项目中可以有多个分支，每个分支独立管理各自的版本，默认只有一个分支：master

  - **创建分支**

    ![image-20210517161458782](assets/image-20210517161458782.png)

    ![image-20210517161505150](assets/image-20210517161505150.png)

  - **切换分支**

    ![image-20210517161512487](assets/image-20210517161512487.png)

    ![image-20210517161518562](assets/image-20210517161518562.png)

    ![image-20210517161705144](assets/image-20210517161705144.png)

    - 注意：测试vip分支与master 分支
      - 在vip分支中修改的这个版本，在master中是否能看到对应的修改？
        - 看不到
        - **==所有的分支是独立的==**
      - 在Master管理的文件或者版本，在vip中是否能看到？
        - 看不到

  - **删除分支**

    - 当前正在使用分支不允许删除

    - 删除其他的分支

      ![image-20210517161835128](assets/image-20210517161835128.png)

      ![image-20210517161841548](assets/image-20210517161841548.png)

      ![image-20210517161847459](assets/image-20210517161847459.png)

      ![image-20210517161853182](assets/image-20210517161853182.png)

- **小结**

  - 实现分支的管理

## 分支合并

> 实现分支的合并

- **需求**：将VIP的功能与普通的功能进行合并

  - 普通的APP：master
    - ABCD
  - VIP的APP：vip
    - ABCE
  - 这个功能可以给普通用户使用
    - 希望得到普通用户的APP
    - ABCDE

- 分支的合并

  - vip内容

    ```
    this is version 1
    this is master version 2
    this is vip vserion 3
    ```

  - master内容

    ```
    this is version 1
    this is master version 2
    this is master version 3
    
    ```

  - 希望得到的结果：master分支合并vip的分支的内容

    - 在Master中做一个新的版本

    - 这个操作是不影响vip分支的

      ```
      this is version 1
      this is master version 2
      this is master version 3
      this is vip vserion 3
      ```

  - 实现

    ![image-20210517162309263](assets/image-20210517162309263.png)

    ![image-20210517162314674](assets/image-20210517162314674.png)

    ![image-20210517162335791](assets/image-20210517162335791.png)

    ![image-20210517162341388](assets/image-20210517162341388.png)

    ![image-20210517162346256](assets/image-20210517162346256.png)

    ![image-20210517162351552](assets/image-20210517162351552.png)

    ![image-20210517162356079](assets/image-20210517162356079.png)

    ![image-20210517162401191](assets/image-20210517162401191.png)

    ![image-20210517162406125](assets/image-20210517162406125.png)

## IDEA、Pycharm等开发工具与Git集成

- **创建一个项目工程**

  ![image-20210517165812598](assets/image-20210517165812598.png)

  ![image-20210517165819097](assets/image-20210517165819097.png)

  ![image-20210517165825902](assets/image-20210517165825902.png)

- **配置与Git关联**

  ![image-20210517165836109](assets/image-20210517165836109.png)

  ![image-20210517165841948](assets/image-20210517165841948.png)

- **创建模块代码**

  ![image-20210517165851082](assets/image-20210517165851082.png)

  ![image-20210517165856042](assets/image-20210517165856042.png)

  ![image-20210517165901551](assets/image-20210517165901551.png)

  ![image-20210517165912074](assets/image-20210517165912074.png)

- **创建本地库设置忽略**

  ![image-20210517170339664](assets/image-20210517170339664.png)

  ![image-20210517170345180](assets/image-20210517170345180.png)

  ![image-20210517170437145](assets/image-20210517170437145.png)

  ![image-20210517170459871](assets/image-20210517170459871.png)

  ![image-20210517170526370](assets/image-20210517170526370.png)

  ![image-20210517170622104](assets/image-20210517170622104.png)

  ![image-20210517170700000](assets/image-20210517170700000.png)

- **添加并提交代码**

  ![image-20210517170707061](assets/image-20210517170707061.png)

  ![image-20210517170712900](assets/image-20210517170712900.png)

  ![image-20210517170718608](assets/image-20210517170718608.png)

  ![image-20210517170723548](assets/image-20210517170723548.png)

## IDEA中使用Git

- **目标**：实现IDEA中使用Git管理

- **实施**

  - **方式一：右键菜单**

    ![image-20210517171104601](assets/image-20210517171104601.png)

    

  - **方式二：VCS选项**

    ![image-20210517171257545](assets/image-20210517171257545.png)

  - **提交**

    ![image-20210517171312532](assets/image-20210517171312532.png)

    ![image-20210517171329383](assets/image-20210517171329383.png)

    ![image-20210517171334266](assets/image-20210517171334266.png)

    ![image-20210517171339359](assets/image-20210517171339359.png)

- **小结**

  - 实现IDEA中使用Git管理

## IDEA关联GitHub

> 实现IDEA与GitHub的集成

- **创建远程仓库**

  ![image-20210517171438157](assets/image-20210517171438157.png)

- **配置远程仓库地址**

  ![image-20210517171450188](assets/image-20210517171450188.png)

  ![image-20210517171455499](assets/image-20210517171455499.png)

  ![image-20210517171500554](assets/image-20210517171500554.png)

  ![image-20210517171507122](assets/image-20210517171507122.png)

- **同步到远程仓库**

  ![image-20210517171512880](assets/image-20210517171512880.png)

  ![image-20210517171522762](assets/image-20210517171522762.png)

  ![image-20210517171528275](assets/image-20210517171528275.png)

- **小结**

  - 实现IDEA与GitHub的集成

## IDEA协同开发拉取代码

> 实现IDEA拉取代码

![image-20210517171851077](assets/image-20210517171851077.png)

![image-20210517171855619](assets/image-20210517171855619.png)

![image-20210517171900871](assets/image-20210517171900871.png)

![image-20210517171905747](assets/image-20210517171905747.png)

![image-20210517171910766](assets/image-20210517171910766.png)

![image-20210517171915105](assets/image-20210517171915105.png)

![image-20210517171920077](assets/image-20210517171920077.png)

![image-20210517171926971](assets/image-20210517171926971.png)

![image-20210517171933279](assets/image-20210517171933279.png)

![image-20210517171938210](assets/image-20210517171938210.png)

![image-20210517171945244](assets/image-20210517171945244.png)

## IDEA中分支的使用

> 实现IDEA中分支的管理

- **方式一：右键菜单**

  ![image-20210517172443109](assets/image-20210517172443109.png)

- **方式二：右下角标签**

  ![image-20210517172451447](assets/image-20210517172451447.png)

- **创建分支**

  ![image-20210517172513599](assets/image-20210517172513599.png)

- **切换分支**

  ![image-20210517172524424](assets/image-20210517172524424.png)

  ![image-20210517172531001](assets/image-20210517172531001.png)

  - **删除分支**

    ![image-20210517172554591](assets/image-20210517172554591.png)

- **小结**

  - 实现IDEA中分支的管理

## 附录一：创建GitHub账号

- https://github.com/

![image-20200612121506841](assets/image-20200612121506841.png)

![image-20200612121601136](assets/image-20200612121601136.png)

![image-20200612121637185](assets/image-20200612121637185.png)

![image-20200612121702011](assets/image-20200612121702011.png)

![image-20200612121725840](assets/image-20200612121725840.png)

![image-20200612121824368](assets/image-20200612121824368.png)

![image-20200612121941675](assets/image-20200612121941675.png)

- **进入自己邮箱，点击按钮或者链接**

![image-20200612122135936](assets/image-20200612122135936.png)

![image-20200612122214740](assets/image-20200612122214740.png)