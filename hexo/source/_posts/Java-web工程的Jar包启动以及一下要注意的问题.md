title: Java web工程的Jar包启动以及一下要注意的问题
author: ZP
date: 2024-02-24 14:05:24
tags:
---
现在SpringBoot工程越来越常见，这个JAR文件包含了应用程序所有的依赖，以及一个内嵌的Servlet容器（如Tomcat或Jetty）。这意味着你可以像运行一个普通的Java应用程序一样运行你的Spring Boot应用，而不需要额外的Web服务器或应用服务器。

也就是说对应之前最早的像SSM这样的工程不一样，不需要放在tomcat里面去启动web工程。我们SpringBoot的web工程直接通过命令行形式就可以启动。


打包过程：

我们选择到对应的web工程模块，通过maven命令来打包，pom文件对应的打包形式也是jar包

```
    <packaging>jar</packaging>
```

我们用idea现成的工具就可以打包，在IDEA中进行打包操作。选择 "View" > "Tool Windows" > "Maven"，在打开的Maven窗口中，展开 "Lifecycle"，然后双击 "clean" 和 "package"。


一般来说打的jar包位置都会在maven打包命令执行时会输出在命令行里，你也可以在对应的项目目录里面去找，会有对应的target包里面有。

执行jar包:
我们找到对应的jar包的位置，可以直接在idea的命令行里面执行java的jar命令来执行启动jar包。

```
java -jar filename.jar

比如
java -jar E:\xxx_new_0512\xxx-web\target\xxx-web-1.0.0-SNAPSHOT.jar      
```

有的时候我们会有多种环境配置文件，我们可以指定对应的执行环境配置：

```
java -jar E:\xxx_new_0512\xxx-web\target\xxx-web-1.0.0-SNAPSHOT.jar --spring.profiles.active=t1   
```
如果是web工程，你可以像本地启动tomcat的web项目一样，去检查项目是否是正式启动。

需要注意的问题：
jar和war包有什么区别？
其实war包就是一种特殊的jar包，JAR文件通常包含Java类文件（.class文件）和相关的元数据和资源（如文本、图片等）。它们可以包含任何你想要打包的内容，例如：Java库、应用程序等。它是Java应用程序的常见发布格式，可以被Java运行时环境（JRE）直接执行。

war包就是用于打包Java Web应用程序。WAR文件的结构遵循Java EE标准，包含了Web应用程序需要的所有内容，如：JSP、Java类、图片、库文件（lib文件夹下的JAR文件）、部署描述符（WEB-INF/web.xml）等。WAR文件通常被部署在一个支持Java EE的Web服务器或应用服务器（如Tomcat、Jetty、GlassFish、JBoss等）上。

所以如果你的web工程时现在使用比较广泛的Spring Boot的web工程，jar包就可以，因为他内嵌了一个web服务器在里面。如果你的是旧的需要依赖web服务器的只能用war包，要通过传统方式来启动。

Spring Boot多个模块形式，打包web工程模块并启动，但是改动没有生效？

web工程是多种模块/module的形式，这些模块是依赖关系，如果我们的修改不是对应web模块，我们打包的module模块的jar包是没有更新修改，因为jar包里面对应修改的依赖jar包没有更新。

所以最好是对整个工程，执行maven命令clean 以及install构建一下项目，然后再去对应的web工程模块构建打包。

如何查看jar包内容？
我想知道jar包内容，可以通过反编译工具来查看，我们可以查看jar包是否构建最新的修改，以及里面对应依赖包的版本。（反编译（Decompiling）是将已编译的程序代码（通常是机器代码或字节码）转换回源代码的过程。这个过程并不总是能够完全准确，因为在编译过程中，源代码中的一些信息（如注释、格式化、局部变量名等）可能会丢失。）

这里我推荐几个工具，一个是可视化工具JD-GUI，另一种是要下载在命令行中运行的反编译器，这一类要麻烦一些。下载对应的文件，比如说Procyon。从GitHub下载Procyon的jar文件，使用以下命令来运行Procyon反编译器：

```
java -jar procyon-decompiler.jar -jar <input>.jar -o <output_directory>
```
如果你想反编译一个名为example.jar的jar文件，并将反编译后的代码保存在名为decompiled的文件夹中，你可以运行以下命令：

```
java -jar procyon-decompiler.jar -jar example.jar -o decompiled

```
打开对应的decompiled，就是对应的jar包反编译文件。