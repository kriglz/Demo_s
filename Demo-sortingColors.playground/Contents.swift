//: A SpriteKit based Playground

import PlaygroundSupport
import UIKit

let rect = CGRect(x: 0 , y: 0, width: 440, height: 480)
let view = GraphView(frame: rect)
view.performSorting()

PlaygroundSupport.PlaygroundPage.current.liveView = view

