#### 黑盒测试、灰盒测试和白盒测试的区别
<br>
首先要清楚整个测试的流程包括单元测试、集成测试和系统测试<br>

- 黑盒测试：只关心**输入和输出**，只要输出结果是对的，那么就认为该程序的功能是正确的。对应测试流程中的系统测试；

- 白盒测试：不仅仅关注输入和输出的结果是否正确，同时还关注程序是如何处理的。对应测试流程中的单元测试；

- 灰盒测试：灰盒测试关注输出对于输入的正确性，同时也关注内部表现，但这种关注不象白盒那样详细、完整，只是通过一些表征性的现象、事件、标志来判断内部的运行状态，有时候输出是正确的，但内部其实已经错误了。如果测试完单个模块后没有发生问题，但是并不代表这些模块组合在一起就一定没有问题，所以要验证这些功能模块组合在一起有没有问题，这就是测试流程中的集成测试，使用方法就是灰盒测试。灰盒测试是将一个单元看作黑盒，对于单元内部的细节并不清楚，这与白盒测试相区分开来

# Paper

### 第一篇：《Fuzzing: Hack, Art, and Science》(Review)

  主要讲述的是模糊测试的发展和技术，其中fuzzing包括：
  
- <font color = "navy">黑盒模糊测试：</font>fuzzing第一种形式，并且也是最简单的一种，就是进行任意变异，然后再将这些编译的种子进行输入，而黑盒测试的效率就是依赖于开始时该模糊测试过程的**各种形式多样的种子输入**，所以对于黑盒测试，种子的选择显得就有关重要了。
  
- <font color = "navy">基于语法的模糊测试：</font>虽然黑盒测试提供了一个较为简单的测试标准，但是它的效率被限制了：也就是产生新的感兴趣的种子太慢了。基于语法的测试对于复杂的格式来说是一个很好的选择。
  
- <font color = "navy">白盒模糊测试：</font>白盒模糊测试是由动态测试下的符号性执行程序组成，从执行过程中遇到的条件分支收集对输入的约束，然后将收集到的约束一一系统地求反，并使用约束求解器进行求解，约束求解器得到的结果与新的输入相匹配，能够执行不同程序的执行路径，
分，如下方的示例代码：

```C 
int foo (int x) { // x is an input
    int y = x + 3;
    if (y == 13) abort (); // error
    return 0;
}
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如果首次的输入为0，则第一次不会触发error，但是在对该种子进行约束后，约束解决器会产生一个新的input10，将该值作为种子再运行该程序，则会触发error。这就是和黑盒模糊测试的区别，可以直观地解释白盒模糊测试经常会提供高代码覆盖率。
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;白盒模糊测试要比其他方法更加精确，可以找到其他模糊测试方法错过的bugs，甚至不清楚输入格式的相关知识点。对于程序员可能没有发现的分配内存或者对缓冲区的操作，从导致的危害漏洞，白盒模糊测试也可以自动发现和测试这些漏洞。
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;白盒模糊测试也有一些问题，比如由于符号执行对种子的约束行为会造成输入的精度丢失，由于这些限制白盒模糊测试在实践中仍然要依靠各种各样的种子投入才能有效，类似于黑盒模糊测试。
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;白盒模糊测试最初是在工具SAGE中实现的，它扩展了动态测试生成先前的工作范围，从单元测试到大型程序的安全性测试，也称为执行生成测试或condicolic测试。为了在大型软件中更好的进行fuzzing，SAGE在代码覆盖率的问题上使用了基于启发式的搜索。

- <font color = "navy">灰盒模糊测试：</font>AFL是一个很受欢迎的开源的fuzzer，它是扩展了在SAGE中所使用的基于代码覆盖启发式搜索的随机模糊测试，但是没有添加任何的符号执行约束策略。另外一种灰盒测试的形式是基于污点的模糊测试，通过输入污点分析可以影响应用程序的控制流，这些字节可以被任意随机fuzz。

- <font color = "navy">混合模糊测试：</font>将黑盒或者灰盒模糊测试技术与白盒模糊测试技术结合起来，目的是探索折衷方案，以确定何时何地使用简单的技术足以获得良好的代码覆盖率。基于语法的模糊测试也可以白盒子模糊测试相结合。


<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Conclude**：Is fuzzing a hack, an art, or a science?
- 黑盒子模糊测试是一个简单的“`Hack`”，但是它可以有效地找到应用程序中那些从来没有被fuzz过的bug；

- 基于语法的模糊测试通过允许用户的创造力和专长去知道fuzz，从而回到了上述问题的`art`；

- 白盒子模糊测试可利用计算机科学（`science`）研究在程序验证方面的先进成果，并探索如何以及何时以一种证明论的意义在数学上“模糊并完善”模糊测试；


```
The effectiveness of these three main fuzzing techniques depends on the type of application being fuzzed. For binary input formats
 (like JPEG or PNG), fully-automatic blackbox and whitebox fuzzing techniques work well, provided a diverse set of seed inputs is 
available. For complex structured non-binary formats (like JavaScript or C), the effectiveness of blackbox and whitebox fuzzing is
 unfortunately limited, and grammarbased fuzzing with manually-written grammars are usually the most effective approach. 
For specific classes of structured input formats like XML or JSON dialects, domain-specific fuzzers for XML or JSON can also be used: 
these fuzzers parse the high-level tree structure of an input and include custom fuzzing rules (like reordering child nodes, 
increasing their number, inversing parent-child relationships, and so on) that will challenge the application logic while still 
generating syntactically correct XML or JSON data. Of course, it is worth emphasizing that no fuzzing technique is guaranteed to 
find all bugs in practice.

Despite significant progress in the art and science of fuzzing over the last two decades, important challenges remain open. 
How to engineer exhaustive symbolic testing (that is, a form of verification) in a cost-effective manner is still an open problem 
for large applications. How to automate the generation of input grammars for complex formats, perhaps using machine learning, is 
another challenge. Finally, how to effectively fuzz large distributed applications like entire cloud services is yet another open 
challenge.
```
<hr>

### 第二篇：《LearnAFL: Greybox Fuzzing With Knowledge Enhancement》
> ACCESS.2019.2936235

Key Words：学习输入的格式， 深度fuzz， 灰盒测试， 漏洞挖掘

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文讲述了黑盒模糊测试、灰盒模糊测试和白盒模糊测试，且主要是讲解了灰盒模糊测试的相关问题，目前灰盒模糊测试经常和机器学习、符号执行、动态污点分析和静态分析结合起来，这成为了研究的热点。
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;在任意变异策略中，AFL可能会损坏种子的格式或者只是变异种子的关键部分，该部分是满足执行该路径的条件。结果产生的很多测试用例会执行该高频路径，只有很少的测试用例（突变后的种子）执行低频率的路径，然后这些执行低频率路径的种子才是更感兴趣的，这就是种子的突变策略。但是一些实验结果却表现：在AFL中，确定性突变的效率要比任意变异的低；确定性变异使用的能量要比任意变异策略中使用的更多，会减少AFL的效率。由此提出了一个任意突变策略种子的fuzzer：LearnAFL。
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LearnAFL可以学习种子文件的格式，并且在任意突变中通过基于格式路径转换模型保持种子的属性不发生改变，也就是说LearnAFL可以辨别输入的一部分，关键是可以满足路径约束。LearnAFL是基于种子执行的路径，然后标识不同的集合。总的来说，该paper的主要贡献有：
- 基于等价类的格式生成理论

- 基于格式的路径转换模型

- 魔术字节生成算法的增强表达

- 工具和环境

<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;该paper中详细介绍了种子的变异策略：确定性变异策略和任意变异策略。其中确定性变异策略包括：**bitflip（比特翻转）, arithmetic, interest, dictionary**，这种突变不带随机性；另外一种就是任意变异策略，包括**havoc（破坏）和splice（拼接）**。在havoc阶段，AFL从确定性变异策略中任意选择一个变异操作符的序列，把这个序列运用到种子文件中的任意位置之中，这样就会产生新的测试用例。最后一个阶段是拼接策略，该策略允许AFL从种子序列Q中任意选择一个种子，并且将其和当前的种子进行拼接。

<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**映射理论模型**：作者将种子和执行的路径看作一个映射，也可以说是一个函数，F: T → P，如果s<sub>i</sub>执行的路径是M中的j，可以这样表示：F(s<sub>i</sub>) = j，这样就可以得到输入和执行程序的路径的关系：
- |T| > |M|：那么F是一个surjection，不是双射

<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**基于等价类的格式生成理论**：为了得到一个双射，通过种子执行的路径，将 T 划分为一些等价类的 T<sub>i</sub>，T<sub>i</sub> = {s<sub>ij</sub> | F(s<sub>ij</sub>) = i}，因此可以得到一个双满射：F': T' → P，T' = {T<sub>1</sub>,T<sub>2</sub>,T<sub>3</sub>,……,T<sub>N-1</sub>,T<sub>N</sub>}。

<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AFLFast提出了基于突变的模糊转移概率（*transition probability*），以马尔科夫链为模型。

<hr>

### 第三篇：《猫群算法及其改进算法研究》
> 兰州大学 硕士论文

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;CSO 与其他 EC 和 SI 算法相似，也是经过个体之间的合作，实现对优化问题的最优解的搜索。CSO 中，个体猫为待求解的问题的可行解。CSO 将猫群行 为模式分为两种；跟踪模式和搜寻模式。

<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;CSO 的进化行为与传统的SI算法不同，CSO 并不通过选取适应度高的部分个体产生下一代，以提高每一代解的整体质量。它是通过不断迭代过程和在每次迭代中对猫群的重新分配模式来不断地寻找当前最优解。因结合率为一个较小的值，所以大部分的猫的状态处于搜寻模式。

- 搜索模式下（局部搜索），猫复制自身位置，对自身位置的每一个副本改变一定的范围來产生新的位置，并将其结果放在记忆池中，对适应度值进行计算比较，根据适应度值，在记忆池中—定以的概率选择一个位置作为猫要移动的下一个位置点；

- 跟踪模式下（全局搜索），猫个体改变个体速度来更新其位置，增加一个随机地扰动来实现速度的改变。

<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当所有猫进行完搜索模式和跟踪模式后，根据适应度函数计算它们的适应度并保存群体中的最优值。`（什么值是最优的？）`最后再根据结合率随机将猫群分为搜索部分和跟踪部分，再次进行迭代寻优，直到结果符合精度要求或者达到迭代次数最大值。`(精度怎么设定？最大值怎么设定？)`

<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**猫群算法的思想：**在初始化时将猫群置为随机的一组解，然后通过不断地迭代过程找到最优解，这个过程为：首先根据MR值（跟踪模式/整个猫群）对猫群进行分组，在每一次迭代中，**每只猫对跟踪速度和位置两个极值进行更新，**同时也实现猫群之间的信息交换，通过对问题表达出的**适应度函数**来计算每一只猫的<font color = "red">**适应度值**</font>从而寻找问题的最优解。 `(怎么根据结合率分成搜索模式和跟踪模式  )`

```
问题:
1.对于局部搜索模式，也就是搜索状态的猫来说，位置的好坏对局部最优解的有什么联系？
2.对于全局搜索模式，也就是跟踪状态下的猫来说，速度和位置对全局的最优解有什么联系？

CSO的缺点：
1.算法在迭代初期有较快的收敛速度，但随着迭代次数的增加，固定数量的猫进行全局探索使得算法解的精度不佳 => 需要对MR进行改进；
```

- **搜索模式关键参数**：
  - 记忆池（SMP）：规定了每一只猫搜索记忆的大小，决定了每只猫副本猫的数量C<sub>p</sub>
  - 搜索维数范围（SRD）：表示猫每一维位置的改变范围；
  - 维数改变量（CDC）：一只猫将要发生变异的维数的个数；
  - 自身位置判断（SPC）：表示猫是否将当前位置作为将要移动的侯选位置之一；


<hr>

### 第四篇：《基于改进猫群算法的物联网感知层路由优化策略》
> 计算机工程 

1. 传感器节点 作为物联网感知层的基础单元，承担着重要的信息 采集任务，但是节点一般都只有有限的能量。为了能及时可靠地获得感知数据降低损失并延长网络的生命周期，对物联网中传感器节点能耗及感知层能量均匀合理使用提出了更高的要求。
> 种子作为AFL中的重要组成部分，负责找出新的漏洞路径，但是种子的能量一般是有限的。为了能够更多的发现漏洞路径，并增加种子突变的质量，对种子的能量消耗提出了更高的需求。

2. 猫群优化算法是一种新型的仿生类进化算法，CSO 算法在寻优过程中采用局部搜索和全局探测同时协作进行，具有参数少、收敛速度快的优点，很好地克服了遗传算法局部搜索能力不足和粒子群算法易陷入局部最优的不足。

```
问题：
1.猫的维度位置在AFL如何表示？
2.猫的适应度用AFL的什么来衡量？

```


### 第五篇：《EcoFuzz: Adaptive Energy-Saving Greybox Fuzzing as a Variant of the Adversarial Multi-Armed Bandit》
> 

`阅读源码`
```C
 while(q){
    if(!q->was_fuzzed && queue_cur->was_fuzzed){
      queue_cur = q;
      current_entry = i;
      break;
    }
    q = q->next;
    i++;
}
```
当队列中还没有被fuzz的种子，而且当前队列中是被fuzz的，则将没有被fuzz的赋值给当前的队列；否则执行下一个队列

```C
while(q) {
    if(!q->was_fuzzed){
     state_of_fuzz = 1;
     return;
    }
    q = q->next;
}
state_of_fuzz = 2;
```
当队列中还存在没有被fuzz的（白），状态设置为`1`，并退出程序；如果队列中全部都是被fuzz的（黑），状态设置为`2`

#### 1.模糊测试工具的发展

1. CGF获取检测工具生成的路径覆盖率，并根据`路径覆盖率`选择好的种子，这样可以提升路径覆盖率和漏洞挖掘率；
2. AFL对文件程序的模糊测试是一个好的方法，但是用来被测试真实的程序时，出现了很多不足，最主要的挑战是：大多数测试用例都沿相同的几个路径运行，从而导致`大量能量浪费在高频路径上`。特别是在模糊测试后期，AFL中运行在高频路径上的种子在挖掘新漏洞方面不会再有很大的帮助；
3. AFL的调度算法不是建立在科学的理论模型上；
