//: A SpriteKit based Playground

import PlaygroundSupport
import UIKit

let screenWidth: CGFloat = 440.0
let screenHeight: CGFloat = 400.0
let pixelSize: CGFloat = 10.0
let colums = screenWidth / pixelSize
let rows = screenHeight / pixelSize

let superview = UIView(frame: CGRect(x: 0 , y: 0, width: screenWidth, height: screenHeight))
let view = GraphView(columns: Int(colums), rows: Int(rows), pixelSize: pixelSize)
superview.addSubview(view)

PlaygroundSupport.PlaygroundPage.current.liveView = superview
