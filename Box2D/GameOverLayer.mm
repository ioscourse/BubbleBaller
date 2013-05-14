//
//  GameOverLayer.m
//  BubbleBaller
//
//  Created by Brandon Houghton on 5/4/13.
//  Copyright 2013 Brian Broom. All rights reserved.
//

#import "GameOverLayer.h"
#import "HelloWorldLayer.h"

@implementation GameOverLayer

+(CCScene *) sceneWithWon:(BOOL)won {
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithWon:won] autorelease];
    [scene addChild: layer];
    return scene;
}

- (id)initWithWon:(BOOL)won {
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        //Background Image
        CCSprite *background = [CCSprite spriteWithFile:@"Background.png"];
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:background z:-1];

        NSString * message;
        if (won) {
            message = @"You Won!";
        } else {
            message = @"You Lose :[";
        }
        
        // Create replay button
        CCMenuItem *replayMenuItem = [CCMenuItemImage
        itemWithNormalImage:@"btnReplay.png" selectedImage:@"btnReplay.png"
        target:self selector:@selector(replayButtonTapped:)];
        replayMenuItem.position = ccp(((contentSize_.width/2)+1), winSize.height/2.5);
       // basketRight.position = ccp(((contentSize_.width/2)+30), 300);
//        replayMenuItem.scaleX=.5;
//        replayMenuItem.scaleY=.5;
        replayMenuItem.scale = 1;
        CCMenu *replayMenu = [CCMenu menuWithItems:replayMenuItem, nil];
        replayMenu.position = CGPointZero;
        [self addChild:replayMenu z:0];
        
        // Create next level button
//        CCMenuItem *nextLevelMenuItem = [CCMenuItemImage
//                                      itemFromNormalImage:@"btnPlay-Iphone.png" selectedImage:@"btnPlay-Iphone.png"
//                                      target:self selector:@selector(nextLevelButtonTapped:)];
//        nextLevelMenuItem.position = ccp(((contentSize_.width/2)+1), winSize.height/3);
//        // basketRight.position = ccp(((contentSize_.width/2)+30), 300);
//        nextLevelMenuItem.scaleX=.5;
//        nextLevelMenuItem.scaleY=.5;
//        //replayMenuItem.scale = 0.5;
//        CCMenu *nextLevelMenu = [CCMenu menuWithItems:nextLevelMenuItem, nil];
//        nextLevelMenu.position = CGPointZero;
//        [self addChild:nextLevelMenu z:0];
//        
//        // Create menu button
//        CCMenuItem *menuMenuItem = [CCMenuItemImage
//                                         itemFromNormalImage:@"btnPlay-Iphone.png" selectedImage:@"btnPlay-Iphone.png"
//                                         target:self selector:@selector(MenuButtonTapped:)];
//        menuMenuItem.position = ccp(((contentSize_.width/2)+1), winSize.height/5);
//        // basketRight.position = ccp(((contentSize_.width/2)+30), 300);
//        menuMenuItem.scaleX=.5;
//        menuMenuItem.scaleY=.5;
//        //replayMenuItem.scale = 0.5;
//        CCMenu *Menu = [CCMenu menuWithItems:menuMenuItem, nil];
//        Menu.position = CGPointZero;
//        [self addChild:Menu z:0];
//        
        
        
        //CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
        label.color = ccc3(0,0,0);
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
        
        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:3],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             //[[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
         }],
          nil]];
    }
    return self;
}
- (void)replayButtonTapped:(id)sender {
    //replays level
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionJumpZoom transitionWithDuration:0.5f scene:[HelloWorldLayer scene]]];
    
}

//- (void)nextLevelButtonTapped:(id)sender {
//    //goes to next level
//    [[CCDirector sharedDirector] replaceScene:
//	 [CCTransitionJumpZoom transitionWithDuration:0.5f scene:[HelloWorldLayer scene]]];
//    
//}
//
//- (void)MenuButtonTapped:(id)sender {
//    //goes to menu
//    //[[CCDirector sharedDirector] replaceScene:CCWaves3D actionWithWaves:3 amplitude:float grid:wint_t duration:3;


@end
