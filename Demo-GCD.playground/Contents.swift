//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

func simpleQueues() {
    let queue = DispatchQueue(label: "com.appcoda.myqueue")
    
    queue.async {
        for i in 0..<10 {
            print("🔴", i)
        }
    }
    
    for i in 0..<10 {
        print("Ⓜ️", i)
    }
}

func queuesWithQoS() {
//    let queue1 = DispatchQueue(label: "com.appcoda.queue1", qos: DispatchQoS.userInitiated)
     let queue1 = DispatchQueue(label: "com.appcoda.queue1", qos: DispatchQoS.background)
     let queue2 = DispatchQueue(label: "com.appcoda.queue2", qos: DispatchQoS.userInitiated)
//    let queue2 = DispatchQueue(label: "com.appcoda.queue2", qos: DispatchQoS.utility)
    
    queue1.async {
        for i in 0..<10 {
            print("🔴", i)
        }
    }
    
    queue2.async {
        for i in 0..<10 {
            print("🔵", i)
        }
    }
    
    for i in 0..<10 {
        print("Ⓜ️", i)
    }
}

var inactiveQueue: DispatchQueue!
func concurrentQueues() {
    // let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .utility)
    // let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .utility, attributes: .concurrent)
    // let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .utility, attributes: .initiallyInactive)
    let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .userInitiated, attributes: [.concurrent, .initiallyInactive])
    inactiveQueue = anotherQueue
    
    anotherQueue.async {
        for i in 0..<10 {
            print("🔴", i)
        }
    }
    
    anotherQueue.async {
        for i in 0..<10 {
            print("🔵", i)
        }
    }
    
    anotherQueue.async {
        for i in 0..<10 {
            print("⚫️", i)
        }
    }
}

func queueWithDelay() {
    let delayQueue = DispatchQueue(label: "com.appcoda.delayqueue", qos: .userInitiated)
    
    print(Date())
    let additionalTime: DispatchTimeInterval = .seconds(2)
    
    delayQueue.asyncAfter(deadline: .now() + additionalTime) {
        print(Date())
    }
}

let semaphore = DispatchSemaphore(value: 1)
func childrenOnIPad() {
    DispatchQueue.global().async {
        print("Kid 1 - wait")
        semaphore.wait()
        print("Kid 1 - wait finished")
        sleep(1) // Kid 1 playing with iPad
        semaphore.signal()
        print("Kid 1 - done with iPad")
    }
    DispatchQueue.global().async {
        print("Kid 2 - wait")
        semaphore.wait()
        print("Kid 2 - wait finished")
        sleep(1) // Kid 1 playing with iPad
        semaphore.signal()
        print("Kid 2 - done with iPad")
    }
    DispatchQueue.global().async {
        print("Kid 3 - wait")
        semaphore.wait()
        print("Kid 3 - wait finished")
        sleep(1) // Kid 1 playing with iPad
        semaphore.signal()
        print("Kid 3 - done with iPad")
    }
}

childrenOnIPad()
