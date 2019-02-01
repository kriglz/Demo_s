import SpriteKit

public class ActionLayer: UIView {
    
    // MARK: - Properties
    
    public var name: String!
    
    // MARK: - Animation
    
    func moveAction(by translationLength: CGFloat, actionIndex: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * Double(actionIndex)) { [weak self] in
            self?.frame.origin.x += translationLength
        }
    }
}
