//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
}

extension UIBezierPath {
    static func superellipse(in rect: CGRect) -> UIBezierPath {
        
        let rectSize: CGFloat = rect.width
        let rectangle = CGRect(x: rect.midX - rectSize / 2, y: rect.midY - rectSize / 2, width: rectSize, height: rectSize)
        
        let topLPoint = CGPoint(x: rectangle.minX, y: rectangle.minY)
        let topRPoint = CGPoint(x: rectangle.maxX, y: rectangle.minY)
        let botLPoint = CGPoint(x: rectangle.minX, y: rectangle.maxY)
        let botRPoint = CGPoint(x: rectangle.maxX, y: rectangle.maxY)
        
        let midRPoint = CGPoint(x: rectangle.maxX, y: rectangle.midY)
        let botMPoint = CGPoint(x: rectangle.midX, y: rectangle.maxY)
        let topMPoint = CGPoint(x: rectangle.midX, y: rectangle.minY)
        let midLPoint = CGPoint(x: rectangle.minX, y: rectangle.midY)
        
        let bezierCurvePath = UIBezierPath()
        bezierCurvePath.move(to: midLPoint)
        bezierCurvePath.addCurve(to: topMPoint, controlPoint1: topLPoint, controlPoint2: topLPoint)
        bezierCurvePath.addCurve(to: midRPoint, controlPoint1: topRPoint, controlPoint2: topRPoint)
        bezierCurvePath.addCurve(to: botMPoint, controlPoint1: botRPoint, controlPoint2: botRPoint)
        bezierCurvePath.addCurve(to: midLPoint, controlPoint1: botLPoint, controlPoint2: botLPoint)
        
        return bezierCurvePath
    }
    
    static func superellipse(in rect: CGRect, cornerRadius: CGFloat) -> UIBezierPath {
        
        // (Corner radius can't exceed half of the shorter side; correct if
        // necessary:)
        let radius = min(cornerRadius * 2, min(rect.width, rect.height) / 2)
        
        let topLeft = CGPoint(x: rect.minX, y: rect.minY)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        
        // The two points of the segment along the top side (clockwise):
        let p0 = CGPoint(x: rect.minX + radius, y: rect.minY)
        let p1 = CGPoint(x: rect.maxX - radius, y: rect.minY)
        
        // The two points of the segment along the right side (clockwise):
        let p2 = CGPoint(x: rect.maxX, y: rect.minY + radius)
        let p3 = CGPoint(x: rect.maxX, y: rect.maxY - radius)
        
        // The two points of the segment along the bottom side (clockwise):
        let p4 = CGPoint(x: rect.maxX - radius, y: rect.maxY)
        let p5 = CGPoint(x: rect.minX + radius, y: rect.maxY)
        
        // The two points of the segment along the left side (clockwise):
        let p6 = CGPoint(x: rect.minX, y: rect.maxY - radius)
        let p7 = CGPoint(x: rect.minX, y: rect.minY + radius)
        
        let path = UIBezierPath()
        path.move(to: p0)
        path.addLine(to: p1)
        path.addCurve(to: p2, controlPoint1: topRight, controlPoint2: topRight)
        path.addLine(to: p3)
        path.addCurve(to: p4, controlPoint1: bottomRight, controlPoint2: bottomRight)
        path.addLine(to: p5)
        path.addCurve(to: p6, controlPoint1: bottomLeft, controlPoint2: bottomLeft)
        path.addLine(to: p7)
        path.addCurve(to: p0, controlPoint1: topLeft, controlPoint2: topLeft)
        
        return path
    }
}

let viewController = MyViewController()

let rect = CGRect(x: 100, y: 200, width: 200, height: 200)

let squircle = CAShapeLayer()
squircle.bounds = viewController.view.frame
squircle.path = UIBezierPath.superellipse(in: rect, cornerRadius: 20).cgPath
squircle.fillColor = UIColor.clear.cgColor
squircle.strokeColor = UIColor.blue.cgColor
let squircleView = UIView(frame: viewController.view.frame)
squircleView.alpha = 1
squircleView.layer.addSublayer(squircle)

let borderView = UIView(frame: rect)
borderView.alpha = 0.3
borderView.backgroundColor = .clear
borderView.layer.cornerRadius = 20
borderView.layer.borderWidth = 1
borderView.layer.borderColor = UIColor.red.cgColor

viewController.view.addSubview(squircleView)
viewController.view.addSubview(borderView)

PlaygroundPage.current.liveView = viewController
