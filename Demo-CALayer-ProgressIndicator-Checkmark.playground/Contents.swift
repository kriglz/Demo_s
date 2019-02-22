//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport

class ProgressIndicatorLayer: CAShapeLayer {

    enum Shape {
        case circle
        case mark
        case progressIndicator
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
        case .progressIndicator:
            self.configureProgressIndicator(in: rect)
        }
    }
    
    private func configureCircleClose(in rect: CGRect) {
        let bezierPath = NSBezierPath()
        bezierPath.appendArc(withCenter: NSPoint(x: rect.midX, y: rect.midY),
                             radius: rect.size.width / 2,
                             startAngle: 270,
                             endAngle: 269.99)
        
        self.path = bezierPath.cgPath
        self.strokeEnd = 0
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
        self.opacity = 0
    }
    
    private func configureProgressIndicator(in rect: NSRect) {
        let bezierPath = NSBezierPath()
        bezierPath.appendOval(in: rect)
        
        self.path = bezierPath.cgPath
    }
    
    func animate(duration: Double, delay: Double) {
        switch self.type {
        case .circle:
            self.animateCircle(duration: duration, delay: delay)
        case .mark:
            self.animateMark(duration: duration, delay: delay)
        case .progressIndicator:
            self.animateProgressIndicator(duration: duration, delay: delay)
        }
    }
    
    private func animateCircle(duration: Double, delay: Double) {
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.5
        strokeEndAnimation.toValue = 1
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0.5
        strokeStartAnimation.toValue = 0
        
        let group = CAAnimationGroup()
        group.animations = [strokeStartAnimation, strokeEndAnimation]
        group.isRemovedOnCompletion = false
        group.timingFunction = CAMediaTimingFunction(name: .easeIn)
        group.fillMode = .forwards
        group.beginTime = CACurrentMediaTime() + delay
        group.duration = duration

        self.add(group, forKey: "closingAnimation")
    }
    
    private func animateMark(duration: Double, delay: Double) {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        opacityAnimation.duration = duration
        opacityAnimation.beginTime = CACurrentMediaTime() + delay

        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        opacityAnimation.fillMode = .forwards
        
        self.add(opacityAnimation, forKey: "opacityAnimation")
        
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
    
    private func animateProgressIndicator(duration: Double, delay: Double) {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.beginTime = CACurrentMediaTime() + delay

        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.fillMode = .forwards
        opacityAnimation.duration = duration
        
        self.add(opacityAnimation, forKey: "rotationAnimation")
    }
}

class IndicatorView: NSView {
    
    var circle: ProgressIndicatorLayer?
    var mark: ProgressIndicatorLayer?
    var progressIndicator: ProgressIndicatorLayer?
    
    let gradient = CAGradientLayer()

    convenience init(in rect: NSRect) {
        self.init(frame: rect)
        
        self.wantsLayer = true
        
        let layerRect = NSRect(x: rect.midX - 25, y: rect.midY - 25, width: 50, height: 50)
        
        let strokeColor = NSColor.controlAccentColor.cgColor
        let fillColor = NSColor.clear.cgColor
        let lineWidth: CGFloat = 2.0
        
        self.circle = ProgressIndicatorLayer(type: .circle, in: layerRect)
        self.mark = ProgressIndicatorLayer(type: .mark, in: layerRect)
        self.progressIndicator = ProgressIndicatorLayer(type: .progressIndicator, in: layerRect)
        
        guard let mark = self.mark, let circle = self.circle, let progressIndicator = self.progressIndicator else {
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
        
        progressIndicator.strokeColor = strokeColor
        progressIndicator.fillColor = fillColor
        progressIndicator.lineCap = .butt
        progressIndicator.lineDashPattern = [2, 2]
        progressIndicator.lineWidth = 4.0
        
        gradient.frame = rect
        gradient.type = .conic
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        gradient.colors = [NSColor.controlAccentColor.cgColor, NSColor.controlAccentColor.cgColor, NSColor.white.cgColor, NSColor.controlAccentColor.cgColor]
        
        gradient.mask = progressIndicator

        self.layer?.addSublayer(circle)
        self.layer?.addSublayer(mark)
        self.layer?.addSublayer(gradient)

        self.rotationAnimation(duration: 1.0)
        self.animate()
    }
    
    func animate() {
        self.circle?.animate(duration: 0.3, delay: 4)
        self.mark?.animate(duration: 0.6, delay: 4)
        self.progressIndicator?.animate(duration: 0.5, delay: 3.7)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) { [weak self] in
            self?.animate()
        }
    }
    
    func rotationAnimation(duration: Double) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.byValue = -CGFloat.pi * 2
        rotation.duration = 0.7
        rotation.isCumulative = true
        rotation.repeatCount = .infinity
        
        self.gradient.add(rotation, forKey: "rotationAnimation")
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
