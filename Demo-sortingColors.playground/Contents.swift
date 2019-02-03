//: A SpriteKit based Playground

import PlaygroundSupport
import UIKit

let rect = CGRect(x: 0 , y: 0, width: 440, height: 400)
let superview = UIView(frame: rect)

var thinRect = CGRect(x: 0 , y: 0, width: 440, height: 30)

for _ in 0...20 {
    thinRect.origin.y += 10
    
    let view = GraphView(frame: thinRect)
    superview.addSubview(view)
    
    view.performSorting(elements: 30)
}

PlaygroundSupport.PlaygroundPage.current.liveView = superview
