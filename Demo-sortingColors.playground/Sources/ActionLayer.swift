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
    private var colorActions: SKAction?
    private var heightActions: SKAction?
    
    private var previousMoveActionIndex = 0
    private var previousColorActionIndex = 0
    private var previousHeightActionIndex = 0
    
    private var colorBlinkAction: SKAction {
        let colorAction = SKAction.colorize(with: ActionLayer.activeItemColor, colorBlendFactor: 1, duration: ActionLayer.duration)
        colorAction.timingMode = .easeOut
        let colorActionReversed = SKAction.colorize(with: ActionLayer.defaultColor, colorBlendFactor: 1, duration: 0)
        colorActionReversed.timingMode = .easeIn
        return SKAction.sequence([colorAction, colorActionReversed])
    }
    
    private var colorBlinkActionForRange: SKAction {
        let colorAction = SKAction.colorize(with: ActionLayer.activeItemColor, colorBlendFactor: 1, duration: ActionLayer.duration)
        colorAction.timingMode = .easeOut
        let colorActionReversed = SKAction.colorize(with: ActionLayer.activeRangeColor, colorBlendFactor: 1, duration: 0)
        colorActionReversed.timingMode = .easeIn
        return SKAction.sequence([colorAction, colorActionReversed])
    }
    
    // MARK: - Animation
    
    func addMoveByAction(translationLength: CGFloat, actionIndex: Int, isInActiveRange: Bool = false) {
        let moveByAction =  SKAction.moveBy(x: translationLength, y: 0, duration: ActionLayer.duration)
        let action = SKAction.group([moveByAction, isInActiveRange ? colorBlinkActionForRange : colorBlinkAction])
        
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
    
    func addColorAction(isColorized: Bool, actionIndex: Int) {
        let action = SKAction.colorize(with: isColorized ? ActionLayer.activeRangeColor : ActionLayer.defaultColor, colorBlendFactor: 1, duration: ActionLayer.duration)
        
        let durationIndex = actionIndex - previousColorActionIndex
        
        if let currentActions = self.colorActions {
            let sequence = [currentActions, SKAction.wait(forDuration: ActionLayer.duration * Double(durationIndex - 1)), action]
            colorActions = SKAction.sequence(sequence)
        } else {
            let sequence = [SKAction.wait(forDuration: ActionLayer.duration * Double(durationIndex)), action]
            colorActions = SKAction.sequence(sequence)
        }
        
        previousColorActionIndex = actionIndex
    }
    
    func addHeightChangeAction(height: Int, actionIndex: Int) {
        let resizeAction = SKAction.resize(toHeight: CGFloat(ActionLayer.heightMultiplicationConstant) * CGFloat(height), duration: ActionLayer.duration)
        let action = SKAction.group([resizeAction, colorBlinkAction])
        
        let durationIndex = actionIndex - previousHeightActionIndex
        
        if let currentActions = self.heightActions {
            let sequence = [currentActions, SKAction.wait(forDuration: ActionLayer.duration * Double(durationIndex - 1)), action]
            heightActions = SKAction.sequence(sequence)
        } else {
            let sequence = [SKAction.wait(forDuration: ActionLayer.duration * Double(durationIndex)), action]
            heightActions = SKAction.sequence(sequence)
        }
        
        previousHeightActionIndex = actionIndex
    }
    
    func runActions() {
        var actions: SKAction?
        
        if let heightActions = self.heightActions {
            if let allActions = actions {
                actions = SKAction.group([allActions, heightActions])
            } else {
                actions = heightActions
            }
        }
        
        if let moveActions = self.moveActions {
            if let allActions = actions {
                actions = SKAction.group([allActions, moveActions])
            } else {
                actions = moveActions
            }
        }
        
        if let colorActions = self.colorActions {
            if let allActions = actions {
                actions = SKAction.group([allActions, colorActions])
            } else {
                actions = colorActions
            }
        }
//        
//        guard let allActions = actions else { return }
//        run(allActions) { [weak self] in
//            self?.color = ActionLayer.defaultColor
//        }
    }
}

