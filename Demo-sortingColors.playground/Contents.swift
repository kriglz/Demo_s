//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

let sortingArray = [15, 09, 08, 01, 04, 11, 07, 12, 13, 06, 05, 03, 16, 02, 10, 14]

let graphView = GraphView(array: sortingArray)
graphView.frame = CGRect(x: 0 , y: 0, width: 640, height: 480)

let scene = SKScene()
scene.backgroundColor = .clear
scene.scaleMode = .aspectFill
graphView.presentScene(scene)

graphView.setupGraph()
graphView.sortByInsertion()

PlaygroundSupport.PlaygroundPage.current.liveView = graphView
