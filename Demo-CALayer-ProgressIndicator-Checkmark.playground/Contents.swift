//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport

class ProgressIndicatorLayer: CAShapeLayer {

    enum Shape {
        case circle
        case mark
    }
    
    private var type = Shape.circle
    
    convenience init(type: Shape, in rect: NSRect) {
        self.init()

        self.type = type

        switch type {
        case .circle:
            self.configureCircleClose(in: rect)
        case .mark:
            self.configureCheckMark(in: rect)
        }
    }
    
    private func configureCircleClose(in rect: CGRect) {
        let bezierPath = NSBezierPath()
        bezierPath.appendArc(withCenter: NSPoint(x: rect.midX, y: rect.midY),
                             radius: rect.size.width / 2,
                             startAngle: 90,
                             endAngle: 89.99)
        
        self.path = bezierPath.cgPath
    }
    
    private func configureCheckMark(in rect: NSRect) {
        let markPath = NSBezierPath()
        
        let startPoint = NSPoint(x: rect.origin.x + rect.size.width * 0.27, y: rect.origin.y + rect.size.height * 0.45)
        let middlePoint = NSPoint(x: rect.origin.x + rect.size.width * 0.43, y: rect.origin.y + rect.size.height * 0.35)
        let endPoint = NSPoint(x: rect.origin.x + rect.size.width * 0.75, y: rect.origin.y + rect.size.height * 0.67)
        
        markPath.move(to: startPoint)
        markPath.line(to: middlePoint)
        markPath.line(to: endPoint)
        
        self.path = markPath.cgPath
    }
    
    func animate(duration: Double, delay: Double) {
        switch self.type {
        case .circle:
            self.animateCircle(duration: duration, delay: delay)
        case .mark:
            self.animateMark(duration: duration, delay: delay)
        }
    }
    
    func animateCircle(duration: Double, delay: Double) {
        self.strokeEnd = 0

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.5
        strokeEndAnimation.toValue = 1
//        strokeEndAnimation.duration = duration
//        strokeEndAnimation.beginTime = CACurrentMediaTime() + delay

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0.5
        strokeStartAnimation.toValue = 0
//        strokeStartAnimation.duration = duration
//        strokeStartAnimation.beginTime = CACurrentMediaTime() + delay

        
        let group = CAAnimationGroup()
        group.animations = [strokeStartAnimation, strokeEndAnimation]
        group.isRemovedOnCompletion = false
        group.timingFunction = CAMediaTimingFunction(name: .easeIn)
        group.fillMode = .forwards
        group.beginTime = CACurrentMediaTime() + delay
        group.duration = duration

        self.add(group, forKey: "closingAnimation")
    }
    
    func animateMark(duration: Double, delay: Double) {
        self.strokeEnd = 0

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.duration = duration
        strokeEndAnimation.beginTime = CACurrentMediaTime() + delay
        
        strokeEndAnimation.isRemovedOnCompletion = false
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        strokeEndAnimation.fillMode = .forwards
        
        self.add(strokeEndAnimation, forKey: "strokeAnimation")
    }
}

class IndicatorView: NSView {
    
    var circle: ProgressIndicatorLayer?
    var mark: ProgressIndicatorLayer?

    convenience init(in rect: NSRect) {
        self.init(frame: rect)
        
        self.wantsLayer = true
        
        let layerRect = NSRect(x: rect.midX - 50, y: rect.midY - 50, width: 100, height: 100)
        
        let strokeColor = NSColor.red.cgColor
        let fillColor = NSColor.clear.cgColor
        let lineWidth: CGFloat = 5.0
        
        self.circle = ProgressIndicatorLayer(type: .circle, in: layerRect)
        self.mark = ProgressIndicatorLayer(type: .mark, in: layerRect)

        guard let mark = self.mark, let circle = self.circle else {
            return
        }

        circle.strokeColor = strokeColor
        circle.fillColor = fillColor
        circle.lineWidth = lineWidth
        circle.lineCap = .round
        
        mark.strokeColor = strokeColor
        mark.fillColor = fillColor
        mark.lineWidth = lineWidth
        mark.lineCap = .round
        
        self.layer?.addSublayer(circle)
        self.layer?.addSublayer(mark)

        self.animate()
    }
    
    func animate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.circle?.animate(duration: 0.25, delay: 0)
            self?.mark?.animate(duration: 0.3, delay: 0.1)
            
            self?.animate()
        }
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

let indicatoView = IndicatorView(in: frame)
mainView.addSubview(indicatoView)

PlaygroundPage.current.liveView = mainView
