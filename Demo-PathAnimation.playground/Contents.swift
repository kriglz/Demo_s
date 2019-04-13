//: A UIKit based Playground for presenting user interface
  
import UIKit
import Foundation
import PlaygroundSupport

class MyViewController : UIViewController {
    
    let myShapeLayer = CAShapeLayer()
    
    let length: CGFloat = 50

    var size: CGSize {
        return CGSize(width: length, height: length)
    }

    var center: CGPoint {
        return CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
    }
    
    var centerSquare: CGPath {
        let origin = CGPoint(x: center.x - length / 2, y: center.y - length / 2)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: origin)
        bezierPath.addLine(to: CGPoint(x: origin.x, y: origin.y + length))
        bezierPath.addLine(to: CGPoint(x: origin.x + length, y: origin.y + length))
        bezierPath.addLine(to: CGPoint(x: origin.x + length, y: origin.y))
        bezierPath.close()
        return bezierPath.cgPath
    }
    
    var topSquare: CGPath {
        let origin = CGPoint(x: 0, y: 0)

        let bezierPath = UIBezierPath()
        bezierPath.move(to: origin)
        bezierPath.addLine(to: CGPoint(x: origin.x, y: origin.y + length))
        bezierPath.addLine(to: CGPoint(x: origin.x + view.bounds.width, y: origin.y + length))
        bezierPath.addLine(to: CGPoint(x: origin.x + view.bounds.width, y: origin.y))
        bezierPath.close()
        return bezierPath.cgPath
    }
    
    var topLeftSquare: CGPath {
        let origin = CGPoint(x: 0, y: 0)

        let bezierPath = UIBezierPath()
        bezierPath.move(to: origin)
        bezierPath.addLine(to: CGPoint(x: origin.x, y: origin.y + length))
        bezierPath.addLine(to: CGPoint(x: origin.x + length, y: origin.y + length))
        bezierPath.addLine(to: CGPoint(x: origin.x + length, y: origin.y))
        bezierPath.close()
        return bezierPath.cgPath
    }
    
    var leftSquare: CGPath {
        let origin = CGPoint(x: 0, y: 0)

        let bezierPath = UIBezierPath()
        bezierPath.move(to: origin)
        bezierPath.addLine(to: CGPoint(x: origin.x, y: origin.y + view.bounds.height))
        bezierPath.addLine(to: CGPoint(x: origin.x + length, y: origin.y + view.bounds.height))
        bezierPath.addLine(to: CGPoint(x: origin.x + length, y: origin.y))
        bezierPath.close()
        return bezierPath.cgPath
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myShapeLayer.path = centerSquare
        myShapeLayer.fillColor = UIColor.red.cgColor
        myShapeLayer.lineWidth = 0

        let view = UIView()
        view.layer.addSublayer(myShapeLayer)
        
        self.view.addSubview(view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Timer.scheduledTimer(withTimeInterval: 2.2, repeats: true) { _ in
            self.animate()
        }
    }
    
    func animate() {
        let duration = 0.5
        
        let shapeToTop = CABasicAnimation(keyPath: "path")
        shapeToTop.toValue = topSquare
        shapeToTop.duration = duration
        shapeToTop.isRemovedOnCompletion = false
        shapeToTop.fillMode = .forwards
        
        let shrinkToLeft = CABasicAnimation(keyPath: "path")
        shrinkToLeft.toValue = topLeftSquare
        shrinkToLeft.duration = duration
        shrinkToLeft.isRemovedOnCompletion = false
        shrinkToLeft.fillMode = .forwards
        
        let shapeToLeft = CABasicAnimation(keyPath: "path")
        shapeToLeft.toValue = leftSquare
        shapeToLeft.duration = duration
        shapeToLeft.isRemovedOnCompletion = false
        shapeToLeft.fillMode = .forwards
        
        let shapeToCenter = CABasicAnimation(keyPath: "path")
        shapeToCenter.toValue = centerSquare
        shapeToCenter.duration = duration
        shapeToCenter.isRemovedOnCompletion = false
        shapeToCenter.fillMode = .forwards
        
        shapeToTop.beginTime = CACurrentMediaTime()
        shrinkToLeft.beginTime = shapeToTop.beginTime + duration
        shapeToLeft.beginTime = shrinkToLeft.beginTime + duration
        shapeToCenter.beginTime = shapeToLeft.beginTime + duration

        myShapeLayer.add(shapeToTop, forKey: "shapeToTop")
        myShapeLayer.add(shrinkToLeft, forKey: "shrinkToLeft")
        myShapeLayer.add(shapeToLeft, forKey: "shapeToLeft")
        myShapeLayer.add(shapeToCenter, forKey: "shapeToCenter")
    }
}

PlaygroundPage.current.liveView = MyViewController()
