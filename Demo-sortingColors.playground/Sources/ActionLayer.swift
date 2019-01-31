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
    
    private var previousMoveActionIndex = 0
    
    // MARK: - Animation
    
    func addMoveByAction(translationLength: CGFloat, actionIndex: Int) {
        let moveByAction =  SKAction.moveBy(x: translationLength, y: 0, duration: ActionLayer.duration)
        let action = SKAction.group([moveByAction)
        
        let durationIndex = actionIndex - previousMoveActionIndex
        
        if let currentActions = self.moveActions {
            let sequence = [currentActions, SKAction.wait(forDuration: ActionLayer.duration * Double(durationIndex - 1)), action]
            moveActions = SKAction.sequence(sequence)
        } else {
            let sequence = [SKAction.wait(forDuration: ActionLayer.duration * Double(durationIndex)), action]
            moveActions = SKAction.sequence(sequence)
        }
        
        previousMoveActionIndex = actionIndex
    }
    
    func runActions() {
        var actions: SKAction?
        
        if let moveActions = self.moveActions {
            if let allActions = actions {
                actions = SKAction.group([allActions, moveActions])
            } else {
                actions = moveActions
            }
        }
        
        guard let allActions = actions else { return }
        run(allActions) { [weak self] in
            self?.color = ActionLayer.defaultColor
        }
    }
}

