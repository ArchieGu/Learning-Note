# Generics (泛型)

## [什么是泛型]()

Generics make it possible to design classes and methods that defer the specification of one or more types until the class or method is declared and instantiated by client code.

在定义类、接口或者方法时可以指定类型参数。参数类型可以在使用类、接口或者方法时动态指定。这样就可以编写一个可以与任何数据类型一起工作的类或者方法。

```c#
// Use Generic coding to implement stack support multiple value types
public class SimpleStack<T>
{
	private readonly T[] _items;
    private int _currentIndex = -1;
    public SimpleStack() => _items = new T[10];
    public int Count => _currentIndex + 1;
    public void Push(T item) => _items[++_currentIndex] = item;
    public T Pop() => _items[_currentIndex--];
}
// the value type was defined when calling the method
private static voin StackDoubles()
{
    var stack = new SimpleStack<double>();
    stack.Push(1.2);
}
private static void StackStrings()
{
    var stack = new SimpleStack<string>();
    stack.Push("This is a string");
}
```

## [为什么需要泛型]()

在编写程序时，经常遇到功能非常相似但处理数据不一样的模块，只能分别写多个方法来处理不同的数据类型。利用泛型，可以用同一个方法来传入不同类型的参数。

## [泛型的好处]()

### [代码重用]()

在没有Generics之前，可以利用OOP三大特点之一的继承（C#所有类型都源于Object）让一个method处理不同类型的数据参数。【否则只能一个类型写一个method，产生大量duplicate代码】

```c#
//This is the approach of using inherit feature of OOD
public class GenericClass
{
    public void ShowObj(object obj)
    {
        Console.WriteLine("ShowObj print {0},ShowObj Parament Type Is {1}", obj, obj.GetType());
    }
}
static void Main(string[] args)
{
    Console.WriteLine("*****************object调用*********************");
    generice.ShowObj(11);
    generice.ShowObj(DateTime.Now);
    generice.ShowObj(new People { Id = 11, Name = "Tom" });
    Console.ReadKey();
}

// This is the Generic approach
public class GenericClass<T>
{
    public void ShowObj(T item)
    {
        Console.WriteLine("ShowObj print {0},ShowObj Parament Type Is {1}", item, item.GetType());
    }
}
```

这是一个装箱拆箱的操作（类型转换），会损耗性能。详解见[什么是装箱拆箱，以及性能损耗]()。

### [类型安全]()

当我们利用[代码重用]()小节的OOD继承例子实现代码复用时，我们降低了方法的类型安全性。以SimpleStack()举例，当我们使用继承和装箱拆箱进行实现时，我们能够往stack中放入任何类型的数据，只有当编译运行时才会报错。

```c#
var stack = new SimpleStack<double>();
stack.Push("Thomas"); // Does not compile
```

而使用泛型时，一旦发现类型不匹配，就会及早进行报错。

### [不降低性能]()

#### [什么是装箱拆箱，以及性能损耗]()

拆箱装箱就是值类型与引用类型的转换，由于值类型与引用类型在内存分配的不同，从内存执行的角度来讲，拆箱与装箱包括内存的分配与数据的拷贝等操作，这也是装箱拆箱影响性能的根源。

- 装箱：值类型 --> 引用类型
- 拆箱： 引用类型 --> 值类型

> 程序在内存中的存放形式与结构：内存的分布主要包括栈、堆、全局存储区 (静态存储区)、常量区、程序代码区
>
> 堆 (heap): 一般**由程序员自己分配与手动释放**，若程序员未进行释放，则会在程序结束时由OS进行回收，这是会产生内存泄露。
>
> - `内存溢出(out of memory)：程序运行过程中申请的内存大于系统能够提供的内存，导致无法申请到足够的内存；`
>
> - `内存泄露(memory leak)：程序运行过程中分配内存给临时变量，用完之后却没有被GC回收，始终占用着内存，既不能使用也没法分配给其他程序`
>
>   memory leak 最终会导致 out of memory.
>
> 栈 (stack)：由**编译器自动分配与释放**，例如函数的参数值，局部变量的值
>
> 全局区 (static)：存放全局变量与静态变量，由系统在程序结束后释放，无需手动申请和释放。
>
> 常量区：宏定义的常量字符串、整数等，由系统在程序结束后释放。
>
> 程序代码区：存放代码运行时的相关数据，包括一些静态库、动态库、主函数代码等
>
> **堆栈的不同：**
>
> 1. 分配方式不同：栈系统分配与回收；堆由开发人员手动申请与释放
> 2. 分配效率不同：栈时机器系统提供的数据结构，计算机在底层对栈提供支持：分配专门的寄存器存放栈的地址，压栈出栈由专门的指令执行。【栈操作是CPU直接对内存寄存器进行操作，效率非常高】堆的申请与分配则是C++库提供的方法，效率要低于栈
> 3. 空间不同：栈的空间非常小，默认1MB；堆可以分配更大的空间资源，只要内存够大就行
> 4. 碎片问题：栈不存在碎片问题。因为是直接操作内存寄存器，只要栈的剩余空间大于申请空间，就可以提供内存，否则就会提示栈溢出。但是堆的大小不是确定的，随着不断申请与不断释放，越往后越难以找到连续的空闲内存，能够继续进行分配。
>    - 碎片化的后果：当在内存中找不到刚好大小的连续内存区域，C++库就会挑几个空闲的内存进行拼接，形成一个内存空间，这样不连续的内存在访问效率上一定是低于连续内存空间的，导致了性能下降。
> 5. 生长方式不同：栈向下；堆向上（不知道这条有啥用）

装箱过程：

1. 在堆中申请内存，内存大小为值类型的大小再加上额外固定空间
2. 将值类型的字段值拷贝到新分配的内存中
3. 返回新引用对象的地址给引用变量object o

![img](https://pic4.zhimg.com/80/v2-b8dc4b02ea79b3a1f83eb9831ed96557_1440w.png)

拆箱过程：

1. 检查实例对象o是否有效，如否返回null，检查颀装箱的类型和拆箱的类型是否一致，不一致则抛出异常

2. 指针返回，获取装箱对象object o中值类型的字段值的地址

3. 字段拷贝。把装箱对象object o 中值类型字段值拷贝到栈上，创建一个新的值类型变量来储存拆箱后的值。

   ![img](https://pic3.zhimg.com/80/v2-56d2c4fc54b32db9b48dd1432ccbeb32_1440w.png)

为了避免这种性能损失，需要尽可能减少装箱拆箱操作，也就是使用泛型来解决代码重用的问题。

```c#
var stack = new SimpleStack<double>();
stack.Push(2.8); // No boxing
```

## 如何使用泛型

`Use the namespace "System.Collections.Generic"`, Stack<T> Class of .NET

这里包含了 `List<T> Queue<T> Stack<T> Dictionary<TKey, TValue>` 等Generic类型

```c#
using System.Collections.Generic;
var stack = new Stack<string>();
var stack = new Stack<double>();
```

### 泛型的继承

既可以创建non-Generic SubClass 也可以创建Generic SubClass。

```c#
// Non-Generic class that inherits from the generic class 
public class EmployeeRepoWithRemove : GenericRepo<Employee>
{
    public void Remove(Employee employee)
    {
        _items.Remove(employee);
    }
}

//Generic class that inherits from the generic class
public class EmployeeRepoWithRemove<T> : GenericRepo<T> //when subclass gets a type, the type will also be passed to the base class
{
    public void Remove(T item) //Cuz we passed T to the base class, so the items list is now a list of T, so the remove method should take a T value
    {
        _items.Remove(item);
    }
}
```

### 泛型约束

泛型约束基本上有五类：

1. 值类型约束
2. 引用类型约束
3. 构造函数约束
4. 接口约束
5. 基类约束

#### 类型约束

当未加任何约束时，我们再泛型类中只能访问Object value包含的几种方法 `Equals, GetHashCode, GetType, ToString`。因为再实例化时，确认的参数有可能时任何类型的，所以在泛型类中只能提供最基础的Object Value提供的方法。

增加泛型约束后（要求泛型参数必须是某个值类型，如int, shourt），增加了可调用的操作和方法的数量。这些操作和方法受约束类型及其派生层次中的类型的支持。因此，设计泛型类或方法时，如果对泛型成员执行任何赋值以外的操作，或者是调用System.Object中所没有的方法，就需要在类型参数上使用约束。

```c#
public class EntityBase
{
    public int Id { get; set; } // fix id's value type to int, so class inherits this base class can use Id's (int) method. 
}

public class Employee : EntityBase // Inherites from EntityBase Class
{
	public string? Name { get; set; }  
    public override string ToString() => $"Id: {id} , Name: {Name}"; // The id property is from base class 
}

public class GenericRepo<T> where T:EntityBase // Add Generic constrains, variables will have access to properties and methods defined in EntityBase
{
    private readonly List<T> _items = new();
    public T GetById(int id)
    {
        return _itmes.Single(item => item.id == id); // Now item can have access to property "Id"
    }
}
```

#### 引用类型约束

要求泛型参数必须是引用类型，如string，自定义的class等可以利用接口类来进行实现。

#### new() Constrain

如果需要泛型类需要一个无参构造函数，则需要使用new()约束，在于其他泛型约束一起使用时，new()必须放在约束最后。

```c#
public class GenericRepo<T> where T : class, IEntity, new() // Notice new() should be the last one
{
    private readonly List<T> _items = new();
    public T CreateItem()
    {
        return new T() // with new() constain, we can create instances of type T by calling the parameterless constructor。
    }
}

public class Employee : EntityBase
{
    public Employee(string Name) // This will give an error, because we can only use a parameterless constructor.
    {
        
    }
}
```

### 泛型接口

