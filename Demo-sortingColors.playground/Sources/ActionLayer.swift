import SpriteKit

public class ActionLayer: CALayer {
    
    // MARK: - Properties
    
    static let duration = 0.2
    static let width = 5.0
    static let heightMultiplicationConstant = 5.0
    
    static let defaultColor = UIColor.white
    static let activeRangeColor = UIColor.blue
    static let activeItemColor = UIColor.gray
    
    private var moveActions: SKAction?
    
//    private var previousMoveActionIndex = 0
    
    // MARK: - Animation
    
    func moveAction(by translationLength: CGFloat, actionIndex: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + ActionLayer.duration * Double(actionIndex)) { [weak self] in
            print(self?.position)
            self?.position.x += translationLength
            print(self?.position)
            print("\n")
        }
        
//        let moveByAction =  SKAction.moveBy(x: translationLength, y: 0, duration: ActionLayer.duration)
//
//        let durationIndex = actionIndex - previousMoveActionIndex
//
//        if let currentActions = self.moveActions {
//            let sequence = [currentActions, SKAction.wait(forDuration: ActionLayer.duration * Double(durationIndex - 1)), action]
//            moveActions = SKAction.sequence(sequence)
//        } else {
//            let sequence = [SKAction.wait(forDuration: ActionLayer.duration * Double(durationIndex)), moveByAction]
//            moveActions = SKAction.sequence(sequence)
//        }
//
//        previousMoveActionIndex = actionIndex
    }
    
//    func runActions() {
//        var actions: SKAction?
//
//        if let moveActions = self.moveActions {
//            if let allActions = actions {
//                actions = SKAction.group([allActions, moveActions])
//            } else {
//                actions = moveActions
//            }
//        }
//
//        guard let allActions = actions else { return }
//        run(allActions) { [weak self] in
//            self?.color = ActionLayer.defaultColor
//        }
//    }
}

