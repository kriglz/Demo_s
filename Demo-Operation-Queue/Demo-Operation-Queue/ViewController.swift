//
//  ViewController.swift
//  Demo-Operation-Queue
//
//  Created by Kristina Gelzinyte on 10/4/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var operationQueue = OperationQueue()
    private var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        operationQueue.maxConcurrentOperationCount = 1
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapAction() {
        executeOperationQueue()
    }
    
    private func executeOperationQueue() {
        operationQueue.cancelAllOperations()

        print(self.index)
        
        let pindex = self.index
        let printOperation = PrintOperation(index: pindex)
        printOperation.completionBlock = {
            print("completed", pindex)
        }
        operationQueue.addOperation(printOperation)
        
        self.index += 1
    }
}

class PrintOperation: BaseOperation {
    
    private var index = 0
    
    init(index: Int) {
        self.index = index
    }
    
    override func main() {
        let url = "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/types-of-flowers-1520214627.jpg?crop=1.00xw:0.752xh;0,0.248xh&resize=980:*"
        getImageFromUrl(url, completionHandler: { image in
            print("executed", self.index)
            self.finish()
        })
    }
    
    func getImageFromUrl(_ strUrl: String, completionHandler handler: @escaping (_ img: UIImage) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: strUrl)
            let dataFromUrl = try? Data(contentsOf: url!)
            if dataFromUrl == nil {
                return
            }
            DispatchQueue.main.async(execute: {() -> Void in
                handler(UIImage(data: dataFromUrl!)!)
            })
        }
    }
}

open class BaseOperation: Operation {
        
    public var operationName:String { return "Base Operation" }
        
    @objc private enum OperationState: Int {
        case ready
        case executing
        case finished
    }
    
    private let stateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".rw.state", attributes: .concurrent)
    private var rawState: OperationState = .ready
        
    @objc private dynamic var state: OperationState {
        get { return stateQueue.sync { rawState } }
        set { stateQueue.sync(flags: .barrier) { rawState = newValue } }
    }
    
    // MARK: - Various `Operation` properties
    
    open         override var isReady:        Bool { return state == .ready && super.isReady }
    public final override var isExecuting:    Bool { return state == .executing }
    public final override var isFinished:     Bool { return state == .finished }
    public final override var isAsynchronous: Bool { return true }
    
    // MARK: - KVN for dependent properties

    @objc private dynamic class func keyPathsForValuesAffectingIsReady() -> Set<String> {
        return [#keyPath(state)]
    }
    
    @objc private dynamic class func keyPathsForValuesAffectingIsExecuting() -> Set<String> {
        return [#keyPath(state)]
    }

    @objc private dynamic class func keyPathsForValuesAffectingIsFinished() -> Set<String> {
        return [#keyPath(state)]
    }
    
    public final override func start() {
        if isCancelled {
            finish()
            return
        }
        
        state = .executing
        main()
    }
    
    open override func main() {
        fatalError("Subclasses must implement `main`.")
    }
        
    public final func finish() {
        state = .finished
    }
}
