//
//  GameOverLayer.h
//  BubbleBaller
//
//  Created by Brandon Houghton on 5/4/13.
//  Copyright 2013 Brian Broom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor

+(CCScene *) sceneWithWon:(BOOL)won;
- (id)initWithWon:(BOOL)won;

@end
