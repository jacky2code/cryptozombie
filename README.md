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



#### 第9章 私有 / 公共函数

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



#### 第10章 函数的更多属性

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



#### 第11章 Keccak256 和 类型转换

如何让 `_generateRandomDna` 函数返回一个全(半) 随机的 `uint`?

Ethereum 内部有一个散列函数`keccak256`，它用了SHA3版本。一个散列函数基本上就是把一个字符串转换为一个256位的16进制数字。字符串的一个微小变化会引起散列数据极大变化。

这在 Ethereum 中有很多应用，但是现在我们只是用它造一个伪随机数。

例子:

```bash
//6e91ec6b618bb462a4a6ee5aa2cb0e9cf30f7a052bb467b0ba58b8748c00d2e5
keccak256("aaaab");
//b1f078126895a1424524de5321b339ab00408010b7cf0e6ed451514981e58aa9
keccak256("aaaac");
```

显而易见，输入字符串只改变了一个字母，输出就已经天壤之别了。

> 注: 在区块链中**安全地**产生一个随机数是一个很难的问题， 本例的方法不安全，但是在我们的Zombie DNA算法里不是那么重要，已经很好地满足我们的需要了。

##### 类型转换

有时你需要变换数据类型。例如:

```solidity
uint8 a = 5;
uint b = 6;
// 将会抛出错误，因为 a * b 返回 uint, 而不是 uint8:
uint8 c = a * b;
// 我们需要将 b 转换为 uint8:
uint8 c = a * uint8(b);
```

上面, `a * b` 返回类型是 `uint`, 但是当我们尝试用 `uint8` 类型接收时, 就会造成潜在的错误。如果把它的数据类型转换为 `uint8`, 就可以了，编译器也不会出错。

##### 实战演习

给 `_generateRandomDna` 函数添加代码! 它应该完成如下功能:

1. 第一行代码取 `_str` 的 `keccak256` 散列值生成一个伪随机十六进制数，类型转换为 `uint`, 最后保存在类型为 `uint` 名为 `rand` 的变量中。
2. 我们只想让我们的DNA的长度为16位 (还记得 `dnaModulus`?)。所以第二行代码应该 `return` 上面计算的数值对 `dnaModulus` 求余数(`%`)。

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

    function _generateRandomDna(string calldata _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encode(_str)));
        return rand % dnaModulus;
    }
}
```



#### 第12章 放在一起

我们就快完成我们的随机僵尸制造器了，来写一个公共的函数把所有的部件连接起来。

写一个公共函数，它有一个参数，用来接收僵尸的名字，之后用它生成僵尸的DNA。

##### 实战演习

1. 创建一个 `public` 函数，命名为 `createRandomZombie`. 它将被传入一个变量 `_name` (数据类型是 `string`)。 *(注: 定义公共函数 `public` 和定义一个私有 `private` 函数的做法一样)*。
2. 函数的第一行应该调用 `_generateRandomDna` 函数，传入 `_name` 参数, 结果保存在一个类型为 `uint` 的变量里，命名为 `randDna`。
3. 第二行调用 `_createZombie` 函数， 传入参数： `_name` 和 `randDna`。
4. 整个函数应该是4行代码 (包括函数的结束符号 `}` )。

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

    function _generateRandomDna(string calldata _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encode(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string calldata _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
```



#### 第13章 事件

我们的合约几乎就要完成了！让我们加上一个**事件**.

**事件** 是合约和区块链通讯的一种机制。你的前端应用“监听”某些事件，并做出反应。

例子:

```solidity
// 这里建立事件
event IntegersAdded(uint x, uint y, uint result);

function add(uint _x, uint _y) public {
  uint result = _x + _y;
  //触发事件，通知app
  IntegersAdded(_x, _y, result);
  return result;
}
```

你的 app 前端可以监听这个事件。JavaScript 实现如下:

```solidity
YourContract.IntegersAdded(function(error, result) {
  // 干些事
})
```

##### 实战演习

我们想每当一个僵尸创造出来时，我们的前端都能监听到这个事件，并将它显示出来。

1. 定义一个 `事件` 叫做 `NewZombie`。 它有3个参数: `zombieId` (`uint`)， `name` (`string`)， 和 `dna` (`uint`)。

2. 修改 `_createZombie` 函数使得当新僵尸造出来并加入 `zombies`数组后，生成事件`NewZombie`。

3. 需要定义僵尸`id`。 `array.push()` 返回数组的长度类型是`uint` - 因为数组的第一个元素的索引是 0， `array.push() - 1` 将是我们加入的僵尸的索引。 `zombies.push() - 1` 就是 `id`，数据类型是 `uint`。在下一行中你可以把它用到 `NewZombie` 事件中。

``` solidity
// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.19;

contract ZombieFactory {

    // 这里建立事件
    event NewZombie(uint zombieId, string name, uint dna);
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string memory _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
        // 这里触发事件
        uint id = zombies.length -1;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encode(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
```



#### 第14章 Web3.js

我们的 Solidity 合约完工了！ 现在我们要写一段 JavaScript 前端代码来调用这个合约。

以太坊有一个 JavaScript 库，名为 ***Web3.js***。

在后面的课程里，我们会进一步地教你如何安装一个合约，如何设置Web3.js。 但是现在我们通过一段代码来了解 Web3.js 是如何和我们发布的合约交互的吧。

如果下面的代码你不能全都理解，不用担心。

```javascript
// 下面是调用合约的方式:
var abi = /* abi是由编译器生成的 */
var ZombieFactoryContract = web3.eth.contract(abi)
var contractAddress = /* 发布之后在以太坊上生成的合约地址 */
var ZombieFactory = ZombieFactoryContract.at(contractAddress)
// `ZombieFactory` 能访问公共的函数以及事件

// 某个监听文本输入的监听器:
$("#ourButton").click(function(e) {
  var name = $("#nameInput").val()
  //调用合约的 `createRandomZombie` 函数:
  ZombieFactory.createRandomZombie(name)
})

// 监听 `NewZombie` 事件, 并且更新UI
var event = ZombieFactory.NewZombie(function(error, result) {
  if (error) return
  generateZombie(result.zombieId, result.name, result.dna)
})

// 获取 Zombie 的 dna, 更新图像
function generateZombie(id, name, dna) {
  let dnaStr = String(dna)
  // 如果dna少于16位,在它前面用0补上
  while (dnaStr.length < 16)
    dnaStr = "0" + dnaStr

  let zombieDetails = {
    // 前两位数构成头部.我们可能有7种头部, 所以 % 7
    // 得到的数在0-6,再加上1,数的范围变成1-7
    // 通过这样计算：
    headChoice: dnaStr.substring(0, 2) % 7 + 1，
    // 我们得到的图片名称从head1.png 到 head7.png

    // 接下来的两位数构成眼睛, 眼睛变化就对11取模:
    eyeChoice: dnaStr.substring(2, 4) % 11 + 1,
    // 再接下来的两位数构成衣服，衣服变化就对6取模:
    shirtChoice: dnaStr.substring(4, 6) % 6 + 1,
    //最后6位控制颜色. 用css选择器: hue-rotate来更新
    // 360度:
    skinColorChoice: parseInt(dnaStr.substring(6, 8) / 100 * 360),
    eyeColorChoice: parseInt(dnaStr.substring(8, 10) / 100 * 360),
    clothesColorChoice: parseInt(dnaStr.substring(10, 12) / 100 * 360),
    zombieName: name,
    zombieDescription: "A Level 1 CryptoZombie",
  }
  return zombieDetails
}
```

我们的 JavaScript 所做的就是获取由`zombieDetails` 产生的数据, 并且利用浏览器里的 JavaScript 神奇功能 (我们用 Vue.js)，置换出图像以及使用CSS过滤器。在后面的课程中，你可以看到全部的代码。

##### 试一下吧!

在右面的输入框里输入你的名字，看看你能得到哪种僵尸！

**一旦你得到一个满意的僵尸, 点击下面的 "下一章" 按钮保存你的僵尸，结束第一课!**

<img src="https://markdown-res.oss-cn-hangzhou.aliyuncs.com/mdImgs/2022/04/28/20220428145457.png" align="center" style="width:500px" />

##### 太棒啦！你完成了 CryptoZombies 的第一个课程!

你离自己编译区块链游戏跨出了很大的一步。

##### 跟你的朋友们晒一晒你新的僵尸吧！

这是你的僵尸的永久地址:

https://share.cryptozombies.io/zh/lesson/1/share/GG?id=Y3p8MjEwMTY2

[加入我们的Telegram](https://t.me/loomnetworkdev)



### 1.2 僵尸攻击人类

#### 第1章 第二课概览

在第一课中，我们创建了一个函数用来生成僵尸，并且将它放入区块链上的僵尸数据库中。 在第二课里，我们会让我们的 app 看起来更像一个游戏： 它得支持多用户，并且采用更加有趣,而不仅仅使用随机的方式，来生成新的僵尸。

如何生成新的僵尸呢？通过让现有的僵尸猎食其他生物！

##### 僵尸猎食

僵尸猎食的时候，僵尸病毒侵入猎物，这些病毒会将猎物变为新的僵尸，加入你的僵尸大军。系统会通过猎物和猎食者僵尸的DNA计算出新僵尸的DNA。

僵尸最喜欢猎食什么物种呢？ 等你学完第二课就知道了！

##### 实战演习

右边是一个简单的猎食演示。点击一个“人”，看看僵尸猎食的时候会发生什么? 可见，新僵尸的DNA是通过从原来的僵尸的DNA, 加上猎物的DNA计算得来的。

学完这一章，请点击“下一章”， 我们该让游戏支持多玩家模式了。

<img src="https://markdown-res.oss-cn-hangzhou.aliyuncs.com/mdImgs/2022/04/28/20220428161055.png" align="center" style="width:500px" />

<img src="https://markdown-res.oss-cn-hangzhou.aliyuncs.com/mdImgs/2022/04/28/20220428150659.png" align="center" style="width:500px" />



#### 第2章 映射（Mapping）和地址（Address）

我们通过给数据库中的僵尸指定“主人”， 来支持“多玩家”模式。

如此一来，我们需要引入2个新的数据类型：`mapping`（映射） 和 `address`（地址）。

##### Addresses （地址）

以太坊区块链由 **_ account _** (账户)组成，你可以把它想象成银行账户。一个帐户的余额是 **_以太_** （在以太坊区块链上使用的币种），你可以和其他帐户之间支付和接受以太币，就像你的银行帐户可以电汇资金到其他银行帐户一样。

每个帐户都有一个“地址”，你可以把它想象成银行账号。这是账户唯一的标识符，它看起来长这样：

```bash
0x0cE446255506E92DF41614C46F1d6df9Cc969183
```

（这是 CryptoZombies 团队的地址，如果你喜欢 CryptoZombies 的话，请打赏我们一些以太币！😉）

我们将在后面的课程中介绍地址的细节，现在你只需要了解**地址属于特定用户（或智能合约）的**。

所以我们可以指定“地址”作为僵尸主人的 ID。当用户通过与我们的应用程序交互来创建新的僵尸时，新僵尸的所有权被设置到调用者的以太坊地址下。

##### Mapping（映射）

在第1课中，我们看到了 **_ 结构体 _** 和 **_ 数组 _** 。 **_映射_** 是另一种在 Solidity 中存储有组织数据的方法。

映射是这样定义的：

```solidity
//对于金融应用程序，将用户的余额保存在一个 uint类型的变量中：
mapping (address => uint) public accountBalance;
//或者可以用来通过userId 存储/查找的用户名
mapping (uint => string) userIdToName;
```

映射本质上是存储和查找数据所用的键-值对。在第一个例子中，键是一个 `address`，值是一个 `uint`，在第二个例子中，键是一个`uint`，值是一个 `string`。

##### 实战演习

为了存储僵尸的所有权，我们会使用到两个映射：一个记录僵尸拥有者的地址，另一个记录某地址所拥有僵尸的数量。

1.创建一个叫做 `zombieToOwner` 的映射。其键是一个`uint`（我们将根据它的 id 存储和查找僵尸），值为 `address`。映射属性为`public`。

2.创建一个名为 `ownerZombieCount` 的映射，其中键是 `address`，值是 `uint`。

``` solidity
//... other code ...
Zombie[] public zombies;
// 记录僵尸拥有者地址
mapping(uint => address) public zombieToOwner;
// 记录某地址所拥有的僵尸的数量
mapping(address => uint) ownerZombieCount;
//... other code ...
```



#### 第3章 Msg.sender

现在有了一套映射来记录僵尸的所有权了，我们可以修改 `_createZombie` 方法来运用它们。

为了做到这一点，我们要用到 `msg.sender`。

##### msg.sender

在 Solidity 中，有一些全局变量可以被所有函数调用。 其中一个就是 `msg.sender`，它指的是当前调用者（或智能合约）的 `address`。

> 注意：在 Solidity 中，功能执行始终需要从外部调用者开始。 一个合约只会在区块链上什么也不做，除非有人调用其中的函数。所以 `msg.sender`总是存在的。

以下是使用 `msg.sender` 来更新 `mapping` 的例子：

```solidity
mapping (address => uint) favoriteNumber;

function setMyNumber(uint _myNumber) public {
  // 更新我们的 `favoriteNumber` 映射来将 `_myNumber`存储在 `msg.sender`名下
  favoriteNumber[msg.sender] = _myNumber;
  // 存储数据至映射的方法和将数据存储在数组相似
}

function whatIsMyNumber() public view returns (uint) {
  // 拿到存储在调用者地址名下的值
  // 若调用者还没调用 setMyNumber， 则值为 `0`
  return favoriteNumber[msg.sender];
}
```

在这个小小的例子中，任何人都可以调用 `setMyNumber` 在我们的合约中存下一个 `uint` 并且与他们的地址相绑定。 然后，他们调用 `whatIsMyNumber` 就会返回他们存储的 `uint`。

使用 `msg.sender` 很安全，因为它具有以太坊区块链的安全保障 —— 除非窃取与以太坊地址相关联的私钥，否则是没有办法修改其他人的数据的。

##### 实战演习

我们来修改第1课的 `_createZombie` 方法，将僵尸分配给函数调用者吧。

1. 首先，在得到新的僵尸 `id` 后，更新 `zombieToOwner` 映射，在 `id` 下面存入 `msg.sender`。
2. 然后，我们为这个 `msg.sender` 名下的 `ownerZombieCount` 加 1。

跟在 JavaScript 中一样， 在 Solidity 中你也可以用 `++` 使 `uint` 递增。

```solidity
uint number = 0;
number++;
// `number` 现在是 `1`了
```

修改两行代码即可。

``` solidity
//... other code ...
uint id = zombies.length -1;
zombieToOwner[id] = msg.sender;
ownerZombieCount[msg.sender]++;
emit NewZombie(id, _name, _dna);
//... other code ...
```



#### 第4章 Require

在第一课中，我们成功让用户通过调用 `createRandomZombie`函数 并输入一个名字来创建新的僵尸。 但是，如果用户能持续调用这个函数来创建出无限多个僵尸加入他们的军团，这游戏就太没意思了！

于是，我们作出限定：每个玩家只能调用一次这个函数。 这样一来，新玩家可以在刚开始玩游戏时通过调用它，为其军团创建初始僵尸。

我们怎样才能限定每个玩家只调用一次这个函数呢？

答案是使用`require`。 `require`使得函数在执行过程中，当不满足某些条件时抛出错误，并停止执行：

```solidity
function sayHiToVitalik(string _name) public returns (string) {
  // 比较 _name 是否等于 "Vitalik". 如果不成立，抛出异常并终止程序
  // (敲黑板: Solidity 并不支持原生的字符串比较, 我们只能通过比较
  // 两字符串的 keccak256 哈希值来进行判断)
  require(keccak256(_name) == keccak256("Vitalik"));
  // 如果返回 true, 运行如下语句
  return "Hi!";
}
```

如果你这样调用函数 `sayHiToVitalik（“Vitalik”）` ,它会返回“Hi！”。而如果调用的时候使用了其他参数，它则会抛出错误并停止执行。

因此，在调用一个函数之前，用 `require` 验证前置条件是非常有必要的。

##### 实战演习

在我们的僵尸游戏中，我们不希望用户通过反复调用 `createRandomZombie` 来給他们的军队创建无限多个僵尸 —— 这将使得游戏非常无聊。

我们使用了 `require` 来确保这个函数只有在每个用户第一次调用它的时候执行，用以创建初始僵尸。

1. 在 `createRandomZombie` 的前面放置 `require` 语句。 使得函数先检查 `ownerZombieCount [msg.sender]` 的值为 `0` ，不然就抛出一个错误。

> 注意：在 Solidity 中，关键词放置的顺序并不重要
>
> - 虽然参数的两个位置是等效的。 但是，由于我们的答案检查器比较呆板，它只能认定其中一个为正确答案
> - 于是在这里，我们就约定把`ownerZombieCount [msg.sender]`放前面吧

``` solidity
function createRandomZombie(string _name) public {
    // start here
    require(ownerZombieCount[msg.sender] == 0);
    uint randDna = _generateRandomDna(_name);
    _createZombie(_name, randDna);
}
```



#### 第5章 继承（Inheritance）

我们的游戏代码越来越长。 当代码过于冗长的时候，最好将代码和逻辑分拆到多个不同的合约中，以便于管理。

有个让 Solidity 的代码易于管理的功能，就是合约 ***inheritance*** (继承)：

```solidity
contract Doge {
  function catchphrase() public returns (string) {
    return "So Wow CryptoDoge";
  }
}

contract BabyDoge is Doge {
  function anotherCatchphrase() public returns (string) {
    return "Such Moon BabyDoge";
  }
}
```

由于 `BabyDoge` 是从 `Doge` 那里 ***inherits*** （继承)过来的。 这意味着当你编译和部署了 `BabyDoge`，它将可以访问 `catchphrase()` 和 `anotherCatchphrase()`和其他我们在 `Doge` 中定义的其他公共函数。

这可以用于逻辑继承（比如表达子类的时候，`Cat` 是一种 `Animal`）。 但也可以简单地将类似的逻辑组合到不同的合约中以组织代码。

##### 实战演习

在接下来的章节中，我们将要为僵尸实现各种功能，让它可以“猎食”和“繁殖”。 通过将这些运算放到父类 `ZombieFactory` 中，使得所有 `ZombieFactory` 的继承者合约都可以使用这些方法。

1. 在 `ZombieFactory` 下创建一个叫 `ZombieFeeding` 的合约，它是继承自 `ZombieFactory 合约的。

``` solidity
contract ZombieFactory {
	// other code
}
contract ZombieFeeding is ZombieFactory {
}
```



#### 第6章 引入（Import）

哇！你有没有注意到，我们只是清理了下右边的代码，现在你的编辑器的顶部就多了个选项卡。 尝试点击它的标签，看看会发生什么吧！

代码已经够长了，我们把它分成多个文件以便于管理。 通常情况下，当 Solidity 项目中的代码太长的时候我们就是这么做的。

在 Solidity 中，当你有多个文件并且想把一个文件导入另一个文件时，可以使用 `import` 语句：

```solidity
import "./someothercontract.sol";

contract newContract is SomeOtherContract {

}
```

这样当我们在合约（contract）目录下有一个名为 `someothercontract.sol` 的文件（ `./` 就是同一目录的意思），它就会被编译器导入。

##### 实战演习

现在我们已经建立了一个多文件架构，并用 `import` 来读取来自另一个文件中合约的内容：

1.将 `zombiefactory.sol` 导入到我们的新文件 `zombiefeeding.sol` 中。

``` solidity
// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.19;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {
}
```



#### 第7章 Storage与Memory

在 Solidity 中，有两个地方可以存储变量 —— `storage` 或 `memory`。

***Storage*** 变量是指永久存储在区块链中的变量。 ***Memory*** 变量则是临时的，当外部函数对某合约调用完成时，内存型变量即被移除。 你可以把它想象成存储在你电脑的硬盘或是RAM中数据的关系。

大多数时候你都用不到这些关键字，默认情况下 Solidity 会自动处理它们。 状态变量（在函数之外声明的变量）默认为“存储”形式，并永久写入区块链；而在函数内部声明的变量是“内存”型的，它们函数调用结束后消失。

然而也有一些情况下，你需要手动声明存储类型，主要用于处理函数内的 **_ 结构体 _** 和 **_ 数组 _** 时：

```solidity
contract SandwichFactory {
  struct Sandwich {
    string name;
    string status;
  }

  Sandwich[] sandwiches;

  function eatSandwich(uint _index) public {
    // Sandwich mySandwich = sandwiches[_index];

    // ^ 看上去很直接，不过 Solidity 将会给出警告
    // 告诉你应该明确在这里定义 `storage` 或者 `memory`。

    // 所以你应该明确定义 `storage`:
    Sandwich storage mySandwich = sandwiches[_index];
    // ...这样 `mySandwich` 是指向 `sandwiches[_index]`的指针
    // 在存储里，另外...
    mySandwich.status = "Eaten!";
    // ...这将永久把 `sandwiches[_index]` 变为区块链上的存储

    // 如果你只想要一个副本，可以使用`memory`:
    Sandwich memory anotherSandwich = sandwiches[_index + 1];
    // ...这样 `anotherSandwich` 就仅仅是一个内存里的副本了
    // 另外
    anotherSandwich.status = "Eaten!";
    // ...将仅仅修改临时变量，对 `sandwiches[_index + 1]` 没有任何影响
    // 不过你可以这样做:
    sandwiches[_index + 1] = anotherSandwich;
    // ...如果你想把副本的改动保存回区块链存储
  }
}
```

如果你还没有完全理解究竟应该使用哪一个，也不用担心 —— 在本教程中，我们将告诉你何时使用 `storage` 或是 `memory`，并且当你不得不使用到这些关键字的时候，Solidity 编译器也发警示提醒你的。

现在，只要知道在某些场合下也需要你显式地声明 `storage` 或 `memory`就够了！

##### 实战演习

是时候给我们的僵尸增加“猎食”和“繁殖”功能了！

当一个僵尸猎食其他生物体时，它自身的DNA将与猎物生物的DNA结合在一起，形成一个新的僵尸DNA。

1. 创建一个名为 `feedAndMultiply` 的函数。 使用两个参数：`_zombieId`（ `uint`类型 ）和`_targetDna` （也是 `uint` 类型）。 设置属性为 `public` 的。
2. 我们不希望别人用我们的僵尸去捕猎。 首先，我们确保对自己僵尸的所有权。 通过添加一个`require` 语句来确保 `msg.sender` 只能是这个僵尸的主人（类似于我们在 `createRandomZombie` 函数中做过的那样）。

> 注意：同样，因为我们的答案检查器比较呆萌，只认识把 `msg.sender` 放在前面的答案，如果你切换了参数的顺序，它就不认得了。 但你正常编码时，如何安排参数顺序都是正确的。

1. 为了获取这个僵尸的DNA，我们的函数需要声明一个名为 `myZombie` 数据类型为`Zombie`的本地变量（这是一个 `storage` 型的指针）。 将其值设定为在 `zombies` 数组中索引为`_zombieId`所指向的值。

到目前为止，包括函数结束符 `}` 的那一行， 总共4行代码。

下一章里，我们会继续丰富这个功能。

``` solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.19;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {
    function feedAndMultiply(uint256 _zombieId, uint256 _targetDna) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
    }
}
```



#### 第8章 僵尸的DNA

我们来把 `feedAndMultiply` 函数写完吧。

获取新的僵尸DNA的公式很简单：计算猎食僵尸DNA和被猎僵尸DNA之间的平均值。

例如：

```solidity
function testDnaSplicing() public {
  uint zombieDna = 2222222222222222;
  uint targetDna = 4444444444444444;
  uint newZombieDna = (zombieDna + targetDna) / 2;
  // newZombieDna 将等于 3333333333333333
}
```

以后，我们也可以让函数变得更复杂些，比方给新的僵尸的 DNA 增加一些随机性之类的。但现在先从最简单的开始 —— 以后还可以回来完善它嘛。

##### 实战演习

1. 首先我们确保 `_targetDna` 不长于16位。要做到这一点，我们可以设置 `_targetDna` 为 `_targetDna ％ dnaModulus` ，并且只取其最后16位数字。
2. 接下来为我们的函数声明一个名叫 `newDna` 的 `uint`类型的变量，并将其值设置为 `myZombie`的 DNA 和 `_targetDna` 的平均值（如上例所示）。

> 注意：您可以用 `myZombie.name` 或 `myZombie.dna` 访问 `myZombie` 的属性。

1. 一旦我们计算出新的DNA，再调用 `_createZombie` 就可以生成新的僵尸了。如果你忘了调用这个函数所需要的参数，可以查看 `zombiefactory.sol` 选项卡。请注意，需要先给它命名，所以现在我们把新的僵尸的名字设为`NoName` - 我们回头可以编写一个函数来更改僵尸的名字。

> 注意：对于 Solidity 高手，你可能会注意到我们的代码存在一个问题。别担心，下一章会解决这个问题的 ;）

``` solidity
function feedAndMultiply(uint256 _zombieId, uint256 _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];

    _targetDna = _targetDna % dnaModulus;
    uint256 newDna = (myZombie.dna + _targetDna) / 2;
    _createZombie("NoName", newDna);
}
```



#### 第9章: 更多关于函数可见性

**我们上一课的代码有问题！**

编译的时候编译器就会报错。

错误在于，我们尝试从 `ZombieFeeding` 中调用 `_createZombie` 函数，但 `_createZombie` 却是 `ZombieFactory` 的 `private` （私有）函数。这意味着任何继承自 `ZombieFactory` 的子合约都不能访问它。

##### internal 和 external

除 `public` 和 `private` 属性之外，Solidity 还使用了另外两个描述函数可见性的修饰词：`internal`（内部） 和 `external`（外部）。

`internal` 和 `private` 类似，不过， 如果某个合约继承自其父合约，这个合约即可以访问父合约中定义的“内部”函数。（嘿，这听起来正是我们想要的那样！）。

`external` 与`public` 类似，只不过这些函数只能在合约之外调用 - 它们不能被合约内的其他函数调用。稍后我们将讨论什么时候使用 `external` 和 `public`。

声明函数 `internal` 或 `external` 类型的语法，与声明 `private` 和 `public`类 型相同：

```solidity
contract Sandwich {
  uint private sandwichesEaten = 0;

  function eat() internal {
    sandwichesEaten++;
  }
}

contract BLT is Sandwich {
  uint private baconSandwichesEaten = 0;

  function eatWithBacon() public returns (string) {
    baconSandwichesEaten++;
    // 因为eat() 是internal 的，所以我们能在这里调用
    eat();
  }
}
```

##### 实战演习

1. 将 `_createZombie()` 函数的属性从 `private` 改为 `internal` ， 使得其他的合约也能访问到它。

   我们已经成功把你的注意力集中在到`zombiefactory.sol`这个选项卡上啦。

``` solidity
function _createZombie(string memory _name, uint _dna) internal {
    zombies.push(Zombie(_name, _dna));
    // 这里触发事件
    uint id = zombies.length -1;
    zombieToOwner[id] = msg.sender;
    ownerZombieCount[msg.sender]++;
    emit NewZombie(id, _name, _dna);
}
```



#### 第10章: 僵尸吃什么?

是时候让我们的僵尸去捕猎！ 那僵尸最喜欢的食物是什么呢？

Crypto 僵尸喜欢吃的是...

**CryptoKitties！** 😱😱😱

（正经点，我可不是开玩笑😆）

为了做到这一点，我们要读出 CryptoKitties 智能合约中的 kittyDna。这些数据是公开存储在区块链上的。区块链是不是很酷？

别担心 —— 我们的游戏并不会伤害到任何真正的CryptoKitty。 我们只 *读取* CryptoKitties 数据，但却无法在物理上删除它。

##### 与其他合约的交互

如果我们的合约需要和区块链上的其他的合约会话，则需先定义一个 ***interface*** (接口)。

先举一个简单的栗子。 假设在区块链上有这么一个合约：

```solidity
contract LuckyNumber {
  mapping(address => uint) numbers;

  function setNum(uint _num) public {
    numbers[msg.sender] = _num;
  }

  function getNum(address _myAddress) public view returns (uint) {
    return numbers[_myAddress];
  }
}
```

这是个很简单的合约，您可以用它存储自己的幸运号码，并将其与您的以太坊地址关联。 这样其他人就可以通过您的地址查找您的幸运号码了。

现在假设我们有一个外部合约，使用 `getNum` 函数可读取其中的数据。

首先，我们定义 `LuckyNumber` 合约的 ***interface*** ：

```solidity
interface NumberInterface {
  function getNum(address _myAddress) public view returns (uint);
}
```

请注意，这个过程虽然看起来像在定义一个合约，但其实内里不同：

首先，我们只声明了要与之交互的函数 —— 在本例中为 `getNum` —— 在其中我们没有使用到任何其他的函数或状态变量。

其次，我们并没有使用大括号（`{` 和 `}`）定义函数体，我们单单用分号（`;`）结束了函数声明。这使它看起来像一个合约框架。

编译器就是靠这些特征认出它是一个接口的。

在我们的 app 代码中使用这个接口，合约就知道其他合约的函数是怎样的，应该如何调用，以及可期待什么类型的返回值。

在下一课中，我们将真正调用其他合约的函数。目前我们只要声明一个接口，用于调用 CryptoKitties 合约就行了。

##### 实战演习

我们已经为你查看过了 CryptoKitties 的源代码，并且找到了一个名为 `getKitty`的函数，它返回所有的加密猫的数据，包括它的“基因”（我们的僵尸游戏要用它生成新的僵尸）。

该函数如下所示：

```solidity
function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
) {
    Kitty storage kit = kitties[_id];

    // if this variable is 0 then it's not gestating
    isGestating = (kit.siringWithId != 0);
    isReady = (kit.cooldownEndBlock <= block.number);
    cooldownIndex = uint256(kit.cooldownIndex);
    nextActionAt = uint256(kit.cooldownEndBlock);
    siringWithId = uint256(kit.siringWithId);
    birthTime = uint256(kit.birthTime);
    matronId = uint256(kit.matronId);
    sireId = uint256(kit.sireId);
    generation = uint256(kit.generation);
    genes = kit.genes;
}
```

这个函数看起来跟我们习惯的函数不太一样。 它竟然返回了...一堆不同的值！ 如果您用过 JavaScript 之类的编程语言，一定会感到奇怪 —— 在 Solidity中，您可以让一个函数返回多个值。

现在我们知道这个函数长什么样的了，就可以用它来创建一个接口：

1.定义一个名为 `KittyInterface` 的接口。 请注意，因为我们使用了 `contract` 关键字， 这过程看起来就像创建一个新的合约一样。

2.在interface里定义了 `getKitty` 函数（不过是复制/粘贴上面的函数，但在 `returns` 语句之后用分号，而不是大括号内的所有内容。

``` solidity
interface KittyInterface {
    function getKitty(uint256 _id)
        external
        view
        returns (
            bool isGestating,
            bool isReady,
            uint256 cooldownIndex,
            uint256 nextActionAt,
            uint256 siringWithId,
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation,
            uint256 genes
        );
}
```



#### 第11章 使用接口

继续前面 `NumberInterface` 的例子，我们既然将接口定义为：

```solidity
interface NumberInterface {
  function getNum(address _myAddress) public view returns (uint);
}
```

我们可以在合约中这样使用：

```solidity
contract MyContract {
  address NumberInterfaceAddress = 0xab38...;
  // ^ 这是FavoriteNumber合约在以太坊上的地址
  NumberInterface numberContract = NumberInterface(NumberInterfaceAddress);
  // 现在变量 `numberContract` 指向另一个合约对象

  function someFunction() public {
    // 现在我们可以调用在那个合约中声明的 `getNum`函数:
    uint num = numberContract.getNum(msg.sender);
    // ...在这儿使用 `num`变量做些什么
  }
}
```

通过这种方式，只要将您合约的可见性设置为`public`(公共)或`external`(外部)，它们就可以与以太坊区块链上的任何其他合约进行交互。

##### 实战演习

我们来建个自己的合约去读取另一个智能合约-- CryptoKitties 的内容吧！

1. 我已经将代码中 CryptoKitties 合约的地址保存在一个名为 `ckAddress` 的变量中。在下一行中，请创建一个名为 `kittyContract` 的 KittyInterface，并用 `ckAddress` 为它初始化 —— 就像我们为 `numberContract`所做的一样。



#### 第12章 处理多返回值

`getKitty` 是我们所看到的第一个返回多个值的函数。我们来看看是如何处理的：

```solidity
function multipleReturns() internal returns(uint a, uint b, uint c) {
  return (1, 2, 3);
}

function processMultipleReturns() external {
  uint a;
  uint b;
  uint c;
  // 这样来做批量赋值:
  (a, b, c) = multipleReturns();
}

// 或者如果我们只想返回其中一个变量:
function getLastReturnValue() external {
  uint c;
  // 可以对其他字段留空:
  (,,c) = multipleReturns();
}
```

##### 实战演习

是时候与 CryptoKitties 合约交互起来了！

我们来定义一个函数，从 kitty 合约中获取它的基因：

1. 创建一个名为 `feedOnKitty` 的函数。它需要2个 `uint` 类型的参数，`_zombieId` 和`_kittyId` ，这是一个 `public` 类型的函数。

2. 函数首先要声明一个名为 `kittyDna` 的 `uint`。

   > 注意：在我们的 `KittyInterface` 中，`genes` 是一个 `uint256` 类型的变量，但是如果你记得，我们在第一课中提到过，`uint` 是 `uint256` 的别名，也就是说它们是一回事。

3. 这个函数接下来调用 `kittyContract.getKitty`函数, 传入 `_kittyId` ，将返回的 `genes` 存储在 `kittyDna` 中。记住 —— `getKitty` 会返回一大堆变量。 （确切地说10个 - 我已经为你数过了，不错吧！）。但是我们只关心最后一个-- `genes`。数逗号的时候小心点哦！

4. 最后，函数调用了 `feedAndMultiply` ，并传入了 `_zombieId` 和 `kittyDna` 两个参数。

``` solidity
function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna);
}
```



#### 第13章 奖励: Kitty 基因

我们的功能逻辑主体已经完成了...现在让我们来添一个奖励功能吧。

这样吧，给从小猫制造出的僵尸添加些特征，以显示他们是猫僵尸。

要做到这一点，咱们在新僵尸的DNA中添加一些特殊的小猫代码。

还记得吗，第一课中我们提到，我们目前只使用16位DNA的前12位数来指定僵尸的外观。所以现在我们可以使用最后2个数字来处理“特殊”的特征。

这样吧，把猫僵尸DNA的最后两个数字设定为`99`（因为猫有9条命）。所以在我们这么来写代码：`如果`这个僵尸是一只猫变来的，就将它DNA的最后两位数字设置为`99`。

##### if 语句

if语句的语法在 Solidity 中，与在 JavaScript 中差不多：

```solidity
function eatBLT(string sandwich) public {
  // 看清楚了，当我们比较字符串的时候，需要比较他们的 keccak256 哈希码
  if (keccak256(sandwich) == keccak256("BLT")) {
    eat();
  }
}
```

##### 实战演习

让我们在我们的僵尸代码中实现小猫的基因。

1. 首先，我们修改下 `feedAndMultiply` 函数的定义，给它传入第三个参数：一条名为 `_species` 的字符串。

2. 接下来，在我们计算出新的僵尸的DNA之后，添加一个 `if` 语句来比较 `_species` 和字符串 `"kitty"` 的 `keccak256` 哈希值。

3. 在 `if` 语句中，我们用 `99` 替换了新僵尸DNA的最后两位数字。可以这么做：`newDna = newDna - newDna % 100 + 99;`。

   > 解释：假设 `newDna` 是 `334455`。那么 `newDna % 100` 是 `55`，所以 `newDna - newDna % 100` 得到 `334400`。最后加上 `99` 可得到 `334499`。

4. 最后，我们修改了 `feedOnKitty` 中的函数调用。当它调用 `feedAndMultiply` 时，增加 `“kitty”` 作为最后一个参数。

``` solidity
contract ZombieFeeding is ZombieFactory {

    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    KittyInterface kittyContract = KittyInterface(ckAddress);
    
    function feedAndMultiply(uint256 _zombieId, uint256 _targetDna, string memory _species) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];

        _targetDna = _targetDna % dnaModulus;
        uint256 newDna = (myZombie.dna + _targetDna) / 2;
        // 这里增加一个 if 语句
        if(keccak256(abi.encode(_species)) == keccak256(abi.encode("kitty"))){
            newDna = newDna - newDna % 100 + 99;
        }
        _createZombie("NoName", newDna);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}
```



#### 第14章 放在一起

至此，你已经学完第二课了！

查看下→_→的演示，看看他们怎么运行起来得吧。继续，你肯定等不及看完这一页😉。点击小猫，攻击！看到你斩获一个新的小猫僵尸了吧！

##### JavaScript 实现

我们只用编译和部署 `ZombieFeeding`，就可以将这个合约部署到以太坊了。我们最终完成的这个合约继承自 `ZombieFactory`，因此它可以访问自己和父辈合约中的所有 public 方法。

我们来看一个与我们的刚部署的合约进行交互的例子， 这个例子使用了 JavaScript 和 web3.js：

```javascript
var abi = /* abi generated by the compiler */
var ZombieFeedingContract = web3.eth.contract(abi)
var contractAddress = /* our contract address on Ethereum after deploying */
var ZombieFeeding = ZombieFeedingContract.at(contractAddress)

// 假设我们有我们的僵尸ID和要攻击的猫咪ID
let zombieId = 1;
let kittyId = 1;

// 要拿到猫咪的DNA，我们需要调用它的API。这些数据保存在它们的服务器上而不是区块链上。
// 如果一切都在区块链上，我们就不用担心它们的服务器挂了，或者它们修改了API，
// 或者因为不喜欢我们的僵尸游戏而封杀了我们
let apiUrl = "https://api.cryptokitties.co/kitties/" + kittyId
$.get(apiUrl, function(data) {
  let imgUrl = data.image_url
  // 一些显示图片的代码
})

// 当用户点击一只猫咪的时候:
$(".kittyImage").click(function(e) {
  // 调用我们合约的 `feedOnKitty` 函数
  ZombieFeeding.feedOnKitty(zombieId, kittyId)
})

// 侦听来自我们合约的新僵尸事件好来处理
ZombieFactory.NewZombie(function(error, result) {
  if (error) return
  // 这个函数用来显示僵尸:
  generateZombie(result.zombieId, result.name, result.dna)
})
```

##### 实战演习

选择一只你想猎食的小猫。你自家僵尸的 DNA 会和小猫的 DNA 结合，生成一个新的小猫僵尸，加入你的军团！

看到新僵尸上那可爱的猫咪腿了么？这是新僵尸最后DNA中最后两位数字 `99` 的功劳！

你想要的话随时可以重新开始。捕获了一只猫咪僵尸，你一定很高兴吧！（不过你只能持有一只），继续前进到下一章，完成第二课吧！

<img src="https://markdown-res.oss-cn-hangzhou.aliyuncs.com/mdImgs/2022/05/05/20220505101833.png" align="center" style="width:500px" />

<img src="https://markdown-res.oss-cn-hangzhou.aliyuncs.com/mdImgs/2022/05/05/20220505101937.png" align="center" style="width:500px" />

##### 你好棒！太棒啦！你完成了 CryptoZombies 的第二课!

**成功解锁了:**

- GG被升级到二级!
- 无名～ 僵尸已加入你的部队! (别担心，第三节课里你会有机会改它的名字)

##### 晒一晒你的 CryptoKitty-猎杀者！和你的朋友们分享！

这是你的僵尸的永久地址，让你的朋友跟你一起猎杀 CryptoKitties:

https://share.cryptozombies.io/zh/lesson/2/share/GG?id=Y3p8MjEwMTY2



### 1.3 高级 Solidity 理论

#### 第1章 智能协议的永固性

到现在为止，我们讲的 Solidity 和其他语言没有质的区别，它长得也很像 JavaScript。

但是，在有几点以太坊上的 DApp 跟普通的应用程序有着天壤之别。

第一个例子，在你把智能协议传上以太坊之后，它就变得***不可更改\***, 这种永固性意味着你的代码永远不能被调整或更新。

你编译的程序会一直，永久的，不可更改的，存在以太坊上。这就是 Solidity 代码的安全性如此重要的一个原因。如果你的智能协议有任何漏洞，即使你发现了也无法补救。你只能让你的用户们放弃这个智能协议，然后转移到一个新的修复后的合约上。

但这恰好也是智能合约的一大优势。代码说明一切。如果你去读智能合约的代码，并验证它，你会发现，一旦函数被定义下来，每一次的运行，程序都会严格遵照函数中原有的代码逻辑一丝不苟地执行，完全不用担心函数被人篡改而得到意外的结果。

##### 外部依赖关系

在第2课中，我们将加密小猫（CryptoKitties）合约的地址硬编码到 DApp 中去了。有没有想过，如果加密小猫出了点问题，比方说，集体消失了会怎么样？ 虽然这种事情几乎不可能发生，但是，如果小猫没了，我们的 DApp 也会随之失效 -- 因为我们在 DApp 的代码中用“硬编码”的方式指定了加密小猫的地址，如果这个根据地址找不到小猫，我们的僵尸也就吃不到小猫了，而按照前面的描述，我们却没法修改合约去应付这个变化！

因此，我们不能硬编码，而要采用“函数”，以便于 DApp 的关键部分可以以参数形式修改。

比方说，我们不再一开始就把猎物地址给写入代码，而是写个函数 `setKittyContractAddress`, 运行时再设定猎物的地址，这样我们就可以随时去锁定新的猎物，也不用担心加密小猫集体消失了。

##### 实战演习

请修改第2课的代码，使得可以通过程序更改 CryptoKitties 合约地址。

1. 删除采用硬编码 方式的 `ckAddress` 代码行。
2. 之前创建 `kittyContract` 变量的那行代码，修改为对 `kittyContract` 变量的声明 -- 暂时不给它指定具体的实例。
3. 创建名为 `setKittyContractAddress` 的函数， 它带一个参数 `_address`（`address`类型）， 可见性设为`external`。
4. 在函数内部，添加一行代码，将 `kittyContract` 变量设置为返回值：`KittyInterface（_address）`。

> 注意：你可能会注意到这个功能有个安全漏洞，别担心 - 咱们到下一章里解决它;）

``` solidity
contract ZombieFeeding is ZombieFactory {

    KittyInterface kittyContract;

    function setKittyContractAddress(address _address) external {
        kittyContract = KittyInterface(_address);
    }
    // ... other code ...
}
```



#### 第2章 Ownable Contracts

上一章中，您有没有发现任何安全漏洞呢？

呀！`setKittyContractAddress` 可见性居然申明为“外部的”（`external`），岂不是任何人都可以调用它！ 也就是说，任何调用该函数的人都可以更改 CryptoKitties 合约的地址，使得其他人都没法再运行我们的程序了。

我们确实是希望这个地址能够在合约中修改，但我可没说让每个人去改它呀。

要对付这样的情况，通常的做法是指定合约的“所有权” - 就是说，给它指定一个主人（没错，就是您），只有主人对它享有特权。

##### OpenZeppelin库的`Ownable` 合约

下面是一个 `Ownable` 合约的例子： 来自 **_ OpenZeppelin _** Solidity 库的 `Ownable` 合约。 OpenZeppelin 是主打安保和社区审查的智能合约库，您可以在自己的 DApps中引用。等把这一课学完，您不要催我们发布下一课，最好利用这个时间把 OpenZeppelin 的网站看看，保管您会学到很多东西！

把楼下这个合约读读通，是不是还有些没见过代码？别担心，我们随后会解释。

```solidity
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}
```

下面有没有您没学过的东东？

- 构造函数：`function Ownable()`是一个 **_ constructor_** (构造函数)，构造函数不是必须的，它与合约同名，构造函数一生中唯一的一次执行，就是在合约最初被创建的时候。
- 函数修饰符：`modifier onlyOwner()`。 修饰符跟函数很类似，不过是用来修饰其他已有函数用的， 在其他语句执行前，为它检查下先验条件。 在这个例子中，我们就可以写个修饰符 `onlyOwner` 检查下调用者，确保只有合约的主人才能运行本函数。我们下一章中会详细讲述修饰符，以及那个奇怪的`_;`。
- `indexed` 关键字：别担心，我们还用不到它。

所以`Ownable` 合约基本都会这么干：

1. 合约创建，构造函数先行，将其 `owner` 设置为`msg.sender`（其部署者）
2. 为它加上一个修饰符 `onlyOwner`，它会限制陌生人的访问，将访问某些函数的权限锁定在 `owner` 上。
3. 允许将合约所有权转让给他人。

`onlyOwner` 简直人见人爱，大多数人开发自己的 Solidity DApps，都是从复制/粘贴 `Ownable` 开始的，从它再继承出的子类，并在之上进行功能开发。

既然我们想把 `setKittyContractAddress` 限制为 `onlyOwner` ，我们也要做同样的事情。

##### 实战演习

首先，将 `Ownable` 合约的代码复制一份到新文件 `ownable.sol` 中。 接下来，创建一个 `ZombieFactory`，继承 `Ownable`。

1.在程序中导入 `ownable.sol` 的内容。 如果您不记得怎么做了，参考下 `zombiefeeding.sol`。

2.修改 `ZombieFactory` 合约， 让它继承自 `Ownable`。 如果您不记得怎么做了，看看 `zombiefeeding.sol`。

``` solidity
// 1. 在这里导入
import "./ownable.sol";
// 2. 在这里继承:
contract ZombieFactory is Ownable {
	// ... other code ...
}
```



#### 第3章 onlyOwner 函数修饰符

现在我们有了个基本版的合约 `ZombieFactory` 了，它继承自 `Ownable` 接口，我们也可以给 `ZombieFeeding` 加上 `onlyOwner` 函数修饰符。

这就是合约继承的工作原理。记得：

```
ZombieFeeding 是个 ZombieFactory
ZombieFactory 是个 Ownable
```

因此 `ZombieFeeding` 也是个 `Ownable`, 并可以通过 `Ownable` 接口访问父类中的函数/事件/修饰符。往后，`ZombieFeeding` 的继承者合约们同样也可以这么延续下去。

##### 函数修饰符

函数修饰符看起来跟函数没什么不同，不过关键字`modifier` 告诉编译器，这是个`modifier(修饰符)`，而不是个`function(函数)`。它不能像函数那样被直接调用，只能被添加到函数定义的末尾，用以改变函数的行为。

咱们仔细读读 `onlyOwner`:

```solidity
/**
 * @dev 调用者不是‘主人’，就会抛出异常
 */
modifier onlyOwner() {
  require(msg.sender == owner);
  _;
}
```

`onlyOwner` 函数修饰符是这么用的：

```solidity
contract MyContract is Ownable {
  event LaughManiacally(string laughter);

  //注意！ `onlyOwner`上场 :
  function likeABoss() external onlyOwner {
    LaughManiacally("Muahahahaha");
  }
}
```

注意 `likeABoss` 函数上的 `onlyOwner` 修饰符。 当你调用 `likeABoss` 时，**首先执行** `onlyOwner` 中的代码， 执行到 `onlyOwner` 中的 `_;` 语句时，程序再返回并执行 `likeABoss` 中的代码。

可见，尽管函数修饰符也可以应用到各种场合，但最常见的还是放在函数执行之前添加快速的 `require`检查。

因为给函数添加了修饰符 `onlyOwner`，使得**唯有合约的主人**（也就是部署者）才能调用它。

> 注意：主人对合约享有的特权当然是正当的，不过也可能被恶意使用。比如，万一，主人添加了个后门，允许他偷走别人的僵尸呢？

> 所以非常重要的是，部署在以太坊上的 DApp，并不能保证它真正做到去中心，你需要阅读并理解它的源代码，才能防止其中没有被部署者恶意植入后门；作为开发人员，如何做到既要给自己留下修复 bug 的余地，又要尽量地放权给使用者，以便让他们放心你，从而愿意把数据放在你的 DApp 中，这确实需要个微妙的平衡。

##### 实战演习

现在我们可以限制第三方对 `setKittyContractAddress`的访问，除了我们自己，谁都无法去修改它。

1. 将 `onlyOwner` 函数修饰符添加到 `setKittyContractAddress` 中。

``` solidity
function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
}
```



#### 第4章 Gas

厉害！现在我们懂了如何在禁止第三方修改我们的合约的同时，留个后门给咱们自己去修改。

让我们来看另一种使得 Solidity 编程语言与众不同的特征：

##### Gas - 驱动以太坊DApps的能源

在 Solidity 中，你的用户想要每次执行你的 DApp 都需要支付一定的 ***gas***，gas 可以用以太币购买，因此，用户每次跑 DApp 都得花费以太币。

一个 DApp 收取多少 gas 取决于功能逻辑的复杂程度。每个操作背后，都在计算完成这个操作所需要的计算资源，（比如，存储数据就比做个加法运算贵得多）， 一次操作所需要花费的 ***gas*** 等于这个操作背后的所有运算花销的总和。

由于运行你的程序需要花费用户的真金白银，在以太坊中代码的编程语言，比其他任何编程语言都更强调优化。同样的功能，使用笨拙的代码开发的程序，比起经过精巧优化的代码来，运行花费更高，这显然会给成千上万的用户带来大量不必要的开销。

##### 为什么要用 ***gas*** 来驱动？

以太坊就像一个巨大、缓慢、但非常安全的电脑。当你运行一个程序的时候，网络上的每一个节点都在进行相同的运算，以验证它的输出 —— 这就是所谓的“去中心化” 由于数以千计的节点同时在验证着每个功能的运行，这可以确保它的数据不会被被监控，或者被刻意修改。

可能会有用户用无限循环堵塞网络，抑或用密集运算来占用大量的网络资源，为了防止这种事情的发生，以太坊的创建者为以太坊上的资源制定了价格，想要在以太坊上运算或者存储，你需要先付费。

> 注意：如果你使用侧链，倒是不一定需要付费，比如咱们在 Loom Network 上构建的 CryptoZombies 就免费。你不会想要在以太坊主网上玩儿“魔兽世界”吧？ - 所需要的 gas 可能会买到你破产。但是你可以找个算法理念不同的侧链来玩它。我们将在以后的课程中咱们会讨论到，什么样的 DApp 应该部署在太坊主链上，什么又最好放在侧链。

##### 省 gas 的招数：结构封装 （Struct packing）

在第1课中，我们提到除了基本版的 `uint` 外，还有其他变种 `uint`：`uint8`，`uint16`，`uint32`等。

通常情况下我们不会考虑使用 `uint` 变种，因为无论如何定义 `uint`的大小，Solidity 为它保留256位的存储空间。例如，使用 `uint8` 而不是`uint`（`uint256`）不会为你节省任何 gas。

除非，把 `uint` 绑定到 `struct` 里面。

如果一个 `struct` 中有多个 `uint`，则尽可能使用较小的 `uint`, Solidity 会将这些 `uint` 打包在一起，从而占用较少的存储空间。例如：

```
struct NormalStruct {
  uint a;
  uint b;
  uint c;
}

struct MiniMe {
  uint32 a;
  uint32 b;
  uint c;
}

// 因为使用了结构打包，`mini` 比 `normal` 占用的空间更少
NormalStruct normal = NormalStruct(10, 20, 30);
MiniMe mini = MiniMe(10, 20, 30); 
```

所以，当 `uint` 定义在一个 `struct` 中的时候，尽量使用最小的整数子类型以节约空间。 并且把同样类型的变量放一起（即在 struct 中将把变量按照类型依次放置），这样 Solidity 可以将存储空间最小化。例如，有两个 `struct`：

```
uint c; uint32 a; uint32 b;` 和 `uint32 a; uint c; uint32 b;
```

前者比后者需要的gas更少，因为前者把`uint32`放一起了。

##### 实战演习

在本课中，咱们给僵尸添2个新功能：`level` 和 `readyTime` - 后者是用来实现一个“冷却定时器”，以限制僵尸猎食的频率。

让我们回到 `zombiefactory.sol`。

1. 为 `Zombie` 结构体 添加两个属性：`level`（`uint32`）和`readyTime`（`uint32`）。因为希望同类型数据打成一个包，所以把它们放在结构体的末尾。

32位足以保存僵尸的级别和时间戳了，这样比起使用普通的`uint`（256位），可以更紧密地封装数据，从而为我们省点 gas。

``` solidity
struct Zombie {
    string name;
    uint dna;
    uint32 level;
    uint32 readyTime;
}
```



#### 第5章 时间单位

`level` 属性表示僵尸的级别。以后，在我们创建的战斗系统中，打胜仗的僵尸会逐渐升级并获得更多的能力。

`readyTime` 稍微复杂点。我们希望增加一个“冷却周期”，表示僵尸在两次猎食或攻击之之间必须等待的时间。如果没有它，僵尸每天可能会攻击和繁殖1,000次，这样游戏就太简单了。

为了记录僵尸在下一次进击前需要等待的时间，我们使用了 Solidity 的时间单位。

##### 时间单位

Solidity 使用自己的本地时间单位。

变量 `now` 将返回当前的unix时间戳（自1970年1月1日以来经过的秒数）。我写这句话时 unix 时间是 `1515527488`。

> 注意：Unix时间传统用一个32位的整数进行存储。这会导致“2038年”问题，当这个32位的unix时间戳不够用，产生溢出，使用这个时间的遗留系统就麻烦了。所以，如果我们想让我们的 DApp 跑够20年，我们可以使用64位整数表示时间，但为此我们的用户又得支付更多的 gas。真是个两难的设计啊！

Solidity 还包含`秒(seconds)`，`分钟(minutes)`，`小时(hours)`，`天(days)`，`周(weeks)` 和 `年(years)` 等时间单位。它们都会转换成对应的秒数放入 `uint` 中。所以 `1分钟` 就是 `60`，`1小时`是 `3600`（60秒×60分钟），`1天`是`86400`（24小时×60分钟×60秒），以此类推。

下面是一些使用时间单位的实用案例：

```solidity
uint lastUpdated;

// 将‘上次更新时间’ 设置为 ‘现在’
function updateTimestamp() public {
  lastUpdated = now;
}

// 如果到上次`updateTimestamp` 超过5分钟，返回 'true'
// 不到5分钟返回 'false'
function fiveMinutesHavePassed() public view returns (bool) {
  return (now >= (lastUpdated + 5 minutes));
}
```

有了这些工具，我们可以为僵尸设定“冷静时间”功能。

##### 实战演习

现在咱们给DApp添加一个“冷却周期”的设定，让僵尸两次攻击或捕猎之间必须等待 **1天**。

1. 声明一个名为 `cooldownTime` 的`uint`，并将其设置为 `1 days`。（没错，”1 days“使用了复数， 否则通不过编译器）

2. 因为在上一章中我们给 `Zombie` 结构体中添加 `level` 和 `readyTime` 两个参数，所以现在创建一个新的 `Zombie` 结构体时，需要修改 `_createZombie()`，在其中把新旧参数都初始化一下。

   修改 `zombies.push` 那一行， 添加加2个参数：`1`（表示当前的 `level` ）和`uint32（now + cooldownTime）`（现在+冷却时间，表示下次允许攻击的时间 `readyTime`）。

> 注意：必须使用 `uint32（...）` 进行强制类型转换，因为 `now` 返回类型 `uint256`。所以我们需要明确将它转换成一个 `uint32` 类型的变量。

`now + cooldownTime` 将等于当前的unix时间戳（以秒为单位）加上”1天“里的秒数 - 这将等于从现在起1天后的unix时间戳。然后我们就比较，看看这个僵尸的 `readyTime`是否大于 `now`，以决定再次启用僵尸的时机有没有到来。

下一章中，我们将讨论如何通过 `readyTime` 来规范僵尸的行为。

``` solidity
contract ZombieFactory is Ownable {
		// ... other code ...
    uint cooldownTime = 1 days;
    // ... other code ...
    function _createZombie(string memory _name, uint _dna) internal {
    	zombies.push(Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime)));
    	// ... other code ...
    }
}
```



#### 第6章 僵尸冷却

现在，`Zombie` 结构体中定义好了一个 `readyTime` 属性，让我们跳到 `zombiefeeding.sol`， 去实现一个”冷却周期定时器“。

按照以下步骤修改 `feedAndMultiply`：

1. ”捕猎“行为会触发僵尸的”冷却周期“
2. 僵尸在这段”冷却周期“结束前不可再捕猎小猫

这将限制僵尸，防止其无限制地捕猎小猫或者整天不停地繁殖。将来，当我们增加战斗功能时，我们同样用”冷却周期“限制僵尸之间打斗的频率。

首先，我们要定义一些辅助函数，设置并检查僵尸的 `readyTime`。

##### 将结构体作为参数传入

由于结构体的存储指针可以以参数的方式传递给一个 `private` 或 `internal` 的函数，因此结构体可以在多个函数之间相互传递。

遵循这样的语法：

```solidity
function _doStuff(Zombie storage _zombie) internal {
  // do stuff with _zombie
}
```

这样我们可以将某僵尸的引用直接传递给一个函数，而不用是通过参数传入僵尸ID后，函数再依据ID去查找。

##### 实战演习

1. 先定义一个 `_triggerCooldown` 函数。它要求一个参数，`_zombie`，表示一某个僵尸的存储指针。这个函数可见性设置为 `internal`。
2. 在函数中，把 `_zombie.readyTime` 设置为 `uint32（now + cooldownTime）`。
3. 接下来，创建一个名为 `_isReady` 的函数。这个函数的参数也是名为 `_zombie` 的 `Zombie storage`。这个功能只具有 `internal` 可见性，并返回一个 `bool` 值。
4. 函数计算返回`(_zombie.readyTime <= now)`，值为 `true` 或 `false`。这个功能的目的是判断下次允许猎食的时间是否已经到了。

``` solidity
contract ZombieFeeding is ZombieFactory {

    KittyInterface kittyContract;

    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(block.timestamp + cooldownTime);
    }

    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return (_zombie.readyTime <= block.timestamp);
    }
    // ... other code ...
}
```



#### 第7章 公有函数和安全性

现在来修改 `feedAndMultiply` ，实现冷却周期。

回顾一下这个函数，前一课上我们将其可见性设置为`public`。你必须仔细地检查所有声明为 `public` 和 `external`的函数，一个个排除用户滥用它们的可能，谨防安全漏洞。请记住，如果这些函数没有类似 `onlyOwner` 这样的函数修饰符，用户能利用各种可能的参数去调用它们。

检查完这个函数，用户就可以直接调用这个它，并传入他们所希望的 `_targetDna` 或 `species` 。打个游戏还得遵循这么多的规则，还能不能愉快地玩耍啊！

仔细观察，这个函数只需被 `feedOnKitty()` 调用，因此，想要防止漏洞，最简单的方法就是设其可见性为 `internal`。

##### 实战演习

1. 目前函数 `feedAndMultiply` 可见性为 `public`。我们将其改为 `internal` 以保障合约安全。因为我们不希望用户调用它的时候塞进一堆乱七八糟的 DNA。
2. `feedAndMultiply` 过程需要参考 `cooldownTime`。首先，在找到 `myZombie` 之后，添加一个 `require` 语句来检查 `_isReady()` 并将 `myZombie` 传递给它。这样用户必须等到僵尸的 `冷却周期` 结束后才能执行 `feedAndMultiply` 功能。
3. 在函数结束时，调用 `_triggerCooldown(myZombie)`，标明捕猎行为触发了僵尸新的冷却周期。

``` solidity
function feedAndMultiply(uint256 _zombieId, uint256 _targetDna, string memory _species) internal {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    require(_isReady(myZombie));
    _targetDna = _targetDna % dnaModulus;
    uint256 newDna = (myZombie.dna + _targetDna) / 2;
    // 这里增加一个 if 语句
    if(keccak256(abi.encode(_species)) == keccak256(abi.encode("kitty"))){
        newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
    _triggerCooldown(myZombie);
}
```



#### 第8章 进一步了解函数修饰符

相当不错！我们的僵尸现在有了“冷却定时器”功能。

接下来，我们将添加一些辅助方法。我们为您创建了一个名为 `zombiehelper.sol` 的新文件，并且将 `zombiefeeding.sol` 导入其中，这让我们的代码更整洁。

我们打算让僵尸在达到一定水平后，获得特殊能力。但是达到这个小目标，我们还需要学一学什么是“函数修饰符”。

##### 带参数的函数修饰符

之前我们已经读过一个简单的函数修饰符了：`onlyOwner`。函数修饰符也可以带参数。例如：

```solidity
// 存储用户年龄的映射
mapping (uint => uint) public age;

// 限定用户年龄的修饰符
modifier olderThan(uint _age, uint _userId) {
  require(age[_userId] >= _age);
  _;
}

// 必须年满16周岁才允许开车 (至少在美国是这样的).
// 我们可以用如下参数调用`olderThan` 修饰符:
function driveCar(uint _userId) public olderThan(16, _userId) {
  // 其余的程序逻辑
}
```

看到了吧， `olderThan` 修饰符可以像函数一样接收参数，是“宿主”函数 `driveCar` 把参数传递给它的修饰符的。

来，我们自己生产一个修饰符，通过传入的`level`参数来限制僵尸使用某些特殊功能。

##### 实战演习

1. 在`ZombieHelper` 中，创建一个名为 `aboveLevel` 的`modifier`，它接收2个参数， `_level` (`uint`类型) 以及 `_zombieId` (`uint`类型)。
2. 运用函数逻辑确保僵尸 `zombies[_zombieId].level` 大于或等于 `_level`。
3. 记住，修饰符的最后一行为 `_;`，表示修饰符调用结束后返回，并执行调用函数余下的部分。

``` solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }
}
```



#### 第9章 僵尸修饰符

现在让我们设计一些使用 `aboveLevel` 修饰符的函数。

作为游戏，您得有一些措施激励玩家们去升级他们的僵尸：

- 2级以上的僵尸，玩家可给他们改名。
- 20级以上的僵尸，玩家能给他们定制的 DNA。

是实现这些功能的时候了。以下是上一课的示例代码，供参考：

```solidity
// 存储用户年龄的映射
mapping (uint => uint) public age;

// 限定用户年龄的修饰符
modifier olderThan(uint _age, uint _userId) {
  require (age[_userId] >= _age);
  _;
}

// 必须年满16周岁才允许开车 (至少在美国是这样的).
// 我们可以用如下参数调用`olderThan` 修饰符:
function driveCar(uint _userId) public olderThan(16, _userId) {
  // 其余的程序逻辑
}
```

##### 实战演习

1. 创建一个名为 `changeName` 的函数。它接收2个参数：`_zombieId`（`uint`类型）以及 `_newName`（`string`类型），可见性为 `external`。它带有一个 `aboveLevel` 修饰符，调用的时候通过 `_level` 参数传入`2`， 当然，别忘了同时传 `_zombieId` 参数。
2. 在这个函数中，首先我们用 `require` 语句，验证 `msg.sender` 是否就是 `zombieToOwner [_zombieId]`。
3. 然后函数将 `zombies[_zombieId] .name` 设置为 `_newName`。
4. 在 `changeName` 下创建另一个名为 `changeDna` 的函数。它的定义和内容几乎和 `changeName` 相同，不过它第二个参数是 `_newDna`（`uint`类型），在修饰符 `aboveLevel` 的 `_level` 参数中传递 `20` 。现在，他可以把僵尸的 `dna` 设置为 `_newDna` 了。

``` solidity
// 修改僵尸名字
function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
}

// 定制 DNA
function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
}
```



#### 第10章 利用 'View' 函数节省 Gas

酷炫！现在高级别僵尸可以拥有特殊技能了，这一定会鼓动我们的玩家去打怪升级的。你喜欢的话，回头我们还能添加更多的特殊技能。

现在需要添加的一个功能是：我们的 DApp 需要一个方法来查看某玩家的整个僵尸军团 - 我们称之为 `getZombiesByOwner`。

实现这个功能只需从区块链中读取数据，所以它可以是一个 `view` 函数。这让我们不得不回顾一下“gas优化”这个重要话题。

##### “view” 函数不花 “gas”

当玩家从外部调用一个`view`函数，是不需要支付一分 gas 的。

这是因为 `view` 函数不会真正改变区块链上的任何数据 - 它们只是读取。因此用 `view` 标记一个函数，意味着告诉 `web3.js`，运行这个函数只需要查询你的本地以太坊节点，而不需要在区块链上创建一个事务（事务需要运行在每个节点上，因此花费 gas）。

稍后我们将介绍如何在自己的节点上设置 web3.js。但现在，你关键是要记住，在所能只读的函数上标记上表示“只读”的“`external view` 声明，就能为你的玩家减少在 DApp 中 gas 用量。

> 注意：如果一个 `view` 函数在另一个函数的内部被调用，而调用函数与 `view` 函数的不属于同一个合约，也会产生调用成本。这是因为如果主调函数在以太坊创建了一个事务，它仍然需要逐个节点去验证。所以标记为 `view` 的函数只有在外部调用时才是免费的。

##### 实战演习

我们来写一个”返回某玩家的整个僵尸军团“的函数。当我们从 `web3.js` 中调用它，即可显示某一玩家的个人资料页。

这个函数的逻辑有点复杂，我们需要好几个章节来描述它的实现。

1. 创建一个名为 `getZombiesByOwner` 的新函数。它有一个名为 `_owner` 的 `address` 类型的参数。
2. 将其申明为 `external view` 函数，这样当玩家从 `web3.js` 中调用它时，不需要花费任何 gas。
3. 函数需要返回一个`uint []`（`uint`数组）。

先这么声明着，我们将在下一章中填充函数体。

``` solidity
function getZombiesByOwner(address _owner) external view returns (uint []) {
    // ... other return code ...
}
```



#### 第11章 存储非常昂贵

Solidity 使用`storage`(存储)是相当昂贵的，”写入“操作尤其贵。

这是因为，无论是写入还是更改一段数据， 这都将永久性地写入区块链。”永久性“啊！需要在全球数千个节点的硬盘上存入这些数据，随着区块链的增长，拷贝份数更多，存储量也就越大。这是需要成本的！

为了降低成本，不到万不得已，避免将数据写入存储。这也会导致效率低下的编程逻辑 - 比如每次调用一个函数，都需要在 `memory`(内存) 中重建一个数组，而不是简单地将上次计算的数组给存储下来以便快速查找。

在大多数编程语言中，遍历大数据集合都是昂贵的。但是在 Solidity 中，使用一个标记了`external view`的函数，遍历比 `storage` 要便宜太多，因为 `view` 函数不会产生任何花销。 （gas可是真金白银啊！）。

我们将在下一章讨论`for`循环，现在我们来看一下看如何如何在内存中声明数组。

##### 在内存中声明数组

在数组后面加上 `memory`关键字， 表明这个数组是仅仅在内存中创建，不需要写入外部存储，并且在函数调用结束时它就解散了。与在程序结束时把数据保存进 `storage` 的做法相比，内存运算可以大大节省gas开销 -- 把这数组放在`view`里用，完全不用花钱。

以下是申明一个内存数组的例子：

```solidity
function getArray() external pure returns(uint[]) {
  // 初始化一个长度为3的内存数组
  uint[] memory values = new uint[](3);
  // 赋值
  values.push(1);
  values.push(2);
  values.push(3);
  // 返回数组
  return values;
}
```

这个小例子展示了一些语法规则，下一章中，我们将通过一个实际用例，展示它和 `for` 循环结合的做法。

> 注意：内存数组 **必须** 用长度参数（在本例中为`3`）创建。目前不支持 `array.push()`之类的方法调整数组大小，在未来的版本可能会支持长度修改。

##### 实战演习

我们要要创建一个名为 `getZombiesByOwner` 的函数，它以`uint []`数组的形式返回某一用户所拥有的所有僵尸。

1. 声明一个名为`result`的`uint [] memory'` （内存变量数组）
2. 将其设置为一个新的 `uint` 类型数组。数组的长度为该 `_owner` 所拥有的僵尸数量，这可通过调用 `ownerZombieCount [_ owner]` 来获取。
3. 函数结束，返回 `result` 。目前它只是个空数列，我们到下一章去实现它。

``` solidity
function getZombiesByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    return result;
  }
```



#### 第12章 For 循环

在之前的章节中，我们提到过，函数中使用的数组是运行时在内存中通过 `for` 循环实时构建，而不是预先建立在存储中的。

为什么要这样做呢？

为了实现 `getZombiesByOwner` 函数，一种“无脑式”的解决方案是在 `ZombieFactory` 中存入”主人“和”僵尸军团“的映射。

```solidity
mapping (address => uint[]) public ownerToZombies
```

然后我们每次创建新僵尸时，执行 `ownerToZombies [owner] .push（zombieId）` 将其添加到主人的僵尸数组中。而 `getZombiesByOwner` 函数也非常简单：

```solidity
function getZombiesByOwner(address _owner) external view returns (uint[]) {
  return ownerToZombies[_owner];
}
```

##### 这个做法有问题

做法倒是简单。可是如果我们需要一个函数来把一头僵尸转移到另一个主人名下（我们一定会在后面的课程中实现的），又会发生什么？

这个“换主”函数要做到：

1.将僵尸push到新主人的 `ownerToZombies` 数组中， 2.从旧主的 `ownerToZombies` 数组中移除僵尸， 3.将旧主僵尸数组中“换主僵尸”之后的的每头僵尸都往前挪一位，把挪走“换主僵尸”后留下的“空槽”填上， 4.将数组长度减1。

但是第三步实在是太贵了！因为每挪动一头僵尸，我们都要执行一次写操作。如果一个主人有20头僵尸，而第一头被挪走了，那为了保持数组的顺序，我们得做19个写操作。

由于写入存储是 Solidity 中最费 gas 的操作之一，使得换主函数的每次调用都非常昂贵。更糟糕的是，每次调用的时候花费的 gas 都不同！具体还取决于用户在原主军团中的僵尸头数，以及移走的僵尸所在的位置。以至于用户都不知道应该支付多少 gas。

> 注意：当然，我们也可以把数组中最后一个僵尸往前挪来填补空槽，并将数组长度减少一。但这样每做一笔交易，都会改变僵尸军团的秩序。

由于从外部调用一个 `view` 函数是免费的，我们也可以在 `getZombiesByOwner` 函数中用一个for循环遍历整个僵尸数组，把属于某个主人的僵尸挑出来构建出僵尸数组。那么我们的 `transfer` 函数将会便宜得多，因为我们不需要挪动存储里的僵尸数组重新排序，总体上这个方法会更便宜，虽然有点反直觉。

##### 使用 `for` 循环

`for`循环的语法在 Solidity 和 JavaScript 中类似。

来看一个创建偶数数组的例子：

```solidity
function getEvens() pure external returns(uint[]) {
  uint[] memory evens = new uint[](5);
  // 在新数组中记录序列号
  uint counter = 0;
  // 在循环从1迭代到10：
  for (uint i = 1; i <= 10; i++) {
    // 如果 `i` 是偶数...
    if (i % 2 == 0) {
      // 把它加入偶数数组
      evens[counter] = i;
      //索引加一， 指向下一个空的‘even’
      counter++;
    }
  }
  return evens;
}
```

这个函数将返回一个形为 `[2,4,6,8,10]` 的数组。

##### 实战演习

我们回到 `getZombiesByOwner` 函数， 通过一条 `for` 循环来遍历 DApp 中所有的僵尸， 将给定的‘用户id'与每头僵尸的‘主人’进行比较，并在函数返回之前将它们推送到我们的`result` 数组中。

1.声明一个变量 `counter`，属性为 `uint`，设其值为 `0` 。我们用这个变量作为 `result` 数组的索引。

2.声明一个 `for` 循环， 从 `uint i = 0` 到 `i <zombies.length`。它将遍历数组中的每一头僵尸。

3.在每一轮 `for` 循环中，用一个 `if` 语句来检查 `zombieToOwner [i]` 是否等于 `_owner`。这会比较两个地址是否匹配。

4.在 `if` 语句中：

1. 通过将 `result [counter]` 设置为 `i`，将僵尸ID添加到 `result` 数组中。
2. 将counter加1（参见上面的for循环示例）。

就是这样 - 这个函数能返回 `_owner` 所拥有的僵尸数组，不花一分钱 gas。

``` solidity
function getZombiesByOwner(address _owner)
    external
    view
    returns (uint256[] memory)
{
    uint256[] memory result = new uint256[](ownerZombieCount[_owner]);
    uint256 counter = 0;
    for (uint256 i = 0; i < zombies.length; i++) {
        if (zombieToOwner[i] == _owner) {
            result[counter] = i;
            counter++;
        }
    }
    return result;
}
```



#### 第13章 放在一起

恭喜您啊，居然把第三课也学完了！

##### 让我们回顾一下：

- 添加了一种新方法来修改CryptoKitties合约
- 学会使用 `onlyOwner` 进行调用权限限制
- 了解了 gas 和 gas 的优化
- 为僵尸添加了 “级别” 和 “冷却周期”属性
- 当僵尸达到一定级别时，允许修改僵尸的名字和 DNA
- 最后，定义了一个函数，用以返回某个玩家的僵尸军团

##### 领奖时间

作为完成第三课的奖励，您的两个僵尸都已经升级了！

现在 NoName（你在第2课创建的小猫僵尸）已经升级到第2级，你可以调用 `changeName` 给它取个名字。 终于不再是无名之辈了！

去给您的 NoName 取个名字吧，等你做完下一章，本课程就结束了。

<img src="https://markdown-res.oss-cn-hangzhou.aliyuncs.com/mdImgs/2022/05/07/20220507134656.png" align="center" style="width:500px" />

##### 恭喜! 你完成了 CryptoZombies 的第三课

**成就解锁了:**

- GG 升级到了第 3 级!
- TT 升级到了第 2 级!

##### 向你的朋友们炫耀你的僵尸吧

把这个网址发送给你的朋友，他们就能围观你的僵尸大军了:

https://share.cryptozombies.io/zh/lesson/3/share/GG?id=Y3p8MjEwMTY2



### 1.4 僵尸作战系统

这一刻终于来了, 人类……

是时候让你的僵尸战斗了！

不过僵尸大战并不适合胆小的人……

在这一课, 我们将综合利用在前面课程中学到的许多知识，创建一个僵尸作战系统。 我们也将学习 `payable` 函数，学习如何开发可以接收其他玩家付款的DApp。



#### 第1章 可支付

截至目前，我们只接触到很少的 ***函数修饰符***。 要记住所有的东西很难，所以我们来个概览：

1. 我们有决定函数何时和被谁调用的可见性修饰符: `private` 意味着它只能被合约内部调用； `internal` 就像 `private` 但是也能被继承的合约调用； `external` 只能从合约外部调用；最后 `public` 可以在任何地方调用，不管是内部还是外部。
2. 我们也有状态修饰符， 告诉我们函数如何和区块链交互: `view` 告诉我们运行这个函数不会更改和保存任何数据； `pure` 告诉我们这个函数不但不会往区块链写数据，它甚至不从区块链读取数据。这两种在被从合约外部调用的时候都不花费任何gas（但是它们在被内部其他函数调用的时候将会耗费gas）。
3. 然后我们有了自定义的 `modifiers`，例如在第三课学习的: `onlyOwner` 和 `aboveLevel`。 对于这些修饰符我们可以自定义其对函数的约束逻辑。

这些修饰符可以同时作用于一个函数定义上：

```solidity
function test() external view onlyOwner anotherModifier { /* ... */ }
```

在这一章，我们来学习一个新的修饰符 `payable`.

##### `payable` 修饰符

`payable` 方法是让 Solidity 和以太坊变得如此酷的一部分 —— 它们是一种可以接收以太的特殊函数。

先放一下。当你在调用一个普通网站服务器上的API函数的时候，你无法用你的函数传送美元——你也不能传送比特币。

但是在以太坊中， 因为钱 (_以太_), 数据 (*事务负载*)， 以及合约代码本身都存在于以太坊。你可以在同时调用函数 **并**付钱给另外一个合约。

这就允许出现很多有趣的逻辑， 比如向一个合约要求支付一定的钱来运行一个函数。

##### 来看个例子

```solidity
contract OnlineStore {
  function buySomething() external payable {
    // 检查以确定0.001以太发送出去来运行函数:
    require(msg.value == 0.001 ether);
    // 如果为真，一些用来向函数调用者发送数字内容的逻辑
    transferThing(msg.sender);
  }
}
```

在这里，`msg.value` 是一种可以查看向合约发送了多少以太的方法，另外 `ether` 是一个內建单元。

这里发生的事是，一些人会从 web3.js 调用这个函数 (从DApp的前端)， 像这样 :

```solidity
// 假设 `OnlineStore` 在以太坊上指向你的合约:
OnlineStore.buySomething().send(from: web3.eth.defaultAccount, value: web3.utils.toWei(0.001))
```

注意这个 `value` 字段， JavaScript 调用来指定发送多少(0.001)`以太`。如果把事务想象成一个信封，你发送到函数的参数就是信的内容。 添加一个 `value` 很像在信封里面放钱 —— 信件内容和钱同时发送给了接收者。

> 注意： 如果一个函数没标记为`payable`， 而你尝试利用上面的方法发送以太，函数将拒绝你的事务。

##### 实战演习

我们来在僵尸游戏里面创建一个`payable` 函数。

假定在我们的游戏中，玩家可以通过支付ETH来升级他们的僵尸。ETH将存储在你拥有的合约中 —— 一个简单明了的例子，向你展示你可以通过自己的游戏赚钱。

1. 定义一个 `uint` ，命名为 `levelUpFee`, 将值设定为 `0.001 ether`。
2. 定义一个名为 `levelUp` 的函数。 它将接收一个 `uint` 参数 `_zombieId`。 函数应该修饰为 `external` 以及 `payable`。
3. 这个函数首先应该 `require` 确保 `msg.value` 等于 `levelUpFee`。
4. 然后它应该增加僵尸的 `level`: `zombies[_zombieId].level++`。

``` solidity
// 升级所需支付费用
uint levelUpFee = 0.001 ether;
// ... other code ...
// 支付eth，升级僵尸 
function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    zombies[_zombieId].level++;
}
```



#### 第2章 提现

在上一章，我们学习了如何向合约发送以太，那么在发送之后会发生什么呢？

在你发送以太之后，它将被存储进以合约的以太坊账户中， 并冻结在哪里 —— 除非你添加一个函数来从合约中把以太提现。

你可以写一个函数来从合约中提现以太，类似这样：

```solidity
contract GetPaid is Ownable {
  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }
}
```

注意我们使用 `Ownable` 合约中的 `owner` 和 `onlyOwner`，假定它已经被引入了。

你可以通过 `transfer` 函数向一个地址发送以太， 然后 `this.balance` 将返回当前合约存储了多少以太。 所以如果100个用户每人向我们支付1以太， `this.balance` 将是100以太。

你可以通过 `transfer` 向任何以太坊地址付钱。 比如，你可以有一个函数在 `msg.sender` 超额付款的时候给他们退钱：

```solidity
uint itemFee = 0.001 ether;
msg.sender.transfer(msg.value - itemFee);
```

或者在一个有卖家和卖家的合约中， 你可以把卖家的地址存储起来， 当有人买了它的东西的时候，把买家支付的钱发送给它 `seller.transfer(msg.value)`。

有很多例子来展示什么让以太坊编程如此之酷 —— 你可以拥有一个不被任何人控制的去中心化市场。

##### 实战演习

1. 在我们的合约里创建一个 `withdraw` 函数，它应该几乎和上面的`GetPaid`一样。

2. 以太的价格在过去几年内翻了十几倍，在我们写这个教程的时候 0.01 以太相当于1美元，如果它再翻十倍 0.001 以太将是10美元，那我们的游戏就太贵了。

   所以我们应该再创建一个函数，允许我们以合约拥有者的身份来设置 `levelUpFee`。

   a. 创建一个函数，名为 `setLevelUpFee`， 其接收一个参数 `uint _fee`，是 `external` 并使用修饰符 `onlyOwner`。

   b. 这个函数应该设置 `levelUpFee` 等于 `_fee`。

``` solidity
// 从合约中提现以太
function withdraw() external onlyOwner {
    payable(owner).transfer(address(this).balance);
}
// 设置支付费用 
function setLevelUpfee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
}
```



#### 第3章 僵尸战斗

在我们学习了可支付函数和合约余额之后，是时候为僵尸战斗添加功能了。

遵循上一章的格式，我们新建一个攻击功能合约，并将代码放进新的文件中，引入上一个合约。

##### 实战演习

再来新建一个合约吧。熟能生巧。

如果你不记得怎么做了, 查看一下 `zombiehelper.sol` — 不过最好先试着做一下，检查一下你掌握的情况。

1. 在文件开头定义 Solidity 的版本 `^0.4.19`.
2. `import` 自 `zombiehelper.sol` .
3. 声明一个新的 `contract`，命名为 `ZombieBattle`， 继承自`ZombieHelper`。函数体就先空着吧。

``` solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.19;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
}
```



#### 第4章 随机数

你太棒了！接下来我们梳理一下战斗逻辑。

优秀的游戏都需要一些随机元素，那么我们在 Solidity 里如何生成随机数呢？

真正的答案是你不能，或者最起码，你无法安全地做到这一点。

我们来看看为什么

##### 用 `keccak256` 来制造随机数。

Solidity 中最好的随机数生成器是 `keccak256` 哈希函数.

我们可以这样来生成一些随机数

```solidity
// 生成一个0到100的随机数:
uint randNonce = 0;
uint random = uint(keccak256(now, msg.sender, randNonce)) % 100;
randNonce++;
uint random2 = uint(keccak256(now, msg.sender, randNonce)) % 100;
```

这个方法首先拿到 `now` 的时间戳、 `msg.sender`、 以及一个自增数 `nonce` （一个仅会被使用一次的数，这样我们就不会对相同的输入值调用一次以上哈希函数了）。

然后利用 `keccak` 把输入的值转变为一个哈希值, 再将哈希值转换为 `uint`, 然后利用 `% 100` 来取最后两位, 就生成了一个0到100之间随机数了。

##### 这个方法很容易被不诚实的节点攻击

在以太坊上, 当你在和一个合约上调用函数的时候, 你会把它广播给一个节点或者在网络上的 ***transaction*** 节点们。 网络上的节点将收集很多事务, 试着成为第一个解决计算密集型数学问题的人，作为“工作证明”，然后将“工作证明”(Proof of Work, PoW)和事务一起作为一个 ***block*** 发布在网络上。

一旦一个节点解决了一个PoW, 其他节点就会停止尝试解决这个 PoW, 并验证其他节点的事务列表是有效的，然后接受这个节点转而尝试解决下一个节点。

**这就让我们的随机数函数变得可利用了**

我们假设我们有一个硬币翻转合约——正面你赢双倍钱，反面你输掉所有的钱。假如它使用上面的方法来决定是正面还是反面 (`random >= 50` 算正面, `random < 50` 算反面)。

如果我正运行一个节点，我可以 **只对我自己的节点** 发布一个事务，且不分享它。 我可以运行硬币翻转方法来偷窥我的输赢 — 如果我输了，我就不把这个事务包含进我要解决的下一个区块中去。我可以一直运行这个方法，直到我赢得了硬币翻转并解决了下一个区块，然后获利。

##### 所以我们该如何在以太坊上安全地生成随机数呢

因为区块链的全部内容对所有参与者来说是透明的， 这就让这个问题变得很难，它的解决方法不在本课程讨论范围，你可以阅读 [这个 StackOverflow 上的讨论](https://ethereum.stackexchange.com/questions/191/how-can-i-securely-generate-a-random-number-in-my-smart-contract) 来获得一些主意。 一个方法是利用 ***oracle\*** 来访问以太坊区块链之外的随机数函数。

当然， 因为网络上成千上万的以太坊节点都在竞争解决下一个区块，我能成功解决下一个区块的几率非常之低。 这将花费我们巨大的计算资源来开发这个获利方法 — 但是如果奖励异常地高(比如我可以在硬币翻转函数中赢得 1个亿)， 那就很值得去攻击了。

所以尽管这个方法在以太坊上不安全，在实际中，除非我们的随机函数有一大笔钱在上面，你游戏的用户一般是没有足够的资源去攻击的。

因为在这个教程中，我们只是在编写一个简单的游戏来做演示，也没有真正的钱在里面，所以我们决定接受这个不足之处，使用这个简单的随机数生成函数。但是要谨记它是不安全的。

##### 实战演习

我们来实现一个随机数生成函数，好来计算战斗的结果。虽然这个函数一点儿也不安全。

1. 给我们合约一个名为 `randNonce` 的 `uint`，将其值设置为 `0`。
2. 建立一个函数，命名为 `randMod` (random-modulus)。它将作为`internal` 函数，传入一个名为 `_modulus`的 `uint`，并 `returns` 一个 `uint`。
3. 这个函数首先将为 `randNonce`加一， (使用 `randNonce++` 语句)。
4. 最后，它应该 (在一行代码中) 计算 `now`, `msg.sender`, 以及 `randNonce` 的 `keccak256` 哈希值并转换为 `uint`—— 最后 `return` `% _modulus` 的值。 （天! 听起来太拗口了。如果你有点理解不过来，看一下我们上面计算随机数的例子，它们的逻辑非常相似）

``` solidity
contract ZombieBattle is ZombieHelper {

    uint randNonce = 0;

    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        // 根据 Solidity 版本，做相应更新
        return uint(keccak256(abi.encode(block.timestamp, msg.sender, randNonce))) % _modulus;
    }
}
```



#### 第5章 僵尸对战

我们的合约已经有了一些随机性的来源，可以用进我们的僵尸战斗中去计算结果。

我们的僵尸战斗看起来将是这个流程：

- 你选择一个自己的僵尸，然后选择一个对手的僵尸去攻击。
- 如果你是攻击方，你将有70%的几率获胜，防守方将有30%的几率获胜。
- 所有的僵尸（攻守双方）都将有一个 `winCount` 和一个 `lossCount`，这两个值都将根据战斗结果增长。
- 若攻击方获胜，这个僵尸将升级并产生一个新僵尸。
- 如果攻击方失败，除了失败次数将加一外，什么都不会发生。
- 无论输赢，当前僵尸的冷却时间都将被激活。

这有一大堆的逻辑需要处理，我们将把这些步骤分解到接下来的课程中去。

##### 实战演习

1. 给我们合约一个 `uint` 类型的变量，命名为 `attackVictoryProbability`, 将其值设定为 `70`。
2. 创建一个名为 `attack`的函数。它将传入两个参数: `_zombieId` (`uint` 类型) 以及 `_targetId` (也是 `uint`)。它将是一个 `external` 函数。

函数体先留空吧。

``` solidity
contract ZombieBattle is ZombieHelper {

    uint randNonce = 0;
    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        // 根据 Solidity 版本，做相应更新
        return uint(keccak256(abi.encode(block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    function attack(uint _zombieId, uint _targetId) external {
        
    }
}
```



#### 第6章 重构通用逻辑

不管谁调用我们的 attack 函数 -- 我们想确保用户的确拥有他们用来攻击的僵尸。如果你能用其他人的僵尸来攻击将是一个很大的安全问题。

你能想一下我们如何添加一个检查步骤来看看调用这个函数的人就是他们传入的 _zombieID de 拥有者么？

想一想，看看你能不能自己找到一些答案。

花点时间…… 参考我们前面课程的代码来获得灵感。

答案在下面，在你有一些想法之前不要继续阅读。

##### 答案

我们在前面的课程里面已经做过很多次这样的检查了。 在 `changeName()`, `changeDna()`, 和 `feedAndMultiply()`里，我们做过这样的检查：

```solidity
require(msg.sender == zombieToOwner[_zombieId]);
```

这和我们 `attack` 函数将要用到的检查逻辑是相同的。 正因我们要多次调用这个检查逻辑，让我们把它移到它自己的 `modifier` 中来清理代码并避免重复编码。

##### 实战演习

我们回到了 `zombiefeeding.sol`， 因为这是我们第一次调用检查逻辑的地方。让我们把它重构进它自己的 `modifier`。

1. 创建一个 `modifier`， 命名为 `ownerOf`。它将传入一个参数， `_zombieId` (一个 `uint`)。

   它的函数体应该 `require` `msg.sender` 等于 `zombieToOwner[_zombieId]`， 然后继续这个函数剩下的内容。 如果你忘记了修饰符的写法，可以参考 `zombiehelper.sol`。

2. 将这个函数的 `feedAndMultiply` 定义修改为其使用修饰符 `ownerOf`。

3. 现在我们使用 `modifier`了，你可以删除这行了： `require(msg.sender == zombieToOwner[_zombieId]);`

在 ZombieFeeding 中，修改如下：

``` solidity
contract ZombieFeeding is ZombieFactory {

    KittyInterface kittyContract;

    // 校验僵尸拥有者
    modifier ownerOf(uint _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        _;
    }
    
    // ... other code ...
    
    function feedAndMultiply(uint256 _zombieId, uint256 _targetDna, string memory _species) internal ownerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        require(_isReady(myZombie));
        _targetDna = _targetDna % dnaModulus;
        uint256 newDna = (myZombie.dna + _targetDna) / 2;
        // 这里增加一个 if 语句
        if(keccak256(abi.encode(_species)) == keccak256(abi.encode("kitty"))){
            newDna = newDna - newDna % 100 + 99;
        }
        _createZombie("NoName", newDna);
        _triggerCooldown(myZombie);
    }
}
```



#### 第7章 更多重构

在 `zombiehelper.sol`里有几处地方，需要我们实现我们新的 `modifier`—— `ownerOf`。

##### 实战演习

1. 修改 `changeName()` 使其使用 `ownerOf`
2. 修改 `changeDna()` 使其使用 `ownerOf`

``` solidity
// 修改僵尸名字
function changeName(uint256 _zombieId, string calldata _newName)
    external
    aboveLevel(2, _zombieId)
    ownerOf(_zombieId)
{
    zombies[_zombieId].name = _newName;
}

// 定制 DNA
function changeDna(uint256 _zombieId, uint256 _newDna)
    external
    aboveLevel(20, _zombieId)
    ownerOf(_zombieId)
{
    zombies[_zombieId].dna = _newDna;
}
```



#### 第8章 回到攻击

重构完成了，回到 `zombieattack.sol`。

继续来完善我们的 `attack` 函数， 现在我们有了 `ownerOf` 修饰符来用了。

##### 实战演习

1. 将 `ownerOf` 修饰符添加到 `attack` 来确保调用者拥有`_zombieId`.

2. 我们的函数所需要做的第一件事就是获得一个双方僵尸的 `storage` 指针， 这样我们才能很方便和它们交互：

   a. 定义一个 `Zombie storage` 命名为 `myZombie`，使其值等于 `zombies[_zombieId]`。

   b. 定义一个 `Zombie storage` 命名为 `enemyZombie`， 使其值等于 `zombies[_targetId]`。

3. 我们将用一个0到100的随机数来确定我们的战斗结果。 定义一个 `uint`，命名为 `rand`， 设定其值等于 `randMod` 函数的返回值，此函数传入 `100`作为参数。

``` solidity
function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
    // 我方僵尸
    Zombie storage myZombie = zombies[_zombieId];
    // 攻击目标僵尸
    Zombie storage enemyZombie = zombies[_targetId];
    // 随机数确定战斗结果
    uint rand = randMod(100);
}
```



#### 第9章 僵尸的输赢

对我们的僵尸游戏来说，我们将要追踪我们的僵尸输赢了多少场。有了这个我们可以在游戏里维护一个 "僵尸排行榜"。

有多种方法在我们的DApp里面保存一个数值 — 作为一个单独的映射，作为一个“排行榜”结构体，或者保存在 `Zombie` 结构体内。

每个方法都有其优缺点，取决于我们打算如何和这些数据打交道。在这个教程中，简单起见我们将这个状态保存在 `Zombie` 结构体中，将其命名为 `winCount` 和 `lossCount`。

我们跳回 `zombiefactory.sol`, 将这些属性添加进 `Zombie` 结构体.

##### 实战演习

1. 修改 `Zombie` 结构体，添加两个属性:

   a. `winCount`, 一个 `uint16`

   b. `lossCount`, 也是一个 `uint16`

   > 注意： 记住, 因为我们能在结构体中包装`uint`, 我们打算用适合我们的最小的 `uint`。 一个 `uint8` 太小了， 因为 2^8 = 256 —— 如果我们的僵尸每天都作战，不到一年就溢出了。但是 2^16 = 65536 （`uint16`）—— 除非一个僵尸连续179年每天作战，否则我们就是安全的。

2. 现在我们的 `Zombie` 结构体有了新的属性， 我们需要修改 `_createZombie()` 中的函数定义。

   修改僵尸生成定义，让每个新僵尸都有 `0` 赢和 `0` 输。

``` solidity
struct Zombie {
    string name;
    uint dna;
    uint32 level;
    // 冷却定时器，限制僵尸猎食的频率
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
}

function _createZombie(string memory _name, uint _dna) internal {
    zombies.push(Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0));
    uint id = zombies.length -1;
    zombieToOwner[id] = msg.sender;
    ownerZombieCount[msg.sender]++;
    emit NewZombie(id, _name, _dna);
}
```



#### 第10章 僵尸胜利了 😄

有了 `winCount` 和 `lossCount`，我们可以根据僵尸哪个僵尸赢了战斗来更新它们了。

在第六章我们计算出来一个0到100的随机数。现在让我们用那个数来决定那谁赢了战斗，并以此更新我们的状态。

##### 实战演习

1. 创建一个 `if` 语句来检查 `rand` 是不是 ***小于或者等于\*** `attackVictoryProbability`。

2. 如果以上条件为 `true`， 我们的僵尸就赢了！所以：

   a. 增加 `myZombie` 的 `winCount`。

   b. 增加 `myZombie` 的 `level`。 (升级了啦!!!!!!!)

   c. 增加 `enemyZombie` 的 `lossCount`. (输家!!!!!! 😫 😫 😫)

   d. 运行 `feedAndMultiply` 函数。 在 `zombiefeeding.sol` 里查看调用它的语句。 对于第三个参数 (`_species`)，传入字符串 "zombie". （现在它实际上什么都不做，不过在稍后， 如果我们愿意，可以添加额外的方法，用来制造僵尸变的僵尸）。

``` solidity
function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
  Zombie storage myZombie = zombies[_zombieId];
  Zombie storage enemyZombie = zombies[_targetId];
  uint rand = randMod(100);
  // 在这里开始
  if(rand <= attackVictoryProbability) {
    myZombie.winCount++;
    myZombie.level++;
    enemyZombie.lossCount++;
    feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
  }
}
```

