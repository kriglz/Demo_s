//
//  TestWindow.swift
//  Demo
//
//  Created by Kristina Gelzinyte on 3/22/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import Cocoa

class TestWindow: NSWindowController, NSToolbarDelegate, NSUserInterfaceValidations {
    
    
    func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
        
        if item.action == #selector(doSOmething(_:)) {
            if let menuItem = item as? NSMenuItem {
//                print("validate \((item as? NSMenuItem)?.state.rawValue), \(item.action)")

//                menuItem.state = .on
                
                print(menuItem.state)
                
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 1000000000)) {
//                    print(menuItem.debugDescription)
//
//                }
                
            }
        }
        
        return true
    }
    
    
    let toolbar = NSToolbar()
    
    private let itemId = NSToolbarItem.Identifier("ItemID")
    private lazy var item: NSToolbarItem = {
        let item = NSToolbarItem(itemIdentifier: itemId)
        
        let button = NSButton(title:  "ITEM button", target: self, action: #selector(doSOmething))
        button.imageHugsTitle = true
        button.setButtonType(NSButton.ButtonType.onOff)
        button.bezelStyle = NSButton.BezelStyle.texturedRounded
        button.state = .off
        button.alignment = .center
        button.sizeToFit()
        
        item.view = button
        item.label = "ITEM label"
        
        let menuItem = NSMenuItem()
        menuItem.title = "ITEM menu"
        
        let menu = NSMenu()
        menu.addItem(menuItem)
        menu.showsStateColumn = true
        
        menuItem.action = #selector(doSOmething)
        menuItem.target = self
        
        item.validateMenuItem(menuItem)
        item.menuFormRepresentation = menuItem
        
        let width = button.bounds.size.width + 14.0
        item.minSize = NSSize(width: width, height: button.bounds.size.height)
        item.maxSize = NSSize(width: width, height: button.bounds.size.height)
        
        return item
    }()
    
    override var windowNibName: NSNib.Name? {
        get {
            return NSNib.Name.init("TestWindow")
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.toolbar.delegate = self
        
        self.window?.toolbar = self.toolbar

        self.toolbar.autosavesConfiguration = true
        self.toolbar.displayMode = .iconOnly
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        self.window?.close()
    }
    
    @objc func doSOmething(_ sender: Any?) {
        
//        if let control = sender as? NSControl {
//            print("item was selected \(control), its state \(control.debugDescription)")
//        }
//
//        if let button = sender as? NSButton {
//            print("item was selected \(button), its state \(button.state)")
//        }
        
        if let item = sender as? NSMenuItem {
            item.state = item.state == .on ? .off : .on
        }
    }
    
    // MARK: NSToolbar Delegate
    
    override func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
        print("do \(item.debugDescription) validation \n")
        return true
    }
    
    func toolbarItems() -> [NSToolbarItem.Identifier] {
        return [NSToolbarItem.Identifier.flexibleSpace, itemId, NSToolbarItem.Identifier.flexibleSpace, itemId]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [NSToolbarItem.Identifier.flexibleSpace, itemId, NSToolbarItem.Identifier.flexibleSpace, itemId]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [NSToolbarItem.Identifier.flexibleSpace, itemId]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        switch itemIdentifier {
        case itemId:
            return self.item
        default:
            break
        }

        return nil
    }
}

extension NSMenuItem {
    var menu: NSMenu {
        get {
            return NSMenu()
        }
        set {
            self.menu = newValue
        }
    }
}
