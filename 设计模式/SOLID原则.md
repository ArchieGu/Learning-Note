# SOLID原则

SOLID原则由5个设计原则组成：单一职责原则、开闭原则、里式替换原则、接口隔离原则和依赖反转原则。

## 单一职责原则 (SRP)

Single Responsibility Principle (SRP)。一个类或者模块只负责完成一个职责（功能）。不要设计大而全的类，要设计粒度小、功能单一的类。

在实际设计时，可以先写一个粗粒度的类，满足业务需求。随着业务发展，如果粗粒度的类越来越大，之后就可以将粗粒度的类，拆分成更细粒度的类。这就是所谓的**持续重构**。

如何判断类是否职责单一或是否需要拆分：

1. 类的代码行数、函数或属性过多，影响代码的可读性和可维护性
2. 类依赖其他类过多，或者依赖类的其他类过多，不符合高内聚、低耦合的设计思想
3. 私有方法过多，需要考虑能否将私有方法独立到新的类中，设置为 public 方法，供更多的类使用，从而提高代码的复用性
4. 难以给类起合适的名字，难用一个业务名词概括或者只能用一些笼统的Manager、Context 之类的词语来命名，这就说明类的职责定义得可能不够清晰；类中大量的方法都是集中操作类中的某几个属性，就可以考虑将这几个属性和对应的方法拆分出来

> 将代码的可读性、可扩展性、复用性、可维护性等作为设计的最终的考量标准

## 开闭原则 (OCP)

Open Closed Principal (OCP)  对扩展开放、对修改关闭。简单理解：添加新的功能是在已有代码的基础上扩展代码（新增模块、类、方法等），而非修改已有代码（修改模块、类、方法等）。

> 如果通过修改已有代码实现功能，则意味着需要可能需要修改调用方式，以及修改对应的单元测试。

如何才能遵循开闭原则？举例介绍：

1. 将涉及到的多个入参封装成一个类，之后如果入参有修改的话，只需要在新类中进行修改，这样就不会涉及到接口调用的修改
2. 引入handler概念，将各个逻辑分散在各自的handler中，之后新加功能，应该可以通过继承或者override来进行。
3. 【基于接口而非实现编程，抽象意识】在进行功能开发时，要将操作抽象成与具体实现无关的接口，上层系统依赖该抽象的接口编程，并通过依赖注入的方式来调用。当底层的具体实现要进行替换时，也能很方便的进行替换。

> 需要认识到，添加一个新的功能，不可能任何模块、类、方法都不进行“修改”，修改是在所难免的。需要做的是尽量让修改操作更集中、更少、更上层，尽量让最核心、最复杂的那部分逻辑代码满足开闭原则。【所以修改代码并不意味着一定是违反开闭原则】

预留扩展点的合理做法有：对于一些比较确定的、短期内可能需要扩展，或者需求改动对代码结构影响比较大的情况，或者实现成本不高的扩展点，在编写代码的时候，可以预先做扩展性设计。对于那些不确定未来是否需要支持的需求或者实现起来比较复杂的扩展点，可以等到有需求驱动的时候，再通过重构代码的方式来支持扩展的需求。

> 对扩展开放是为了应对变化(需求)，对修改关闭是为了保证已有代码的稳定性；最终结果是为了让系统更有弹性！

## 里氏替换 (LSP) 

Liskov Substitution Principle (LSP). Function that use pointers of references to base classses must be able to use objects of derived classes without knowing it. 即子类对象能够替换父类对象出现的任何地方，并且保证原来程序的逻辑行为不变以及正确性不被破坏。

代码举例：

```java
// Parent Class
public class Transporter {
	private HttpClient httpClient;
	public Transporter(HttpClient httpClient) {
		this.httpClient = httpClient;
	}	
	public Response sendRequest(Request request) {
	// ...use httpClient to send request
	}
}
```

```java
// Child Class 
public class SecurityTransporter extends Transporter {
    private String appId;
    private String appToken;
    public SecurityTransporter(HttpClient httpClient, String appId, String appToken){
        super(httpClient);
        this.appId = appId;
        this.appToken = appToken;
    }
    @Override
    public Response sendRequest(Request request) {
        if (StringUtils.isNotBlank(appId) && StringUtils.isNotBlank(appToken)) {
            request.addPayload("app-id", appId);
            request.addPayload("app-token", appToken);
        }
    	return super.sendRequest(request);
    }
}
```

```java
// Function execution entry
public class Demo {
    public void demoFunction(Transporter transporter) {
    Reuqest request = new Request();
    //... 省略设置 request 中数据值的代码...
    Response response = transporter.sendRequest(request);
    //... 省略其他逻辑...
    }
}

// 里式替换原则
Demo demo = new Demo();
demo.demofunction(new SecurityTransporter(/* 省略参数 */););
```

这段代码中，子类继承父类，并增加额外功能，使其支持传输appId和appToken安全认证信息。子类设计遵循LSP原则，在demofunction中，传入子类和父类在执行过程中，程序的逻辑行为没有变化。

### LSP与多态

多态是面向对象编程的一大特性，也是面向对象编程语言的一种语法。它是一种代码实现的思路。

里式替换是一种设计原则，是用来指导继承关系中子类该如何设计的，子类的设计要保证在替换父类的时候，不改变原有程序的逻辑以及不破坏原有程序的正确性。

### 什么样的代码会违背LSP

如何有效的遵循LSP？Design By Contract （按照协议来编程）。子类在设计的时候，要遵循父类的行为约定。父类定义了函数行为约定，子类可以改变其内部实现逻辑，但不能改变其原有的行为约定。行为约定包含：函数声明要实现的功能；对输入、输出、异常处理的约定。【类似接口与实现类的关系】

判断子类设计是否违背LSP的窍门：拿父类的单元测试去验证子类的代码，如果测试失败，则有可能是子类的设计没有遵循LSP

## 接口隔离原则 (ISP)

Interface Segregation Principle (ISP)。 Clients should not be forced to depend upon interfaces that they do not use.

接口可以有三种理解：一组API接口集合、单个API接口或函数、OOP中的接口概念。

一组接口集合：在设计微服务或者类库接口的时候，如果部分接口只被部分调用者使用，则应将这部分接口隔离出来，单独给调用者使用，而不是强迫其他调用者也依赖这部分不会被用到的接口。

单个API接口或函数：接口或函数的设计要功能单一，不能将多个不同的功能逻辑放在一个接口或函数中实现。如果调用者只使用部分接口或接口的部分功能，那接口的设计就不够职责单一

OOP中的接口概念：面向对象中的接口语法。接口的设计要尽量单一，不要让接口的实现类和调用者，依赖不需要的接口函数

## 依赖反转

### 控制反转 (IOC)

Inversion Of Control (IOC)。可以通过框架来实现“控制反转”，框架提供了一个可扩展的代码骨架，用来组装对象、管理整个执行流程。再利用框架开发时，只需要在预留的扩展点上，添加跟自己业务相关的代码，就可以利用框架来驱动整个程序流程的执行。“控制”指的是对程序执行流程的控制，“反转”指在没有使用框架前，程序员自己控制整个程序的执行。在使用框架后，整个程序的执行流程可以通过框架进行控制。流程的控制权从程序员“反转”到了框架。

### 依赖注入 (DI)

Dependency Injection (DI).什么是依赖注入：不通过new()的方式在类内部创建依赖类对象，而是将依赖的类对象在外部创建好之后，通过构造函数、函数参数等方式传递（或注入）给类使用。

```java
// 非依赖注入实现方式
public class Notification {
    private MessageSender messageSender;
    public Notification() {
    	this.messageSender = new MessageSender(); // 此处有点像 hardcode
    }
    public void sendMessage(String cellphone, String message) {
        //... 省略校验逻辑等...
        this.messageSender.send(cellphone, message);
    }
}
public class MessageSender {
	public void send(String cellphone, String message) {
        //....
	}
}
// 使用 Notification
Notification notification = new Notification();
```

通过依赖注入的方式来将依赖的类对象传递进来，这样就提高了代码的扩展性，也可以灵活地替换依赖的类。

```java
// 依赖注入的实现方式
public class Notification {
    private MessageSender messageSender;
    // 通过构造函数将 messageSender 传递进来
    public Notification(MessageSender messageSender) {
    	this.messageSender = messageSender;
    }
    public void sendMessage(String cellphone, String message) {
        //... 省略校验逻辑等...
        this.messageSender.send(cellphone, message);
    }
}
// 使用 Notification
MessageSender messageSender = new MessageSender();
Notification notification = new Notification(messageSender);
```

### 依赖注入框架 (DI Framework)

```java
public class Demo {
    public static final void main(String args[]) {
        MessageSender sender = new SmsSender(); // 创建对象
        Notification notification = new Notification(sender);// 依赖注入
        notification.sendMessage("13918942177", " 短信验证码：2346");
    }
}
// 虽然不在类内部创建MessageSender对象了，但创建、注入等步骤只是挪到了更上层的代码罢了，还是需要程序员自己来实现。类多了之后会十分复杂。
```

由于对象创建和依赖注入工作，本身与具体业务无关，所以可以抽象成框架来自动完成。配置所有需要创建的类对象、类与类之间的依赖关系，就可以实现由框架来自动创建对象、管理对象生命周期、依赖注入等事情。

### 依赖反转原则 (DIP)

Dependency Inversion Principle (DIP)。 高层模块不要依赖底层模块；高层模块与底层模块应该通过抽象(abstractions)来互相依赖。抽象(abstractions)不要依赖具体实现细节(details)，具体实现细节(details)依赖抽象(abstractions).

> 在调用链上，调用者属于高层，被调用者属于低层。

