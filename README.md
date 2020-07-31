#### 黑盒测试、灰盒测试和白盒测试的区别
<br>
首先要清楚整个测试的流程包括单元测试、集成测试和系统测试<br>

- 黑盒测试：只关心**输入和输出**，只要输出结果是对的，那么就认为该程序的功能是正确的。对应测试流程中的系统测试；

- 白盒测试：不仅仅关注输入和输出的结果是否正确，同时还关注程序是如何处理的。对应测试流程中的单元测试；

- 灰盒测试：灰盒测试关注输出对于输入的正确性，同时也关注内部表现，但这种关注不象白盒那样详细、完整，只是通过一些表征性的现象、事件、标志来判断内部的运行状态，有时候输出是正确的，但内部其实已经错误了。如果测试完单个模块后没有发生问题，但是并不代表这些模块组合在一起就一定没有问题，所以要验证这些功能模块组合在一起有没有问题，这就是测试流程中的集成测试，使用方法就是灰盒测试。灰盒测试是将一个单元看作黑盒，对于单元内部的细节并不清楚，这与白盒测试相区分开来

#### 马尔科夫链

> 马尔可夫链（英语：Markov chain），又称离散时间马可夫链（discrete-time Markov chain，缩写为DTMC[1]），因俄国数学家安德烈·马尔可夫得名，为状态空间中经过从一个状态到另一个状态的转换的随机过程。该过程要求具备“无记忆”的性质：下一状态的概率分布只能由当前状态决定，在时间序列中它前面的事件均与之无关。这种特定类型的“无记忆性”称作马可夫性质。马尔科夫链作为实际过程的统计模型具有许多应用。
> 在马尔可夫链的每一步，系统根据概率分布，可以从一个状态变到另一个状态，也可以保持当前状态。状态的改变叫做转移，与不同的状态改变相关的概率叫做转移概率。随机漫步就是马尔可夫链的例子。随机漫步中每一步的状态是在图形中的点，每一步可以移动到任何一个相邻的点，在这里移动到每一个点的概率都是相同的（无论之前漫步路径是如何的）。

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

`CGF`
1. CGF获取检测工具生成的路径覆盖率，并根据`路径覆盖率`选择好的种子，这样可以提升路径覆盖率和漏洞挖掘率；
2. CGF是以马尔科夫链为模型，将模型中的`状态空间`定义为`发现的路径`和`未发现的路径`；
3. 在真实世界中，不可能精确的计算发现新路径的transition probability，所以

`AFL`
1. AFL是CGF的……
2. AFL对文件程序的模糊测试是一个好的方法，但是用来被测试真实的程序时，出现了很多不足，最主要的挑战是：大多数测试用例都沿相同的几个路径运行，从而导致`大量能量浪费在高频路径上`。特别是在模糊测试后期，AFL中运行在高频路径上的种子在挖掘新漏洞方面不会再有很大的帮助；
3. AFL的调度算法不是建立在科学的理论模型上，其中AFLFast用变异种子的`过渡概率建模`来产生执行其他路径的种子。虽然AFLFast可以用更少的能量需求发现新的漏洞，但是不能更具测试进程进行复杂的调整能量的分配策略，因此增加了发现新漏洞的平均能量的消耗;
4. AFL根据种子的`执行时间`和`长度`来计算favorite因素，来设定某个种子是favorite的；
5. AFL有两个种子突变策略：确定性和非确定性：
  - 确定性策略对输出的每一位/字节进行操作，只是在第一次运行该种子时，使用该策略。在确定性策略中，AFL会根据种子的`长度`来分配其能量
  - 非确定性策略包括：havoc和splice两个阶段。在该策略中，AFL会任意选择一个突变操作的序列，然后将该操作在种子文件中的随机位置实现达到突变种子的目的
6. AFL根据其得分为种子分配能量，该得分基于覆盖率（优先考虑覆盖更多程序的输入）、执行时间（优先考虑执行速度更快的输入）和发现时间（优先考虑以后发现的输入）。如果发现新的路径，AFL会给该种子分配双倍的能量；
7. AFL以QEMU模式支持给二进制文件进行插桩；
8. AFL不能动态的调整它的能量分配，虽然AFL有一个简单的搜索策略，但是这种策略是无效的，导致AFL轮流选择有价值的种子；
9. AFL中随着不断地运行，发现新的路径的概率越来越小；
10. AFL中的种子能量分配是以边的覆盖和执行时间为依据的，而AFLFast将覆盖低频路径的种子视为好种子

#### 2.本篇论文

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文中提出了一个Adversarial MultiArmed Bandit模型，在该模型中将种子看作为`Bandit`，也就是匪徒。Multi-Armed Bandits问题：
- 在该模型中，玩家玩众多臂膀的其中一个，以获得奖励。玩家的主要目标是在最后的尝试中使得奖励最大化
- 该模型中分为`Exploitation`和`Exploration`阶段（ps：可以和猫群相对应着分析）
- 在MAB模型中，将`arm`视为种子，然而在fuzz期间种子的数量是增加的，发现新路径的概率是减少的；
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;由于MAB的缺陷，本文是在Auer et al.等人提出的MAB变体问题：Adversarial Multi-Armed Bandit (AMAB)。本文中将`种子搜索`和`分配能量`的过程建模为AMAB问题的变体，在该模型中做出了两个假设：

1. 程序A的被执行路径和crashes是有限的，标记为n<sub>p</sub>，n<ssub>c</sub>；

2. 程序A是无状态的，每个执行的路径只依赖于fuzzer产生的输入 ===>  确保在VAMAB模型中，给予奖励的概率是独立的

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文中还给出了以下几个重要的定义：

1. 程序A的路径集合被标记为 S = {1,2,...,n<sub>p</sub>}，对应的种子被标记为 T = {t<sub>1</sub>,t<sub>2</sub>,...,t<sub>np</sub>}
2. p<sub>ij</sub> 是种子t<sub>i</sub>执行路径j时产生测试用例的概率（transition probability）E[X<sub>ij</sub>] 是最小能量的expectation
3. 我们定义了 f<sub>ij</sub> = f<sub>i</sub>(j) / s(i) 为路径 i 到 j 的频率 f<sub>i</sub>(j) 表明种子t<sub>i</sub>执行路径 j 产生的测试用例的数量
4. T<sub>n</sub>是种子队列，其中T<sub>n</sub><sup>+</sup>表示的是已经被fuzz的，T<sub>n</sub><sup>-</sup>表示其他的seed

<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color = "red">本文中的模型将`种子`视为`臂膀`，目标是为了在有限的实验中获取最大路径！</font>将每次试验的奖励定义为生成触发新路径的输入。在VAMAB模型中，臂膀的数量将会增加，如果直到程序A的所有路径被找到，那么得到奖励的概率将会减少。因此在发现所有路径之前，在勘探exploration（未被fuzz的测试种子）和开发exploitation（选择已经被fuzz的种子以获得更多奖励）之间总是要权衡取舍。

`Exploration vs Exploitation in VAMAB Model`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;VAMAB中的探索模式和开发模式的切换：

1. **初始化状态**：也就是所有的种子都未被fuzz
2. **探索状态**：这时队列中有一部分是被fuzz的，也有一部分是没有被fuzz的，所以这时的能量应该分配给未被fuzz的（可能是因为白色的要比黑色的好）
3. **开发状态**：当所有的种子都被fuzz完后，也就是全部为白色，这时的状态变为开发状态。关键是选择高获奖概率的种子进行测试以获取新的路径，一但有未发现的新路径，这个状态就会从exploration变为exploitation，如此循环下去，直到找完全部的路径



`Challenges in VAMAB Model`

**第一个挑战**：对于 exploitation 阶段，如何确定每个种子的reward概率去选择下一个种子？本文只能估算该值，可以通过transition的频率来估算transition概率，这种方法对发现其他标准和参数；

**第二个挑战**：对每个“臂膀”如何分配合适的能量，去均衡在exploration和exploitation之间的交易；

为了使得路径覆盖率最大化，需要建立一个有效的机制：在exploitation阶段，使用现有的信息去评估每个中的回报的概率，给种子分配合适的能量减少能量的浪费。



`Implementation`

EcoFuzz的运行是没有确定策略，是因为本文的scheduling算法淘汰了该机制：当新路径被发现时，

**Exploration State**：EcoFuzz selects the next seed based on the index order of the seeds which are not fuzzed, without skipping the seeds that are not preferred, and assigns energy by AAPS.

**Exploitation State**：EcoFuzz implements SPEM for estimating the reward probability of all seeds and prioritizes the seeds with high reward probability for testing

`伪代码：`

```c
Require: Initial Seeds Set S
	total_fuzz = 0												// 一共被fuzz的种子数目
	rate = 1													// 速度默认为 1
	Q = S														// 将种子集放入队列中
	repeat
		queued_path = |Q|										// |Q|为队列的路径
		average_cost = CalculateCost(total_fuzz, queued_path)	// 计算队列中种子平均消耗的能量，平均 = 总共被fuzz的/队列中的路径？
		state = StateDetermine(Q)
		if state == Exploitation then							// 状态处于勘探时执行if分支，也就是当种子全被fuzz时，选择种子的策略为SPEM算法
			s = ChooseNextBySPEM(Q)								
		else
			s = ChooseNext(Q)									// 处于开发状态时，也就是队列中还有没被fuzz的种子时，只需要根据index选择种子
		end if
		Energy = AssignEnergy(s, state, rate, average_cost)		// 根据“种子”、“状态”、“速度”和“平均的消耗因素”进行分配能量
		for i from 1 to Energy do								// i 代表的是能量，本循环代表的是种子 s 被执行的次数
            t = Mutate(s, Indeterministic)						// 用非确定性策略对种子s进行突变
            total_fuzz += 1										// fuzz一次就加 1
            res = Execute(t)									// 开始用突变的种子执行文件
            if res == CRASH or IsInteresting(res) then			// 如果有碰撞或者是喜欢的种子，就执行if分支
                regret = i / Energy									/* 该能量除以总的能量 */
                s.last_found += 1									/* 对喜爱的种子或者产生碰撞的种子进行计数 */
                if IsInteresting(res) then							// 如果是喜爱的种子，就添加到队列中
                    add t to Q										
                else
                    add t to T_c									// 否则添加到T_c中
                end if
            end if
		end for
		rate = UpdateRate(regret, rate)
		s.last_energy = Energy
	until timeout reached or abort-signal
Ensure: T_c
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;由于MAB的缺陷，本文是在Auer et al.等人提出的MAB变体问题：Adversarial Multi-Armed Bandit (AMAB)



### 第六篇：《基于多目标优化的测试用例优先级排序方法》

> 夏春艳,王兴亚,张岩.基于多目标优化的测试用例优先级排序方法[J].计算机科学,2020,47(06):38-43.

`测试用例优化技术`：

> - 测试用例集约简，TSM
>
> - 测试用例选择，TCS
>
> - 测试用例优先级排序，TCP
>
>   - 以覆盖率为目标
>
>   - 基于检错率为目标
>
>   - 基于测试用例执行时间
>
>   - 依据测试用例对需求的满足情况
>
>     上述都是单目标优化为主

`多目标测试用例优先级`

> MOTCP是指按照多个测试目标找到一个符合测试需求的测试用例序列，提高测试套件在软件测试过程中的故障检测率，从而达到成本与效益需求相平衡的目的，基已被证明是NP-hard问题
>
> - 已有的MOTCP研究主要集中在加权法，缺点是权值分配受人的主观影响较大，她所考虑的目标有：错误检测率、需求覆盖率、软件复杂性和历史信息等16个优化目标
> - Rajendrani研究表明，多目标优化问题重要的度量指标为：
>   - 错误覆盖率
>   - 语句覆盖率
>   - 有效执行时间

基于以上，本文提出的是<font color = "red">一种基于多目标优化的测试用例优先级排序方法</font>，该方法基于Pareto最优的非支配排序遗传算法（NSGA2）为基础，引入选择函数评价个体。

`什么是选择函数?`

选择函数(ChoiceFunction,CF)是采用自适应方式来评定个体质量的一种排序方法。

`多目标进化算法的优化过程`

多目标进化优化算法的优化过程是针对每一代进化群体寻找当前最优解，称当前进化群体的最优解为非支配解，所有非支配解的集合称为当前进化群体的非支配集，优化的目的是使非支配集不断逼近真正的最优解

`测试用例优先级排序`



### 第七篇：《Cerebro: Context-Aware Adaptive Fuzzing for Effective Vulnerability Detection》

> Yuekang Li, Yinxing Xue, Hongxu Chen, Xiuheng Wu, Cen Zhang, Xiaofei Xie, Haijun Wang, and Yang Liu. 2019. Cerebro: Context-Aware Adaptive Fuzzing for Effective Vulnerability Detection. In Proceedings of the 27th ACM Joint European Software Engineering Conference and Symposium on the Foundations of Software Engineering (ESEC/FSE ’19), August 26–30, 2019, Tallinn, Estonia. ACM, New York, NY, USA, 12 pages.

`本文的贡献`

- 标准化了一个新的概念：输入潜力。它代表了未被覆盖代码的复杂度；同时还提出了一个我们还提出了一种经济高效的算法，可以快速计算“输入潜力”，以方便能量的分配；
- 本文提出了一个基于多目标的模型以及用于种子优先级排序的高效排序算法；
- 实现了 CEREBRO 并对其性能进行了评估

`非支配排序算法`

影响多目标排序的指标有：文件大小、执行时间、覆盖边的数量、是否产生新的路径覆盖以及执行跟踪的静态复杂度得分

- 文件大小：较小的种子更紧凑 - 对它们的突变更可能命中有趣的字节
- 运行时间：较短运行时间的种子会增加PUT的平均速度
- 覆盖边的数量：高覆盖率的种子是更喜爱的