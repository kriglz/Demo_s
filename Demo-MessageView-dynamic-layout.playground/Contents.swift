//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MessageView: UIView {
    
    private let titleLabel: UILabel
    private let timeStampLabel: UILabel

    private var activeConstraints = [NSLayoutConstraint]()
    
    override init(frame: CGRect) {
        self.titleLabel = UILabel()
        self.timeStampLabel = UILabel()
        
        super.init(frame: frame)
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        timeStampLabel.font = UIFont.systemFont(ofSize: 11)

        addSubview(titleLabel)
        addSubview(timeStampLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeStampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(userName: String, message: String, timeStamp: TimeInterval) {
        let userNameAttributedString = userName.attributeStyle(.userName)
        let messageAttributedString = message.attributeStyle(.message)
        let timeStampAttributedString = "\(Int(timeStamp / 60))m".attributeStyle(.timeStamp)

        let title = NSMutableAttributedString(attributedString: userNameAttributedString)
        title.append(messageAttributedString)
        
        if timeStamp < 60 {
            title.append(" just now".attributeStyle(.message))
            titleLabel.attributedText = title
            timeStampLabel.attributedText = nil
        } else if title.size().width < bounds.width {
            titleLabel.attributedText = title
            timeStampLabel.attributedText = timeStampAttributedString
        } else {
            title.append(timeStampAttributedString)
            titleLabel.attributedText = title
            timeStampLabel.attributedText = nil
        }
        
        makeConstraints()
    }
    
    enum TitleStyle {
        case userName
        case message
        case timeStamp
        
        var attributes: [NSAttributedString.Key : Any] {
            switch self {
            case .userName:
                return [.foregroundColor: UIColor.blue,
                        .font: UIFont.systemFont(ofSize: 14, weight: .bold)]
            case .message:
                return [.foregroundColor: UIColor.blue,
                        .font: UIFont.systemFont(ofSize: 14)]
            case .timeStamp:
                return [.foregroundColor: UIColor.lightGray,
                        .font: UIFont.systemFont(ofSize: 11)]
            }
        }
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.deactivate(activeConstraints)
        activeConstraints.removeAll()
        
        defer {
            NSLayoutConstraint.activate(activeConstraints)
        }
        
        let titleBottomAnchorConstraint = timeStampLabel.text == nil ? bottomAnchor : timeStampLabel.topAnchor
        activeConstraints.append(titleLabel.bottomAnchor.constraint(equalTo: titleBottomAnchorConstraint))

        if timeStampLabel.attributedText != nil {
            activeConstraints.append(timeStampLabel.leadingAnchor.constraint(equalTo: leadingAnchor))
            activeConstraints.append(timeStampLabel.trailingAnchor.constraint(equalTo: trailingAnchor))
            activeConstraints.append(timeStampLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor))
            activeConstraints.append(timeStampLabel.bottomAnchor.constraint(equalTo: bottomAnchor))
        }
    }
}

extension String {
    
    func attributeStyle(_ style: MessageView.TitleStyle) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: style.attributes)
    }
}

class MyViewController : UIViewController {
    private let messageView = MessageView()
    private let imageView = UIView()
    private let button = UIButton(type: .system)

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        
        button.setTitle("show", for: .normal)
        button.addTarget(self, action: #selector(update), for: .touchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(messageView)
        view.addSubview(button)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true

        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        messageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        messageView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12).isActive = true
        messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        messageView.heightAnchor.constraint(greaterThanOrEqualTo: imageView.heightAnchor).isActive = true
        
        self.view = view
    }
    
    @objc private func update() {
        let title = "HelloHello HelloHelloHelloHell loHelloHelloHell "
        messageView.update(userName: "Kristina ", message: title, timeStamp: 1000)
    }
}

let controller = MyViewController()
PlaygroundPage.current.liveView = controller
