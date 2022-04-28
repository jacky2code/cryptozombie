# 学习 Solidity 完成一个 CryptoZombie 游戏项目

> 本教程只是把 https://cryptozombies.io/zh 网站中的教程摘录下来，用于学习回顾，具体实操请在网站上学习实践，酌情参考。



## 1. 开始一个中级的智能合约

你认为你可以当一个合格的 **CryptoZombie**, 嗯？

这个教程会教你如何搭建一个**以太网的游戏**。

此课程为 Solidity 初学者设计，需要你对其他的程序语言有所了解（如 JavaScript)。

### 1.1 搭建僵尸工厂

#### 第1章 概述

第一课你将创造一个"僵尸工厂"， 用它建立一支僵尸部队。

- 我们的工厂会把我们部队中所有的僵尸保存到数据库中
- 工厂会有一个函数能产生新的僵尸
- 每个僵尸会有一个随机的独一无二的面孔

在后面的课程里，我们会增加功能。比如，让僵尸能攻击人类或其它僵尸! 但是在实现这些好玩的功能之前，我们先要实现创建僵尸这样的基本功能。

##### 僵尸 DNA 如何运作

僵尸的面孔取决于它的DNA。它的DNA很简单，由一个16位的整数组成：

``` bash
8356281049284737
```

如同真正的DNA, 这个数字的不同部分会对应不同的特点。 前2位代表头型，紧接着的2位代表眼睛，等等。

> *注: 本教程我们尽量简化。我们的僵尸只有7种头型(虽然2位数字允许100种可能性)。以后我们会加入更多的头型, 如果我们想让僵尸有更多造型。*

例如，前两位数字是 `83`， 计算僵尸的头型，我们做`83 % 7 + 1` = 7 运算， 此僵尸将被赋予第七类头型。

在右边页面，移动头基因`head gene` 滑块到第七位置(圣诞帽)可见`83`所对应的特点。

##### 实战演习

1. 玩一下页面右侧的滑块。检验一下不同的数字对应不同的僵尸的长相。

好了，这已经足够你玩一会儿了。 当你想继续的时候，点击下面的"下一章"，让我们来钻研 Solidity ！

<img src="https://markdown-res.oss-cn-hangzhou.aliyuncs.com/mdImgs/2022/04/28/20220428104132.png" align="center" style="width:500px" />



#### 第2章 合约

从最基本的开始入手:

Solidity 的代码都包裹在**合约**里面. 一份`合约`就是以太应币应用的基本模块， 所有的变量和函数都属于一份合约, 它是你所有应用的起点.

一份名为 `HelloWorld` 的空合约如下:

``` solidity
contract HelloWorld {

}
```

##### 版本指令

所有的 Solidity 源码都必须冠以 "version pragma" — 标明 Solidity 编译器的版本. 以避免将来新的编译器可能破坏你的代码。

例如: `pragma solidity ^0.4.19;` (当前 Solidity 的最新版本是 0.4.19).

综上所述， 下面就是一个最基本的合约 — 每次建立一个新的项目时的第一段代码:

``` solidity
pragma solidity ^0.4.19;

contract HelloWorld {

}
```

##### 实战演习

为了建立我们的僵尸部队， 让我们先建立一个基础合约，称为 `ZombieFactory`。

1. 在右边的输入框里输入 `0.4.19`，我们的合约基于这个版本的编译器。
2. 建立一个空合约 `ZombieFactory`。

一切完毕，下面 "答案" ：

``` solidity
pragma solidity ^0.4.19; //1. 这里写版本指令

//2. 这里建立智能合约
contract ZombieFactory {
}
```



#### 第3章 状态变量和整数

真棒！我们已经为我们的合约做了一个外壳， 下面学习 Solidity 中如何使用变量。

##### 状态变量

***状态变量*** 是被永久地保存在合约中。也就是说它们被写入以太币区块链中. 想象成写入一个数据库。

例子：

``` solidity
contract Example {
  // 这个无符号整数将会永久的被保存在区块链中
  uint myUnsignedInteger = 100;
}
```

在上面的例子中，定义 `myUnsignedInteger` 为 `uint` 类型，并赋值100。

##### 无符号整数 uint

`uint` 无符号数据类型， 指**其值不能是负数**，对于有符号的整数存在名为 `int` 的数据类型。

> *注: Solidity中，* `uint` *实际上是* `uint256`*代名词， 一个256位的无符号整数。你也可以定义位数少的uints —* `uint8`*，* `uint16`*，* `uint32`*， 等…… 但一般来讲你愿意使用简单的* `uint`*， 除非在某些特殊情况下，这我们后面会讲。*

##### 实战演习

我们的僵尸DNA将由一个十六位数字组成。

定义 `dnaDigits` 为 `uint` 数据类型, 并赋值 `16`。

``` solidity
pragma solidity ^0.4.19;

contract ZombieFactory {
    uint dnaDigits = 16;
}
```



#### 第4章 数学运算

在 Solidity 中，数学运算很直观明了，与其它程序设计语言相同:

- 加法: `x + y`
- 减法: `x - y`,
- 乘法: `x * y`
- 除法: `x / y`
- 取模 / 求余: `x % y` *(例如, `13 % 5` 余 `3`, 因为13除以5，余3)*

Solidity 还支持 ***乘方操作\*** (如：x 的 y次方） // 例如： 5 ** 2 = 25

```solidity
uint x = 5 ** 2; // equal to 5^2 = 25
```

##### 实战演习

为了保证我们的僵尸的DNA只含有16个字符，我们先造一个`uint`数据，让它等于10^16。这样一来以后我们可以用模运算符 `%` 把一个整数变成16位。

1. 建立一个`uint`类型的变量，名字叫`dnaModulus`, 令其等于 **10 的 `dnaDigits` 次方**.

``` solidity
pragma solidity ^0.4.19;

contract ZombieFactory {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
}
```



#### 第5章 结构体

有时你需要更复杂的数据类型，Solidity 提供了 **结构体**:

```solidity
struct Person {
  uint age;
  string name;
}
```

结构体允许你生成一个更复杂的数据类型，它有多个属性。

> 注：我们刚刚引进了一个新类型, `string`。 字符串用于保存任意长度的 UTF-8 编码数据。 如： `string greeting = "Hello world!"`。

##### 实战演习

在我们的程序中，我们将创建一些僵尸！每个僵尸将拥有多个属性，所以这是一个展示结构体的完美例子。

1. 建立一个`struct` 命名为 `Zombie`.
2. 我们的 `Zombie` 结构体有两个属性： `name` (类型为 `string`), 和 `dna` (类型为 `uint`)。

``` solidity
pragma solidity ^0.4.19;

contract ZombieFactory {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }
}
```



#### 第6章 数组

如果你想建立一个集合，可以用 **_数组_**这样的数据类型. Solidity 支持两种数组: **_静态_** 数组和**_动态_** 数组:

```solidity
// 固定长度为2的静态数组:
uint[2] fixedArray;
// 固定长度为5的string类型的静态数组:
string[5] stringArray;
// 动态数组，长度不固定，可以动态添加元素:
uint[] dynamicArray;
```

你也可以建立一个 ***结构体*** 类型的数组 例如，上一章提到的 `Person`:

```solidity
Person[] people; // 这是动态数组，我们可以不断添加元素
```

记住：状态变量被永久保存在区块链中。所以在你的合约中创建动态数组来保存成结构的数据是非常有意义的。

##### 公共数组

你可以定义 `public` 数组, Solidity 会自动创建 ***getter*** 方法. 语法如下:

```solidity
Person[] public people;
```

其它的合约可以从这个数组读取数据（但不能写入数据），所以这在合约中是一个有用的保存公共数据的模式。

##### 实战演习

为了把一个僵尸部队保存在我们的APP里，并且能够让其它APP看到这些僵尸，我们需要一个公共数组。

1. 创建一个数据类型为 `Zombie` 的结构体数组，用 `public` 修饰，命名为：`zombies`.

``` solidity
pragma solidity ^0.4.19;

contract ZombieFactory {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;
}
```



#### 第7章 定义函数

在 Solidity 中函数定义的句法如下:

```solidity
function eatHamburgers(string _name, uint _amount) {
}
```

这是一个名为 `eatHamburgers` 的函数，它接受两个参数：一个 `string`类型的 和 一个 `uint`类型的。现在函数内部还是空的。

> 注：: 习惯上函数里的变量都是以(`_`)开头 (但不是硬性规定) 以区别全局变量。我们整个教程都会沿用这个习惯。

我们的函数定义如下:

```solidity
eatHamburgers("vitalik", 100);
```

##### 实战演习

在我们的应用里，我们要能创建一些僵尸，让我们写一个函数做这件事吧！

1. 建立一个函数 `createZombie`。 它有两个参数: **_name** (类型为`string`), 和 **_dna** (类型为`uint`)。

暂时让函数空着——我们在后面会增加内容。

``` solidity
// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.19;

contract ZombieFactory {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function createZombie(string calldata _name, uint _dna) public {
    }
}
```



#### 第8章 使用结构体和数组

##### 创建新的结构体

还记得上个例子中的 `Person` 结构吗？

```solidity
struct Person {
  uint age;
  string name;
}

Person[] public people;
```

现在我们学习创建新的 `Person` 结构，然后把它加入到名为 `people` 的数组中.

```solidity
// 创建一个新的Person:
Person satoshi = Person(172, "Satoshi");

// 将新创建的satoshi添加进people数组:
people.push(satoshi);
```

你也可以两步并一步，用一行代码更简洁:

```solidity
people.push(Person(16, "Vitalik"));
```

> 注：`array.push()` 在数组的 **尾部** 加入新元素 ，所以元素在数组中的顺序就是我们添加的顺序， 如:

```solidity
uint[] numbers;
numbers.push(5);
numbers.push(10);
numbers.push(15);
// numbers is now equal to [5, 10, 15]
```

##### 实战演习

让我们创建名为createZombie的函数来做点儿什么吧。

1. 在函数体里新创建一个 `Zombie`， 然后把它加入 `zombies` 数组中。 新创建的僵尸的 `name` 和 `dna`，来自于函数的参数。
2. 让我们用一行代码简洁地完成它。

``` solidity
// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function createZombie(string calldata _name, uint _dna) public {
        zombies.push(Zombie(_name, _dna));
    }
}
```



#### 第9章: 私有 / 公共函数

Solidity 定义的函数的属性默认为`公共`。 这就意味着任何一方 (或其它合约) 都可以调用你合约里的函数。

显然，不是什么时候都需要这样，而且这样的合约易于受到攻击。 所以将自己的函数定义为`私有`是一个好的编程习惯，只有当你需要外部世界调用它时才将它设置为`公共`。

如何定义一个私有的函数呢？

```solidity
uint[] numbers;

function _addToArray(uint _number) private {
  numbers.push(_number);
}
```

这意味着只有我们合约中的其它函数才能够调用这个函数，给 `numbers` 数组添加新成员。

可以看到，在函数名字后面使用关键字 `private` 即可。和函数的参数类似，私有函数的名字用(`_`)起始。

##### 实战演习

我们合约的函数 `createZombie` 的默认属性是公共的，这意味着任何一方都可以调用它去创建一个僵尸。 咱们来把它变成私有吧！

1. 变 `createZombie` 为私有函数，不要忘记遵守命名的规矩哦！

``` solidity
// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string calldata _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
    }
}
```



#### 第10章: 函数的更多属性

本章中我们将学习函数的返回值和修饰符。

##### 返回值

要想函数返回一个数值，按如下定义：

```solidity
string greeting = "What's up dog";

function sayHello() public returns (string) {
  return greeting;
}
```

Solidity 里，函数的定义里可包含返回值的数据类型(如本例中 `string`)。

##### 函数的修饰符

上面的函数实际上没有改变 Solidity 里的状态，即，它没有改变任何值或者写任何东西。

这种情况下我们可以把函数定义为 ***view***, 意味着它只能读取数据不能更改数据:

```solidity
function sayHello() public view returns (string) {
```

Solidity 还支持 ***pure*** 函数, 表明这个函数甚至都不访问应用里的数据，例如：

```solidity
function _multiply(uint a, uint b) private pure returns (uint) {
  return a * b;
}
```

这个函数甚至都不读取应用里的状态 — 它的返回值完全取决于它的输入参数，在这种情况下我们把函数定义为 ***pure***.

> 注：可能很难记住何时把函数标记为 pure/view。 幸运的是， Solidity 编辑器会给出提示，提醒你使用这些修饰符。

##### 实战演习

我们想建立一个帮助函数，它根据一个字符串随机生成一个DNA数据。

1. 创建一个 `private` 函数，命名为 `_generateRandomDna`。它只接收一个输入变量 `_str` (类型 `string`), 返回一个 `uint` 类型的数值。
2. 此函数只读取我们合约中的一些变量，所以标记为`view`。
3. 函数内部暂时留空，以后我们再添加代码。

``` solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.19;

contract ZombieFactory {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string calldata _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
    }

    function _generateRandomDna(string calldata _str) private view returns (uint) {

    }
}
```













