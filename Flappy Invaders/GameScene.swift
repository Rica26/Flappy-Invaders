import SpriteKit
import GameplayKit

struct Categoria {
    static let none : UInt32 = 0
    static let all : UInt32 = UInt32.max
    static let monster : UInt32 = 0b1  
    static let projectile : UInt32 = 0b10
    static let player : UInt32 = 0b11
    static let powerUp: UInt32 = 0x1 << 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    let player = SKSpriteNode(imageNamed: "player")
    var lives = 10
    var killed = 0
    let labelPlayer = SKLabelNode()
    let labelMonsters = SKLabelNode()
    var ammo = 50
    let labelAmmo = SKLabelNode()
    var lastUpdateTime: TimeInterval = 0

    let upButton = SKSpriteNode(imageNamed: "arrow")
    let downButton = SKSpriteNode(imageNamed: "arrow")
    let shootButton = SKSpriteNode(imageNamed: "shootButton")
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
            background.position = CGPoint(x: size.width / 2, y: size.height / 2)
            background.size = self.size
            background.zPosition = -1
            addChild(background)
        run(SKAction.playSoundFileNamed("iniciodojogo", waitForCompletion: false))
        
        player.position = CGPoint(x: size.width * 0.05,
                                  y: size.height * 0.5)
        player.size = CGSize(width: 50, height: 50)
        addChild(player)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = Categoria.player
        player.physicsBody?.contactTestBitMask = Categoria.monster
        player.physicsBody?.collisionBitMask = Categoria.none
        
        
        labelPlayer.text = "Lives: \(lives)"
        labelPlayer.fontSize = 30
        labelPlayer.fontColor = .red
        labelPlayer.position = CGPoint(x: 100, y: size.height - 50)
        addChild(labelPlayer)
        
        
        labelMonsters.text = "Killed: \(killed)"
        labelMonsters.fontSize = 30
        labelMonsters.fontColor = .red
        labelMonsters.position = CGPoint(x: size.width - 100, y: size.height - 50)
        addChild(labelMonsters)
        
        labelAmmo.text = "Ammo: \(ammo)"
        labelAmmo.fontSize = 30
        labelAmmo.fontColor = .red
        labelAmmo.position = CGPoint(x:size.width/2, y: size.height - 50)
        addChild(labelAmmo)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        
        
        removeAction(forKey: "monsterSpawn")
        startMonsterSpawn()

        
        
        let bgMusic = SKAudioNode(fileNamed: "backgroundmusic")
        bgMusic.autoplayLooped = true
        addChild(bgMusic)
        
        
        upButton.name = "upButton"
        upButton.size = CGSize(width: 90, height: 90)
        upButton.position = CGPoint(x: 110, y: 110)
        addChild(upButton)
            
        
        downButton.name = "downButton"
        downButton.size = CGSize(width: 90, height: 90)
        downButton.position = CGPoint(x: 110, y: 40)
        downButton.zRotation = .pi
        addChild(downButton)
        
        shootButton.name = "shootButton"
        shootButton.size = CGSize(width: 100, height: 70 )
        shootButton.position = CGPoint(x: size.width - 90, y: 70)
        addChild(shootButton)
    }
    
    func startMonsterSpawn() {
        let baseInterval: Double = 2.0
        let spawnRateIncrease: Double = 0.05
        let minInterval: Double = 0.3

        let adjustedInterval = max(baseInterval - (Double(killed) * spawnRateIncrease), minInterval)

        let spawnAction = SKAction.sequence([
            SKAction.run(addMonster),
            SKAction.wait(forDuration: adjustedInterval)
        ])

        let repeatAction = SKAction.repeatForever(spawnAction)
        run(repeatAction, withKey: "monsterSpawn")
    }
    
    func addMonster() {
        var monster: Monster
            var fastChance: CGFloat
            var largeChance: CGFloat

            
            switch killed {
            case 0..<25:
                fastChance = 0
                largeChance = 0
            case 25..<50:
                fastChance = 30
                largeChance = 10
            default:
                fastChance = 45
                largeChance = 20
            }

            let rand = CGFloat.random(in: 0..<100)

            if rand < largeChance {
                monster = LargeMonster(sceneSize: self.size, killed: self.killed)
                run(SKAction.playSoundFileNamed("bigshow", waitForCompletion: false))
            } else if rand < largeChance + fastChance {
                monster = FastMonster(sceneSize: self.size, killed: self.killed)
            } else {
                monster = Monster(sceneSize: self.size, killed: self.killed)
            }

            addChild(monster)
        
        
        if Int.random(in: 0...100) < 20 { // 5% de probabilidade
            let ammoBox = AmmoBox(sceneSize: self.size)
            self.addChild(ammoBox)
        }
        
        if Int.random(in: 0...100) < 10 {
            let slow = Slow(sceneSize: self.size)
            self.addChild(slow)
        }
    }



    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == Categoria.monster &&
            secondBody.categoryBitMask == Categoria.projectile {
            if let monster = firstBody.node as? Monster,
               let projectile = secondBody.node as? SKSpriteNode {
                projectile.removeFromParent()
                monster.takeHit()

                
                if monster.parent == nil {
                    killed += 1
                    labelMonsters.text = "Killed: \(killed)"
                    run(SKAction.playSoundFileNamed("morte", waitForCompletion: false))
                }
            }

        }
        else if firstBody.categoryBitMask == Categoria.monster &&
                secondBody.categoryBitMask == Categoria.player {
            if let monster = firstBody.node as? Monster {
                monster.removeFromParent()
                run(SKAction.playSoundFileNamed("dano", waitForCompletion: false))
                
                if monster is LargeMonster {
                    lives = 0
                } else {
                    lives -= 1
                }

                labelPlayer.text = "Lives: \(lives)"
                if lives <= 0 {
                    changeScene( killed: killed)
                    
                }
            }
        }

        
        if (firstBody.categoryBitMask == Categoria.player && secondBody.categoryBitMask == Categoria.powerUp) ||
            (firstBody.categoryBitMask == Categoria.powerUp && secondBody.categoryBitMask == Categoria.player) {
            
            guard let powerUpNode = (firstBody.categoryBitMask == Categoria.powerUp ? firstBody.node : secondBody.node) as? PowerUp else {
                return
            }
            
            run(SKAction.playSoundFileNamed("upgrade", waitForCompletion: false))
            
            if let ammoBox = powerUpNode as? AmmoBox {
                ammo += 10
                
                labelAmmo.text = "Ammo: \(ammo)"
            }
            
            if let slow = powerUpNode as? Slow {
                slowDownMonsters()
            }

            powerUpNode.removeFromParent()
        }
    }
    
    func changeScene( killed: Int) {
        let reveal = SKTransition.flipVertical(withDuration: 0.5)
        let gameoverScene = GameOverScene(size: self.size, killed: killed)
        self.view?.presentScene(gameoverScene, transition: reveal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)

        for node in nodesAtPoint {
            if node.name == "upButton" {
                movePlayer(up: true)
            } else if node.name == "downButton" {
                movePlayer(up: false)
            } else if node.name == "shootButton"{
                if ammo>0 {
                    shoot()
                }
                
            }
        }
        
        
    }

    func movePlayer(up: Bool) {
        let moveDistance: CGFloat = 50.0
        let newY = player.position.y + (up ? moveDistance : -moveDistance)
        let clampedY = min(max(newY, player.size.height / 2), size.height - player.size.height / 2)
        player.position = CGPoint(x: player.position.x, y: clampedY)
    }
    
        func shoot() {
            
            let projectile = SKSpriteNode(imageNamed: "projectile")
            projectile.position = player.position
            projectile.size = CGSize(width: 50, height: 50)

            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width / 2)
            projectile.physicsBody?.isDynamic = true
            projectile.physicsBody?.categoryBitMask = Categoria.projectile
            projectile.physicsBody?.contactTestBitMask = Categoria.monster
            projectile.physicsBody?.collisionBitMask = Categoria.none
            projectile.physicsBody?.usesPreciseCollisionDetection = true

            addChild(projectile)
            
            

            
            let direction = CGVector(dx: cos(player.zRotation), dy: sin(player.zRotation))

            
            let speed: CGFloat = 50
            let impulse = CGVector(dx: direction.dx * speed, dy: direction.dy * speed)
            projectile.physicsBody?.applyImpulse(impulse)

            
            let remove = SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.removeFromParent()])
            projectile.run(remove)

            
            run(SKAction.playSoundFileNamed("shoot", waitForCompletion: false))
            ammo-=1
            labelAmmo.text = "Ammo: \(ammo)"
        }
    
    override func update(_ currentTime: TimeInterval) {
        
        var deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        if deltaTime > 1 { deltaTime = 1.0 / 60.0 }
        for node in self.children {
            if let monster = node as? Monster {
                monster.update(deltaTime: deltaTime)
                if monster.position.x <= 0 {
                    monster.removeFromParent()
                    run(SKAction.playSoundFileNamed("dano", waitForCompletion: false))

                    if monster is LargeMonster {
                        lives = 0
                    } else {
                        lives -= 1
                    }

                    labelPlayer.text = "Lives: \(lives)"
                    if lives <= 0 {
                        changeScene(killed: killed)
                    }
                }

            }
        }
        
    }
    
    func slowDownMonsters() {
        for node in self.children {
            if let monster = node as? Monster {
                monster.slowDown()
            }
        }
    }
}
