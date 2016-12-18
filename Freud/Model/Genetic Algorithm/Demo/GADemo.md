# Evolution of Mona Lisa

![MonaLisa](http://ogbzxx07e.bkt.clouddn.com/MonaLisa)

### Installation & Requirement

> Xcode 8, Swift 3, CocoaPods 1.1.0 or later

In order to compile and run the demo app, you need Xcode 8.

Run `pod install` first to install `SnapKit` which is an awesome library that encapuslates AutoLayout perfectly.

### What It's About

The demo app uses Genetic Algorithm to help a bunch of polygons to evolve to the target image, Mona Lisa here.

### Play with It

> Factors.swift

The demo app has a file named Factors.swift which stores all the mutation rates and other parameters to help polygons evolve. You can change it and see how it goes.

I'll ommit other files and classes because they're pretty simple.

### How I Calculate The Fitness of Each Generation

> 2 naïve approaches

```swift
var error: Int = 0
let deltaR = Int(pixel.r) - Int(sourcePixel.r)
let deltaG = Int(currentPixel.g) - Int(sourcePixel.g)
let deltaB = Int(currentPixel.b) - Int(sourcePixel.b)

let delta = deltaR*deltaR + deltaG*deltaG + deltaB*deltaB
error += delta
```

###### 1  Snapshot current view and get pixels from it and calculates the error like above. 

This one is super naïve though very accurate. It's gonna take a whole lot of time because UIView rendering is extremely slow, I mean, compared with the data calculating. This method slows down the generation flushing and is not feasible.

###### 2  Get sample points (randomized coordinates) from the polygon array and calculates the error like above, points lesser, and it's UI-Independent.

How do I get a point's colour if I didn't render it on UIView? I have this algorithm 'invented':

First you gotta tell if this point is inside a polygon

```swift
extension PointGene {
    func isInPolygon(polygon: PolygonGene) -> Bool {
        var n = polygon.numberOfPoints - 1
        var res = false
        for i in 0..<n+1 {
            if (polygon.points[i].y < self.y && polygon.points[n].y >= self.y) || (polygon.points[n].y < self.y && polygon.points[i].y >= self.y) {
                if Double(polygon.points[i].x) + (Double(self.y-polygon.points[i].y))/Double(polygon.points[n].y-polygon.points[i].y)*Double(polygon.points[n].x-polygon.points[i].x) < Double(self.x) {
                    res = !res
                }
            }
            n = i
        }
        return res
    }
}
```

If the point is inside a polygon then the point gets the polygon's color. If not, it gets black colour (the background).

What if the point is inside multiple polygons that overlaps with each others? I've got this RGBA mixing algorithm again, though it may not work very well.

```swift
extension ColourGene {
    func newColourBlended(anotherColour: ColourGene) -> ColourGene {
        if self.R == 0 && self.G == 0 && self.B == 0 && self.A == 255 {
            return anotherColour
        }
        
        let R = Int(Double(self.R * self.A + anotherColour.R * (255 - self.A)) / 65025.0)
        let G = Int(Double(self.G * self.A + anotherColour.G * (255 - self.A)) / 65025.0)
        let B = Int(Double(self.R * self.A + anotherColour.B * (255 - self.A)) / 65025.0)
        let A = self.A
        return ColourGene(R: R, G: G, B: B, A: A)!
    }
}
```

