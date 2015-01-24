//
//  GameScene.swift
//  TDT4240-pong
//
//  Created by Petr Zvoníček on 22.01.15.
//  Copyright (c) 2015 Petr Zvoníček. All rights reserved.
//

import SpriteKit

class PongScene: SKScene {
    override func didMoveToView(view: SKView) {
        // net node
        let netNode = createNetNode(view.frame.size.height)
        netNode.position = CGPointMake(view.frame.size.width / 2.0, 0)
        self.addChild(netNode)
        
        // ball node
        let ballSprite = BallSprite()
    }
    
    func createNetNode(length: CGFloat) -> SKShapeNode {
        let bezierPath = UIBezierPath()
        let startPoint = CGPointMake(0,0)
        let endPoint = CGPointMake(0,length)
        bezierPath.moveToPoint(startPoint)
        bezierPath.addLineToPoint(endPoint)
        
        var pattern : [CGFloat] = [10.0,10.0];
        let dashed = CGPathCreateCopyByDashingPath (bezierPath.CGPath, nil,0,pattern,2);
        
        return SKShapeNode(path: dashed)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
