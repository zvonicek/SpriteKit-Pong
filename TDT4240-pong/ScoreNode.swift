//
//  ScoreNode.swift
//  TDT4240-pong
//
//  Created by Petr Zvoníček on 26.01.15.
//  Copyright (c) 2015 Petr Zvoníček. All rights reserved.
//

import SpriteKit

class ScoreNode: SKLabelNode {
    let side: PlayerSide
    var value: Int = 0 {
        didSet {
            self.text = "\(value)"
        }
    }
    
    init(side: PlayerSide) {
        self.side = side
        super.init()
        
        self.fontName = "FFFForward"
        self.fontSize = 50
        self.text = "0"
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func increment() {
        self.value++
    }
    
    func reset() {
        self.value = 0
    }
}
