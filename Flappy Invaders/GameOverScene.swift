
import Foundation
import SpriteKit

class GameOverScene : SKScene {
    init(size: CGSize, killed: Int) {
        super.init(size: size)
        run(SKAction.playSoundFileNamed("defeat", waitForCompletion: false))
        backgroundColor = .white
        let message = "You lost"
        let label = SKLabelNode(text: message)
        label.fontColor = .red
        label.fontSize = 48
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
