//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
        
    let loader = ScalingLoaderView()

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .darkGray
        
        view.addSubview(loader)
        
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        loader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        self.view = view
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startAnimation))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func startAnimation() {
        if loader.shouldAnimate {
            loader.stopAnimation()
        } else {
            loader.startAnimation()
        }
    }
}

class ScalingLoaderView: UIView {
    
    var shouldAnimate = false
    
    private let backgroundView = UIView()
    
    private let leftBall = CircleView()
    private let centerBall = CircleView()
    private let rightBall = CircleView()
     
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        backgroundView.layer.cornerRadius = 10
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        self.addSubview(backgroundView)
        self.addSubview(leftBall)
        self.addSubview(centerBall)
        self.addSubview(rightBall)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        leftBall.translatesAutoresizingMaskIntoConstraints = false
        centerBall.translatesAutoresizingMaskIntoConstraints = false
        rightBall.translatesAutoresizingMaskIntoConstraints = false

        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        backgroundView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        backgroundView.widthAnchor.constraint(equalToConstant: 80).isActive = true

        leftBall.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        leftBall.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        centerBall.leadingAnchor.constraint(equalTo: leftBall.trailingAnchor, constant: 12).isActive = true
        centerBall.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        rightBall.leadingAnchor.constraint(equalTo: self.centerBall.trailingAnchor, constant: 12).isActive = true
        rightBall.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        rightBall.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stopAnimation() {
        shouldAnimate = false
        
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0
        }
    }
    
    func startAnimation() {
        shouldAnimate = true
        animate()
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func animate() {
        let totalDuration: TimeInterval = 1.35
        let duration: TimeInterval = totalDuration / 3
        let delay: TimeInterval = totalDuration * 4 / 9
        let delayDelta: TimeInterval = totalDuration / 9

        UIView.animateKeyframes(withDuration: totalDuration, delay: 0, options: [.allowUserInteraction], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration) {
                self.leftBall.scaleUp()
            }
            
            UIView.addKeyframe(withRelativeStartTime: delayDelta, relativeDuration: duration) {
                self.centerBall.scaleUp()
            }
            
            UIView.addKeyframe(withRelativeStartTime: 2 * delayDelta, relativeDuration: duration) {
                self.rightBall.scaleUp()
            }
            
            UIView.addKeyframe(withRelativeStartTime: delay, relativeDuration: duration) {
                self.leftBall.scaleDown()
            }
            
            UIView.addKeyframe(withRelativeStartTime: delay + delayDelta, relativeDuration: duration) {
                self.centerBall.scaleDown()
            }
                        
            UIView.addKeyframe(withRelativeStartTime: delay + 2 * delayDelta, relativeDuration: duration) {
                self.rightBall.scaleDown()
            }
        }, completion: { completed in
            if completed, self.shouldAnimate {
                self.animate()
            }
        })
    }
    
    class CircleView: UIView {
        
        private let circleView = UIView()
        private let scaleCoefficient: CGFloat = 1.25

        override init(frame: CGRect) {
            super.init(frame: frame)
            
            circleView.layer.cornerRadius = 4
            circleView.backgroundColor = .white
            
            self.addSubview(circleView)
            
            circleView.translatesAutoresizingMaskIntoConstraints = false
            
            circleView.heightAnchor.constraint(equalToConstant: 8).isActive = true
            circleView.widthAnchor.constraint(equalTo: circleView.heightAnchor).isActive = true
            
            circleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            circleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            circleView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            circleView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func scaleUp() {
            self.transform = CGAffineTransform(scaleX: scaleCoefficient, y: scaleCoefficient)
        }
        
        func scaleDown() {
            self.transform = .identity
        }
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
