# Freud

>The ego attempts to mediate between id and reality.

Freud is a Swift machine-learning library dedicated to [Sigmund Freud](https://en.wikipedia.org/wiki/Sigmund_Freud). This Library is implemented under the 'Ego' philosophy.

## Features

Freud is based on the project [Swift AI](https://github.com/collinhundley/Swift-AI/blob/master/README.md) by Collin Hundley. It includes a set of common tools used for machine learning and artificial intelligence research. These tools are designed to be flexible, powerful and suitable for a wide range of applications.

- [x] [Feed-Forward Neural Network](https://github.com/collinhundley/Swift-AI/blob/master/Documentation/FFNN.md#multi-layer-feed-forward-neural-network)
      * 3-layer network with options for customization.
      * [Example projects](https://github.com/collinhundley/Swift-AI/tree/master/Examples#swift-ai-examples) for iOS and OS X.
- [ ] Recurrent Neural Network
- [ ] Convolutional Network
- [ ] GPU-Accelerated Networks
- [x] Genetic Algorithms
      * Generic Typed Genetic Algorithm (Undergoing)
      * Asexual & Sexual Production
      * [Example Project]() for iOS
- [x] [Fast Matrix Library](https://github.com/collinhundley/Swift-AI/blob/master/Documentation/Matrix.md#matrix)
      * Matrix class supporting common operators
      * SIMD-accelerated operations
- [ ] Fourier Transform Functions

## Installation & Environment Requirement

> Xcode 8, Swift 3, macOS

Just grab the source files you need and drag them into your project directory.

> Can I compile it on Xcode 7 or AppCode?

On AppCode, yes, as long as your system's Xcode toolchain supports Swift 3.

On Xcode 7?

![GoHomeYou'reDrunk](http://ogbzxx07e.bkt.clouddn.com/GoHome.png)

Xcode 7 only supports Swift 2.2, which is completely different from Swift 3, thanks to Apple.

> Can I compile it on Ubuntu and other Linux distributions? I heard Swift is open source and Apple has made it available on Ubuntu.

Part of this library, yes. For example the Genetic Algorithm (needs some compatibility work though). But Neural Network (FFNN) and Fast Matrix Library won't run on Linux. Because they heavily depends on Apple's [Accelerate Framework](https://developer.apple.com/reference/accelerate) which supports High-Performance Vector Operations.

## Why I Didn't Just Fork Swift-AI Since Freud Is Based On It

Because Swift-AI is right now in Swift 2.2 and it's gonna be a tough job to convert it to Swift 3. So I thought, why don't I just rewrite it? 

Then there came Freud.

## What It's For

> The following is quoted from Collin Hundley

> "This is a really *cool* project, but what can I actually do with it? I know nothing about A.I."

I get this question a lot, so I want to address it here:

Freud focuses on a useful branch of artificial intelligence known as *machine learning*: the science of training computers to take actions without explicit programming. Used appropriately, these tools can give your applications abilities that would normally be impossible or *unrealistic* using conventional programming techniques.

As an example, consider an app that recognizes handwritten letters on a piece of paper: using the computer science you learned in school, you might be tempted to write each of the rules for classifying each character individually. This would consist of extracting pixel data from the image, reading them in individually, and writing an *extremely* complicated mathematical model that relates pixel darkness/position into a probability for the letter `A`, and then likewise for `B`, `C`, `D`, etc. Sound fun? Here's what your program might eventually look like:

```swift
if /* massive function for checking the letter A */ {
    return "A"
} else if /* massive, completely unique function for checking the letter B */ { 
    return "B"
} else if ...
```

Hopefully you've realized by now that this method simply isn't feasible. In the best case scenario, you might end up with thousands of lines of very unreliable code for recognizing only *your* exact handwriting. In comparison, Swift AI's [iOS example app](https://github.com/collinhundley/Swift-AI/tree/master/Examples#ios) demonstrates how far superior functionality can be accomplished with very few lines of code, using machine learning. And requiring exactly *zero* explicit rules to be written by the developer.

>**So how can Freud be used in the real world?**

Here are a few ideas to get you started:
- Handwriting recognition
- Gesture recognition
- Facial detection
- Drone stabilization and navigation systems
- Predicting and identifying medical conditions
- Song identification (e.g., Shazam)
- Speech recognition
- Video game AI
- Weather forecasting
- Fraud detection
- [Building smart robots!](https://www.youtube.com/watch?v=99DOwLcbKl8)

## Examples

> How can I play with it?

For FFNN Demos, go checkout [Swift AI](https://github.com/collinhundley/Swift-AI/tree/master/Examples/iOS) which is implemented in Swift 2.2 and should be compiled using Xcode 7.

For Genetic Algorithm, inspired by the original idea of [Roger Johansson](https://rogerjohansson.blog/2008/12/07/genetic-programming-evolution-of-mona-lisa/), I've created a fun demo in iOS.

* Approximating images with a bunch of self-evolutionable polygons. (Some work are still undergoing)

## Using Freud?

If you're using Freud, feel free to let me know and I can put a link of your fabulous project down here.

## Contributing

Feel free to fork and submit pull requests. I love that people from all over the world is making a difference together, even though we don't know each other.

And also, you can contribute to the original project [Swift AI](https://github.com/collinhundley/Swift-AI/tree/master/Examples/iOS), Mr. Collin Hundley has done a tremendous job and I would probably submit pull request to the original project.

## Contact

You can call me Allen. I'm a university students from China and I love playing with computers.

[allenx@live.fr](mailto:allenx@live.fr)

And my blog is [Re: time](allenxa.com)

