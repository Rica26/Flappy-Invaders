
import Foundation
import SpriteKit

class GameOverScene : SKScene {
    init(size: CGSize, won: Bool) {
        super.init(size: size)
        
        backgroundColor = .white
        let message = won ? "You won" : "You lost"
        let label = SKLabelNode(text: message)
        label.fontColor = won ? .green : .red
        label.fontSize = 48
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
