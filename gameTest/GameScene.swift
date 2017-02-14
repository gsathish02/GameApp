//
//  GameScene.swift
//  gameTest
//
//  Created by Sathish Kumar on 10/3/16.
//  Copyright © 2016 Sathish Kumar. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    let playButton = SKSpriteNode(imageNamed:"Play-button")
    let highScore = SKLabelNode(fontNamed: "SF Mono")
    let greetingText = SKLabelNode(fontNamed: "SF Mono")
    
    override func didMove(to view: SKView) {
        self.playButton.position = CGPoint(x:self.frame.midX, y:self.frame.minY/4)
      
        self.backgroundColor = UIColor(red:99/255, green:110/255, blue: 150/255, alpha:1)
        
        self.greetingText.text = "Hello a Nice Day!"
        self.greetingText.fontSize = 25
        self.greetingText.position = CGPoint(x: self.frame.midX, y: (self.frame.minY/1.1))
        self.highScore.text = "HighScore = \(appdelegate.overAllHighScore.description)"
        self.highScore.fontSize = 25
        self.highScore.position = CGPoint(x: self.frame.midX, y: self.frame.minY/1.6)
        self.addChild(playButton)
        self.addChild(greetingText)
        self.addChild(highScore)
    }
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { //102,85,112
           let location = t.location(in: self)
            if self.atPoint(location) == self.playButton {
                 print("Touching at play buttom")
                let pScene = PlayScene(size:self.size)
                let view = self.view! as SKView
                view.ignoresSiblingOrder = true
                view.showsNodeCount = false
                view.showsFPS = false
                pScene.size = view.bounds.size
                pScene.scaleMode = .resizeFill
            //    pScene.backgroundColor = self.backgroundColor
                pScene.backgroundColor = UIColor(red:54/255, green:160/255, blue: 210/255, alpha:1)
            
                view.presentScene(pScene)
            }
           else{
                 print("Touching at differnt place")
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
