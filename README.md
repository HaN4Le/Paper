# Paper
#### 第一篇：《Fuzzing: Hack, Art, and Science》(Review)

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

#### 第二篇：《LearnAFL: Greybox Fuzzing With Knowledge Enhancement》
> ACCESS.2019.2936235
