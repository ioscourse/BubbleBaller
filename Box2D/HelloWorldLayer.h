#import "cocos2d.h"
#import "Box2D.h"

#define PTM_RATIO 32.0

@interface HelloWorldLayer : CCLayer {
    b2World *_world;
    
    //========= Goal ======
    
    CCSprite *goal;
    
    //========= Ball 1 =========
    b2Body *_body;
    CCSprite *_ball;
    
    //========= Ball2 =========
//    b2Body *_body2;
//    CCSprite *_ball2;
    
    //========= Basket Edges=========
    b2Body *_basketRight;
    b2Body *_basketLeft;
    b2Body *_basketBottom;
    
    //========= Basket Edges Sprite=========
    CCSprite *basketRight;
    CCSprite *basketLeft;
    CCSprite *basketBottom;
    
    //========= Collision arrays: Goal and Ball =========
    NSMutableArray *_goalCollide;
    NSMutableArray *_ballCollide;
}

+ (id) scene;


@end
