#import "cocos2d.h"
#import "Box2D.h"

#define PTM_RATIO 32.0

@interface HelloWorldLayer : CCLayer {
    b2World *_world;
    
    //Ball 1
    b2Body *_body;
    CCSprite *_ball;
    
    //Ball2
    b2Body *_body2;
    CCSprite *_ball2;
}

+ (id) scene;


@end
