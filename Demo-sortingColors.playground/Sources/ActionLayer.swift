import SpriteKit

public class ActionLayer: CALayer {
    
    static let actionDuration = 0.05
        
    func moveAction(by translationLength: CGFloat, actionIndex: Int) {
        Timer.scheduledTimer(withTimeInterval: Double(actionIndex) * ActionLayer.actionDuration, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.position.y += translationLength
        }
    }
}
