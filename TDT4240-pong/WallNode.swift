//
//  WallNode.swift
//  TDT4240-pong
//
//  Created by Petr Zvoníček on 26.01.15.
//  Copyright (c) 2015 Petr Zvoníček. All rights reserved.
//

import SpriteKit

class WallNode: SKShapeNode {
    init(physicsBody: SKPhysicsBody) {
        super.init()
        
        physicsBody.friction = 0
        physicsBody.categoryBitMask = PhysicsCategory.Wall
        self.physicsBody = physicsBody
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}