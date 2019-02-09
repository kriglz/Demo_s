//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport

let nibFile = NSNib.Name("MyView")
var topLevelObjects : NSArray?

Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)
let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }

// Present the view in Playground
PlaygroundPage.current.liveView = views[0] as! NSView

class View: NSView {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.black.cgColor
        
        let button = Button()
        button.target = self
        button.action = #selector(colorBackground(_:))
        
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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
        self.titleLabel = NSTextField(labelWithString: "Empty title")

        super.init(frame: .zero)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.white.cgColor
        
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
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
}
