//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport

class ProgressIndicatorLayer: CAShapeLayer {
    
    var layer: CALayer?
    
    private let animationDuraion = 1.0

    convenience init(in rect: NSRect) {
        self.init()
        
        self.configureCircleClose(in: rect)
//        self.configureCircle(in: rect)
    }
    
    private func configureCircleClose(in rect: CGRect) {
        let bezierPath = NSBezierPath()
        bezierPath.appendOval(in: rect)
        
        self.path = bezierPath.cgPath
        
        self.animateCircleClose()
    }
    
    private func configureCheckMark(in rect: NSRect) {
        let markPath = NSBezierPath()
        
        let startPoint = NSPoint(x: rect.origin.x + rect.size.width / 4, y: rect.midY)
        let middlePoint = NSPoint(x: rect.midX, y: rect.origin.x + rect.size.width / 4)
        let endPoint = NSPoint(x: rect.origin.x + rect.size.width * 3 / 4, y: rect.origin.x + rect.size.width * 3 / 4)
        
        markPath.move(to: startPoint)
        markPath.line(to: middlePoint)
        markPath.line(to: endPoint)
    }
    
    private func animateCircleClose() {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = self.animationDuraion
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        self.add(animation, forKey: "closingAnimation")
    }
    
    private func configureCircle(in rect: NSRect) {
        let bezierPath = NSBezierPath()
        bezierPath.appendOval(in: rect)
        
        self.path = bezierPath.cgPath
        
        self.animateStroke()
        self.animateRotation()
    }
    
    private func animateStroke() {
        let delay = 0.7
        
        let startAnimation = CABasicAnimation(keyPath: "strokeStart")
        startAnimation.fromValue = 1
        startAnimation.toValue = 0
        startAnimation.duration = self.animationDuraion
        
        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.fromValue = 1
        endAnimation.toValue = 0
        endAnimation.duration = self.animationDuraion
        endAnimation.beginTime = startAnimation.beginTime + delay
        
        let strokeAnimation = CAAnimationGroup()
        strokeAnimation.animations = [startAnimation, endAnimation]
        strokeAnimation.duration = self.animationDuraion + delay
        strokeAnimation.repeatCount = .infinity
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        self.add(strokeAnimation, forKey: "strokeAnimation")
    }
    
    private func animateRotation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.byValue = -CGFloat.pi / 3
        rotationAnimation.duration = self.animationDuraion / 4
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = .infinity

        self.add(rotationAnimation, forKey: rotationAnimation.keyPath)
    }
}

extension NSBezierPath {
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            }
        }
        return path
    }
}

let frame = NSRect(origin: .zero, size: CGSize(width: 600, height: 600))
let mainView = NSView(frame: frame)
mainView.wantsLayer = true
mainView.layer?.backgroundColor = NSColor.white.cgColor

let rect = NSRect(x: -25, y: -25, width: 50, height: 50)
let progressIndicatorLayer = ProgressIndicatorLayer(in: rect)
progressIndicatorLayer.strokeColor = NSColor.red.cgColor
progressIndicatorLayer.lineWidth = 2
progressIndicatorLayer.lineCap = .round
progressIndicatorLayer.fillColor = NSColor.clear.cgColor

progressIndicatorLayer.position = CGPoint(x: mainView.bounds.midX, y: mainView.bounds.midY)
mainView.layer?.addSublayer(progressIndicatorLayer)

let indicator = NSProgressIndicator()
indicator.controlSize = .regular
indicator.style = .spinning
indicator.frame = NSRect(origin: CGPoint(x: progressIndicatorLayer.frame.origin.x - 25, y: progressIndicatorLayer.frame.origin.y - 25), size: rect.size)
mainView.addSubview(indicator)

indicator.startAnimation(nil)


NSAnimationContext.runAnimationGroup { context in
    context.duration = 1
    
    indicator.alphaValue = 0
}

PlaygroundPage.current.liveView = mainView
