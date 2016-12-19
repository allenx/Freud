# Generic Typed Genetic Algorithm

> In this project there are two implemetations of GA.

## The Old Genetic Algorithm I Implemented

###### Gene.swift, Genome.swift, Population.swift

> Note that I implemented GA with struct instead of class.

#### Why I Chose Struct Over Class

> What's good about struct?

I always believe that, in most cases, we should use Value-Type over Reference-Type. Here class is the Reference-Type and struct is the Value-Type.

* Reference-Type is unsafe and confusing to new learners in some way.

  ```swift
  class Foo {
    var a: Int = 1
  }
  let fooInstance = Foo()
  let fooInstance1 = fooInstance
  fooInstance1.a = 2
  print(fooInstance.a) // gets 2. This is how reference type works
  ```

  ```swift
  struct Foo {
    var a: Int = 1
  }
  let fooInstance = Foo()
  var fooInstance1 = fooInstance
  fooInstance1.a = 2
  print(fooInstance.a) // gets 1. This is how value type works
  ```

* Struct is way more efficient than class

  Struct instances are allocated on stack while class instances are allocated on heap, which makes struct drastically faster than class in some cases.

  > Quoted from StackOverflow

  According to the very popular WWDC 2015 talk Protocol Oriented Programming in Swift ([video](https://developer.apple.com/videos/wwdc/2015/?id=408), [transcript](http://asciiwwdc.com/2015/sessions/408?q=protocol)), Swift provides a number of features that make structs better than classes in many circumstances.

  Structs are preferable if they are relatively small and copiable because copying is way safer than having multiple reference to the same instance as happens with classes. This is especially important when passing around a variable to many classes and/or in a multithreaded environment. If you can always send a copy of your variable to other places, you never have to worry about that other place changing the value of your variable underneath you.

  With Structs there is no need to worry about memory leaks or multiple threads racing to access/modify a single instance of a variable.

  Classes can also become bloated because a class can only inherit from a single superclass. That encourages us to created huge superclasses that encompass many different abilities that are only loosely related. Using protocols, especially with protocol extensions where you can provide implementations to protocols, allows you to eliminate the need for classes to achieve this sort of behavior.

  The talk lays out these scenarios where classes are preferred:

  > - Copying or comparing instances doesn't make sense (e.g., Window)
  > - Instance lifetime is tied to external effects (e.g., TemporaryFile)
  > - Instances are just "sinks"--write-only conduits to external state (e.g.CGContext)

  It implies that structs should be the default and classes should be a fallback.

  On the other hand, [The Swift Programming Language](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ClassesAndStructures.html#//apple_ref/doc/uid/TP40014097-CH13-XID_108) documentation is somewhat contradictory:

  > Structure instances are always passed by value, and class
  > instances are always passed by reference. This means that they are
  > suited to different kinds of tasks. As you consider the data
  > constructs and functionality that you need for a project, decide
  > whether each data construct should be defined as a class or as a
  > structure.
  >
  > As a general guideline, consider creating a structure when one or more
  > of these conditions apply:
  >
  > - The structure’s primary purpose is to encapsulate a few relatively simple data values.
  > - It is reasonable to expect that the encapsulated values will be copied rather than referenced when you assign or pass around an
  >   instance of that structure.
  > - Any properties stored by the structure are themselves value types, which would also be expected to be copied rather than referenced.
  > - The structure does not need to inherit properties or behavior from another existing type.
  >
  > Examples of good candidates for structures include:
  >
  > - The size of a geometric shape, perhaps encapsulating a width property and a height property, both of type Double.
  > - A way to refer to ranges within a series, perhaps encapsulating a start property and a length property, both of type Int.
  > - A point in a 3D coordinate system, perhaps encapsulating x, y and z properties, each of type Double.
  >
  > In all other cases, define a class, and create instances of that class
  > to be managed and passed by reference. In practice, this means that
  > most custom data constructs should be classes, not structures.

  Here it is claiming that we should default to using classes and use structures only in specific circumstances. Ultimately, you need to understand the real world implication of value types vs. reference types and then you can make an informed decision about when to use structs or classes. Also keep in mind that these concepts are always evolving and The Swift Programming Language documentation was written before the Protocol Oriented Programming talk was given.


#### Struct References:

| Struct       | Description                              |
| ------------ | ---------------------------------------- |
| `Gene`       | Stores DNA sequence which determines what the individual is like |
| `Genome`     | Stores an array of `Gene`s               |
| `Population` | Stores an array of `Genome`s, representing the whole popularity |



For `Gene`:

| Properties & Methods                     | Description                              |
| ---------------------------------------- | ---------------------------------------- |
| `var DNASequence: [Double]`              | DNA Sequence                             |
| `var sequenceLength: Int {get}`          | The length of the `DNASequence`          |
| `let range: (minima: Double, maxima: Double)` | Range of values inside the `DNASequence` |
| ` init?(range: (Double, Double))`        | Initializes a  `Gene?` with a blank `DNASequence` and the `range` passed in. Returns nill if the range is illegal. |
| `init?(length: Int, range: (Double, Double))` | Initializes a `Gene` with randomized DNASequence of the `length` passed in and the range passed in. Returns nill if the range is illegal. |
| `mutating func mutateWith(probability: Double)` | Mutates. Changes some DNAs inside the `DNASequence` |
| `func mateWith(anotherGene: Gene) -> Gene` | Mate with another `Gene` and returns a `childGene` |
| `static func mate(lhs: Gene, rhs: Gene) -> Gene` | static version of `mateWith`             |



For `Genome`:

| Properties & Methods                     | Description                              |
| ---------------------------------------- | ---------------------------------------- |
| ` var genes: [Gene]`                     | An array of `Gene`s it stores            |
| ` var fitness: Double? {get}`            | Fitness of the genes, which determines it's gonna survive or not. |
| `var fitnessFunction: ((_ genome: Genome) -> Double)?` | Calculates the fitness of the its `Gene`s |
| `init(genes: [Gene], fitnessFunction: @escaping ((_ genome: Genome) -> Double))` | Initializes a `Genome` with given `genes` and `fitnessFunction` |
| `init(parentLHS: Genome, parentRHS: Genome, mutationRate: Double)` | Initialize a `Genome` from two parents' mating and self-mutating |
| `mutating func mutateWith(probability: Double)` | Mutates. Changes its `genes`             |



For `Population`:

| Properties & Methods                  | Description                              |
| ------------------------------------- | ---------------------------------------- |
| ` var generation: [Genome]`           | Current generation                       |
| `var mutationRate = 0.01`             | Mutation Rate. 0.01 as Default.          |
| `var sortedGeneration: [Genome]{get}` | sorted generation by the fitness calculated. |
| `init(generation: [Genome])`          | Initializes a `Population` with given `generation` |



## The All-New Generic Typed Genetic Algorithm

###### GeneRD.swift, Chromosome.swift, Crossover.swift, PopulationRD.swift

> RD stands for Redesign, or Redo. Whatever. And it's still under construction

`GeneRD` is a struct which stores a generic typed value, aka, DNA.

`Chromosome` is a struct which stores those generic typed `GeneRD`s and has its own `fitnessFunction`.

`PopulationRD` is a struct which stores those generic typed `Chromosome`s



For `struct GeneRD<T: Hashable>: Hashable`:

| Properties & Methods    | Description                              |
| ----------------------- | ---------------------------------------- |
| `let value: T`          | DNAValue                                 |
| `var hashValue: Int`    | hasValue of `value`                      |
| `public init(value: T)` | Initializes a `GeneRD` with given `value` |



For `struct Chromosome<T: Hashable>`:

| Properties & Methods                     | Description                              |
| ---------------------------------------- | ---------------------------------------- |
| `var genes: [GeneRD<T>]`                 | An array of `GeneRD`s                    |
| `let fitnessFunction: ((_ chromosome: [T]) -> Double)` | Calculates the fitness of the its `GeneRD`s |
| ` var fitness: Double{get}`              | Fitness of the genes, which determines it's gonna survive or not. |
| `init(genes: [GeneRD<T>], fitnessFunction: @escaping (_ chromosome: [T]) -> Double)` | Initializes a `Chromosome` with given `genes` and `fitnessFunction` |



For `struct PopulationRD<T: Hashable>`

| Properties & Methods                 | Description                              |
| ------------------------------------ | ---------------------------------------- |
| `var chromosomes: [Chromosome<T>]`   | An array of `Chromosome`s, representing the current generation |
| `init(chromosomes: [Chromosome<T>])` | Initializes a `PopulationRD` with given `chromosomes` |



For `protocol Crossover`

| Properties & Methods                     | Description                              |
| ---------------------------------------- | ---------------------------------------- |
| ` var crossoverRate: Double {get set}`   | Crossover Rate when mating               |
| ` init(crossoverRate: Double)`           | Initilizes a new Object (whichever conforms this protocol) with given `crossoverRate` |
| `func crossover<T:Hashable>(lhs: [GeneRD<T>], rhs: [GeneRD<T>]) -> (childL: [GeneRD<T>], childR: [GeneRD<T>])` | crossover function during mating         |



## How Do I Use The Algorithm

> There are asexual ga and sexual ga. 
>
> Asexual Production means the algorithm uses no mating. An individual generates a new one only by duplicating itself and mutates a little bit.
>
> Sexual Production means the algorithm uses mating. In mating there are chances of chromosome-crossover and mutation.

If you wanna do Asexual GA, just initialize a population with only one individual. Make it mutate and calculate the fitness and compare it with the the previous one and the better one survives. Doing this kind of loop is going to help you maximize the finess and then you've got the greates kind during the evolution process.

If you wanna do sexual GA, just initialize a population with multiple (numbers may be randomized) individuals. Sort them in the order of their fitness and those with higher fitness has better chances to mate with others and generate new individuals. So you get a new generation of individual by mating the previous sorted individuals and self-mutation, calculate the the total fitness and compare it to the previous generation, and the better one survives. Doing this kind of loop helps you maximize the total fitness of a generation and you've then got the greates kind of generation during the evolution process.

## In Sexual GA, Why Not Just Dump The Lame Ones?

> The fitter an individual is, the better chances the individual has to survive right? So why not just dump those lame ones coz their genes are not fit?

We're not dumping the lame ones. Instead, we're still giving the lame ones chances to mate with others, their chances being smaller though.

Here's why:

### Principle of Variation

Once the fitness has been calculated for all members of the population, we can then select which members are fit to become parents and place them in a mating pool. There are several different approaches we could take here. For example, we could employ what is known as the **elitist** method and say, “Which two members of the population scored the highest? You two will make all the children for the next generation.” This is probably one of the easier methods to program; however, it flies in the face of the principle of variation. If two members of the population (out of perhaps thousands) are the only ones available to reproduce, the next generation will have little variety and this may stunt the evolutionary process. We could instead make a mating pool out of a larger number—for example, the top 50% of the population, 500 out of 1,000. This is also just as easy to program, but it will not produce optimal results. In this case, the high-scoring top elements would have the same chance of being selected as a parent as the ones toward the middle. And why should element number 500 have a solid shot of reproducing, while element number 501 has no shot?

For example, in the case of evolving "to be or not to be", we might have the following elements:

**A: to be or not to go**

**B: to be or not to pi**

**C: xxxxxxxxxxxxxbe**

As you can see, elements A and B are clearly the most fit and would have the highest score. But neither contains the correct characters for the end of the phrase. Element C, even though it would receive a very low score, happens to have the genetic data for the end of the phrase. And so while we would want A and B to be picked to generate the majority of the next generation, we would still want C to have a small chance to participate in the reproductive process.






