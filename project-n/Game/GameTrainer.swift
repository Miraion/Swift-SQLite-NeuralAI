//
//  GameTrainer.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-05.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class GameTrainer : GameController, CLGameTemplate {
    
    typealias Player = GameAIPlayer
    
    required init() {
        super.init(display: false)
    }
    
    func compete (_ entity1: GameAIPlayer, _ entity2: GameAIPlayer) -> CLDualOutcome {
        return play(entity1, entity2)
    }
    
}
