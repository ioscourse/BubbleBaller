#import "cocos2d.h"
#import "Box2D.h"

#define PTM_RATIO 32.0

@interface HelloWorldLayer : CCLayer {
    b2World *_world;
    b2Body *_body;
    b2Body *_block;
    CCSprite *_ball;
    CCSprite *_blockSprite;
    CCSprite *_hoopLeft;
}

+ (id) scene;


@end
