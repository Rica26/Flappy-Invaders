import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, killed: Int) {
        super.init(size: size)
        
        // Toca o som de derrota
        run(SKAction.playSoundFileNamed("defeat", waitForCompletion: false))
        
        // Fundo com imagem
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)
        
        // Texto "You lost"
        let message = "You lost"
        let label = SKLabelNode(text: message)
        label.fontColor = .red
        label.fontSize = 48
        label.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        addChild(label)
        
        // Texto com kills
        let killsLabel = SKLabelNode(text: "Kills: \(killed)")
        killsLabel.fontColor = .black
        killsLabel.fontSize = 32
        killsLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
        addChild(killsLabel)
        
        // Botão para reiniciar o jogo
        let playAgainButton = SKLabelNode(text: "PLAY AGAIN")
        playAgainButton.name = "play_again_button"
        playAgainButton.fontColor = .blue
        playAgainButton.fontSize = 36
        playAgainButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 60)
        addChild(playAgainButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Detecta toques no botão
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode.name == "play_again_button" {
            let scene = GameScene(size: size)
            scene.scaleMode = .aspectFill
            view?.presentScene(scene, transition: .doorsOpenHorizontal(withDuration: 1.0))
        }
    }
}

