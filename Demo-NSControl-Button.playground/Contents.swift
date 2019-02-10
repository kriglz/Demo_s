//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport

class ButtonView: NSView {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.black.cgColor
        
        let button = Button(target: self, action: #selector(colorBackground(_:)))
        
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func colorBackground(_ sender: Button) {
        self.layer?.backgroundColor = NSColor.red.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.layer?.backgroundColor = NSColor.black.cgColor
        }
    }
}

class Button: NSControl {
    
    var title: String? {
        didSet {
            self.titleLabel.stringValue = self.title ?? "Nil"
        }
    }
    
    private var isSelected = false {
        didSet {
            guard self.isSelected != oldValue else {
                return
            }
            
            if self.isSelected {
                self.layer?.backgroundColor = NSColor.green.cgColor
            } else {
                self.layer?.backgroundColor = NSColor.white.cgColor
            }
        }
    }
    
    private var purchaseAction: Selector?
    private var purchaseTarget: AnyObject?
    private var titleLabel: NSTextField
    
    convenience init(target: AnyObject, action: Selector) {
        self.init()
        
        self.purchaseAction = action
        self.purchaseTarget = target
    }
    
    init() {
        self.titleLabel = NSTextField(labelWithString: "Push me in text now")
        self.titleLabel.textColor = NSColor.blue
        self.titleLabel.alignment = .center
        
        super.init(frame: .zero)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.white.cgColor
        self.layer?.borderColor = NSColor.yellow.cgColor
        self.layer?.cornerRadius = 5.0
        self.layer?.borderWidth = 3.0
        
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        self.bottomAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10).isActive = true
        self.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        self.isSelected = true
        
        if let target = self.purchaseTarget, target.responds(to: self.purchaseAction) {
            target.perform(self.purchaseAction, with: self)
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        
        self.isSelected = false
    }
    
    override func resetCursorRects() {
        if self.isEnabled {
            self.addCursorRect(self.bounds, cursor: NSCursor.pointingHand)
        } else {
            self.addCursorRect(self.bounds, cursor: NSCursor.iBeam)
        }
    }
}

let view = ButtonView(frame: NSRect(origin: .zero, size: CGSize(width: 400, height: 300)))

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = view
