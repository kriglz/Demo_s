//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    let indicator = LoadingIndicator()

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .gray
        
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false

        indicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        indicator.heightAnchor.constraint(equalTo: indicator.widthAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animate))
        view.addGestureRecognizer(tapGesture)
        
        self.view = view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        indicator.loadToPercentage(1)
        indicator.start()
    }
    
    @objc private func animate() {
//        indicator.loadToPercentage(1)
    }
}

class LoadingIndicator: UIView {
    
    private let backgroundCircle = CAShapeLayer()
    private let loadingCircle = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundCircle.fillColor = UIColor.clear.cgColor
        backgroundCircle.strokeColor =  UIColor.lightGray.withAlphaComponent(0.4).cgColor
        backgroundCircle.lineWidth = 2
        
        loadingCircle.fillColor = UIColor.clear.cgColor
        loadingCircle.strokeColor =  UIColor.white.cgColor
        loadingCircle.lineWidth = 2
        loadingCircle.strokeEnd = 0
        loadingCircle.strokeStart = 0

        layer.addSublayer(backgroundCircle)
        layer.addSublayer(loadingCircle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundCircle.path = UIBezierPath(ovalIn: bounds).cgPath
        
        let length = 0.5 * bounds.width
        let center = CGPoint(x: bounds.origin.x + length, y: bounds.origin.y + length)
        let startAngle = -0.25 * CGFloat.pi
        let circle = UIBezierPath(arcCenter: center,
                                  radius: length,
                                  startAngle: -0.25 * CGFloat.pi,
                                  endAngle: startAngle - 2 * CGFloat.pi,
                                  clockwise: false)
        
        loadingCircle.path = circle.cgPath
    }
    
    func start() {
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        strokeEndAnimation.timingFunction = .init(name: .easeInEaseOut)
        strokeEndAnimation.duration = 4
        strokeEndAnimation.repeatCount = Float.greatestFiniteMagnitude
        strokeEndAnimation.isRemovedOnCompletion = false
        strokeEndAnimation.fillMode = .forwards

        strokeEndAnimation.fromValue = 0 //loadingCircle.presentation()?.value(forKeyPath: "strokeEnd")
        strokeEndAnimation.toValue = 1
        loadingCircle.add(strokeEndAnimation, forKey: "strokeEndAnimation")

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
//        strokeStartAnimation.timingFunction = .init(name: .easeInEaseOut)
        strokeStartAnimation.duration = 4
        strokeStartAnimation.repeatCount = Float.greatestFiniteMagnitude
        strokeStartAnimation.isRemovedOnCompletion = false
        strokeStartAnimation.fillMode = .forwards

        strokeStartAnimation.timeOffset = 2
        strokeStartAnimation.fromValue = 0 //loadingCircle.presentation()?.value(forKeyPath: "strokeStart")
        strokeStartAnimation.toValue = 1
        loadingCircle.add(strokeStartAnimation, forKey: "strokeStartAnimation")
    }
    
    func loadToPercentage(_ percentage: CGFloat) {
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.timingFunction = .init(name: .easeInEaseOut)
        strokeAnimation.fromValue = loadingCircle.presentation()?.value(forKeyPath: "strokeEnd")
        strokeAnimation.toValue = percentage

        let animation = CAAnimationGroup()
        animation.animations = [strokeAnimation]
        animation.duration = 5
        loadingCircle.add(animation, forKey: "strokeAnimation")
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
