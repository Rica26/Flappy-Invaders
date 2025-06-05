import SpriteKit

class MenuScene: SKScene {

    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        background.size = self.size
        addChild(background)
        
        let bgMusic = SKAudioNode(fileNamed: "menubackgroundmusic")
        bgMusic.autoplayLooped = true
        addChild(bgMusic)
        
        
        let titleLabel = SKLabelNode(text: "Flappy Invaders")
        titleLabel.fontName = "Arial-BoldMT"
        titleLabel.fontSize = 40
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.7)
        addChild(titleLabel)
        
        
        let playButton = SKLabelNode(text: "PLAY")
        playButton.name = "play"
        playButton.fontName = "Arial-BoldMT"
        playButton.fontSize = 30
        playButton.fontColor = .green
        playButton.position = CGPoint(x: size.width / 2, y: size.height * 0.5)
        addChild(playButton)
        
        
        let exitButton = SKLabelNode(text: "EXIT")
        exitButton.name = "exit"
        exitButton.fontName = "Arial-BoldMT"
        exitButton.fontSize = 30
        exitButton.fontColor = .red
        exitButton.position = CGPoint(x: size.width / 2, y: size.height * 0.4)
        addChild(exitButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        if let nodeName = touchedNode.name {
            switch nodeName {
            case "play":
                if let view = self.view {
                    let scene = GameScene(size: view.bounds.size)
                    scene.scaleMode = .aspectFill
                    view.presentScene(scene, transition: .doorsOpenHorizontal(withDuration: 1.0))
                }
            case "exit":
                exit(0)
            default:
                break
            }
        }
    }
}
