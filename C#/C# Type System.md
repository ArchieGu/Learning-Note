# C# Type System

## Built-in C# Data Types

C# is a strongly typed language, every variable has a type. Type is used to store information and expressions will return a value of a specified type.

**What Data type can tell us ? :**

1. data size and location in memory
2. data range
3. supported operations
4. Return value of an expression

![img](https://i2.paste.pics/fbbbc85c70653e6297c98f9ec5dc569a.png?trs=e7bf35ba0c909e5db4e26aa047f4fb48842d4d4b861b2329ac973849eaa500e0)

Depending on the data type, the value will be stored in different location in memory. Value data type will be stored on stack, while reference data type will be stored on heap. 

> The actual data of reference data type is stored on the heap, but its reference (index) will be stored on stack.

For easy to use, there are some Primitive types which only use lower cases, are used to create new instances.

| Primitive type | Backing Type |
| :------------: | :----------: |
|      int       |    Int32     |
|     float      |    Float     |
|    decimal     |   Decimal    |
|      bool      |   Boolean    |
|      byte      |     Byte     |

