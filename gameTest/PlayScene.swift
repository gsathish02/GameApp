//
//  PlayScene.swift
//  gameTest
//
//  Created by Sathish Kumar on 10/4/16.
//  Copyright © 2016 Sathish Kumar. All rights reserved.
//

import SpriteKit

class PlayScene : SKScene, SKPhysicsContactDelegate{
    let bottomBar = SKSpriteNode(imageNamed:"greenBar")
    let ball = SKSpriteNode(imageNamed:"PokiBall")
    let block1 = SKSpriteNode(imageNamed:"block1")
    let block2 = SKSpriteNode(imageNamed:"block2")
    
    let scoreString = SKLabelNode(fontNamed: "chalkduster")
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    let userDefault = UserDefaults.standard
   
    var currentBarPosition = CGFloat(0)
    var maxBarPositionX = CGFloat(0)
    var ballBaseLine = CGFloat(0)
    var velocityY = CGFloat(0)
    var onGround = true
    var gameSpead = 10
    var gravity = CGFloat(0.3)
    var blockStatus : [String:BlockStatus] = [:]
    
    var blockMaxX = CGFloat(0)
    var orignialBlockPosition = CGFloat(0)
    var score = 0

    enum collisionType : UInt32 {
        case Ball = 1
        case Block = 2
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        //At New Scene
        self.bottomBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        bottomBar.position = CGPoint(x: self.frame.minX, y: self.frame.minY+self.bottomBar.size.height/2)
        
        currentBarPosition = self.bottomBar.position.x
        maxBarPositionX =   self.frame.size.width - self.bottomBar.size.width
        self.addChild(self.bottomBar)
        self.ballBaseLine = self.bottomBar.position.y + (self.bottomBar.size.height/2) + (self.ball.size.height/4)
        
        self.ball.position = CGPoint(x: self.frame.minX + self.ball.size.width/2 + self.ball.size.width/4 , y: self.ballBaseLine)
        //Setting up collision with other object
        self.ball.physicsBody = SKPhysicsBody(circleOfRadius: self.ball.size.width/2)
        self.ball.physicsBody?.affectedByGravity = false
        self.ball.physicsBody?.categoryBitMask = collisionType.Ball.rawValue
        self.ball.physicsBody?.contactTestBitMask = collisionType.Block.rawValue
        self.ball.physicsBody?.collisionBitMask = collisionType.Block.rawValue
        
        self.block1.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.ballBaseLine)
        self.block2.position = CGPoint(x: self.frame.maxX + self.block2.size.width, y: self.ballBaseLine + (self.block1.size.height/2))
        
        // Uncomment the botom to coolide with blocks
        
        self.block1.physicsBody = SKPhysicsBody(rectangleOf: self.block1.size)
        self.block1.physicsBody?.affectedByGravity = false
        self.block1.physicsBody?.categoryBitMask = collisionType.Block.rawValue
        self.block1.physicsBody?.contactTestBitMask = collisionType.Ball.rawValue
        self.block1.physicsBody?.collisionBitMask = collisionType.Ball.rawValue
        
        self.block2.physicsBody = SKPhysicsBody(rectangleOf: self.block1.size)
        self.block2.physicsBody?.affectedByGravity = false
        self.block2.physicsBody?.categoryBitMask = collisionType.Block.rawValue
        self.block2.physicsBody?.contactTestBitMask = collisionType.Ball.rawValue
        self.block2.physicsBody?.collisionBitMask = collisionType.Ball.rawValue
        
        self.block1.name = "b1"
        self.block2.name = "b2"
        
        blockStatus["b1"] = BlockStatus(isRunning: false, timeForNextRun: random(), currentWaitingTime: UInt32(0))
        blockStatus["b2"] = BlockStatus(isRunning: false, timeForNextRun: random(), currentWaitingTime: UInt32(0))
        
        self.scoreString.text = "Score : 0"
        self.scoreString.fontSize = 32
        self.scoreString.position = CGPoint(x: self.frame.midX + self.frame.midX/2.2, y: self.frame.midY + self.frame.midY/1.1)

        self.blockMaxX = 0 - block1.size.width/2
        self.orignialBlockPosition = self.block1.position.x
        
        self.addChild(self.ball)
        self.addChild(self.scoreString)
        self.addChild(self.block1)
        self.addChild(self.block2)
       
    }
    func random() -> UInt32{
        let range = UInt32(50)..<UInt32(200)
        return range.startIndex + arc4random_uniform(range.endIndex - range.startIndex + 1)
    }
     func didBegin(_ contact: SKPhysicsContact) {
        let scene = GameScene(fileNamed: "GameScene")
        let view = self.view! as SKView
        view.ignoresSiblingOrder = true
        scene?.size = view.bounds.size
        scene?.scaleMode = .aspectFill
        view.presentScene(scene)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.onGround{
            velocityY = -18.0
            self.onGround = false
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if velocityY < -9.0{
            velocityY = -9.0
        }
    }
    override func update(_ currentTime: TimeInterval) {
        if self.bottomBar.position.x <= maxBarPositionX{
            self.bottomBar.position.x = self.currentBarPosition
        }
      //jump
        self.velocityY += gravity
        self.ball.position.y -= velocityY
        if(self.ball.position.y < self.ballBaseLine){
            self.ball.position.y = self.ballBaseLine
            self.velocityY = 0.0
            self.onGround = true
        }
        // ball rotation
        let degree = CDouble(gameSpead)*M_PI/180
        self.ball.zRotation -= CGFloat(degree)
        // moving the ground
        self.bottomBar.position.x -= CGFloat(gameSpead)
        
        blockRunner()
    } 
    func blockRunner(){
        for(block, bStatus) in blockStatus {
            let thisBlock = self.childNode(withName: block)
            if bStatus.shouldRun(){
                bStatus.timeForNextRun = random()
                bStatus.currentWaitingTime = 0
                bStatus.isRunning = true
            }
            if bStatus.isRunning{
            if (thisBlock?.position.x)! > blockMaxX
                {
                    thisBlock?.position.x -= CGFloat(self.gameSpead)
                }
                else {
                    thisBlock?.position.x = self.orignialBlockPosition
                    bStatus.isRunning = false
                    self.score += 1
                    self.scoreString.text = "Score : "+String(score)
                if self.score % 5 == 1{
                    self.gameSpead += 1
                }
                if self.score > appdelegate.overAllHighScore!{
                    appdelegate.overAllHighScore = self.score
                    UserDefaults.standard.set(self.score, forKey: "high")                }
                }
                
            }else{
                bStatus.currentWaitingTime += 1
            }
        }
    }
}
