//: A SpriteKit based Playground

import PlaygroundSupport
import UIKit

let rect = CGRect(x: 0 , y: 0, width: 440, height: 400)
let superview = UIView(frame: rect)

var thinRect = CGRect(x: 30 , y: 30, width: 440, height: 30)

for _ in 0...30 {
    thinRect.origin.x += 10
    
    let view = GraphView(frame: thinRect)
    superview.addSubview(view)
    
    view.performSorting(elements: 30)
}

PlaygroundSupport.PlaygroundPage.current.liveView = superview
