#import "HelloWorldLayer.h"

@implementation HelloWorldLayer

+ (id)scene {
    
    CCScene *scene = [CCScene node];
    HelloWorldLayer *layer = [HelloWorldLayer node];
    [scene addChild:layer];
    return scene;
    
}

- (id)init {
    
    if ((self=[super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        // Create sprite and add it to the layer
        _ball = [CCSprite spriteWithFile:@"Basketball.png" rect:CGRectMake(0, 0, 52, 52)];
        _ball.position = ccp(100, 300);
        [self addChild:_ball];
        
        // Create a world
        b2Vec2 gravity = b2Vec2(0.0f, -6.0f);
        _world = new b2World(gravity);
        
        // Create edges around the entire screen
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0,0);
        
        b2Body *groundBody = _world->CreateBody(&groundBodyDef);
        b2EdgeShape groundEdge;
        b2FixtureDef boxShapeDef;
        boxShapeDef.shape = &groundEdge;
        
        // Standard method to create a button
        CCMenuItem *jetMenuItem = [CCMenuItemImage
                                    itemFromNormalImage:@"btnCircle.png" selectedImage:@"btnCircleActive.png"
                                    target:self selector:@selector(jetButtonTapped:)];
        jetMenuItem.position = ccp(40, 40);
        jetMenuItem.scale = 0.5;
        CCMenu *jetMenu = [CCMenu menuWithItems:jetMenuItem, nil];
        jetMenu.position = CGPointZero;
        [self addChild:jetMenu z:0];
        
        //Hoop Image
        CCSprite *hoop = [CCSprite spriteWithFile:@"Basketball_Hoop.png"];
        hoop.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:hoop z:0];

        //Hoop Image
        CCSprite *background = [CCSprite spriteWithFile:@"Background.png"];
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:background z:-1];
        
        //wall definitions
        groundEdge.Set(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO, 0));
        groundBody->CreateFixture(&boxShapeDef);
        
        groundEdge.Set(b2Vec2(0,0), b2Vec2(0,winSize.height/PTM_RATIO));
        groundBody->CreateFixture(&boxShapeDef);
        
        groundEdge.Set(b2Vec2(0, winSize.height/PTM_RATIO),
                       b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO));
        groundBody->CreateFixture(&boxShapeDef);
        
        groundEdge.Set(b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO),
                       b2Vec2(winSize.width/PTM_RATIO, 0));
        groundBody->CreateFixture(&boxShapeDef);
        
        // Create ball body and shape
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.position.Set(100/PTM_RATIO, 300/PTM_RATIO);
        ballBodyDef.userData = _ball;
        _body = _world->CreateBody(&ballBodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 26.0/PTM_RATIO;
        
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.2f;
        ballShapeDef.restitution = 0.8f;
        _body->CreateFixture(&ballShapeDef);
        
        [self schedule:@selector(tick:)];
        [self setTouchEnabled:YES];
        [self setAccelerometerEnabled:YES];
    }
    return self;
}

- (void)tick:(ccTime) dt {
    
    _world->Step(dt, 10, 10);
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *ballData = (CCSprite *)b->GetUserData();
            ballData.position = ccp(b->GetPosition().x * PTM_RATIO,
                                    b->GetPosition().y * PTM_RATIO);
            ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }
    
}

//Push Button for Jet

- (void)jetButtonTapped:(id)sender {
    b2Vec2 force = b2Vec2(3, 5);
    _body->ApplyLinearImpulse(force, _body->GetPosition());
}



- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    // Landscape left values
    b2Vec2 gravity(acceleration.x * 5, acceleration.y * 5);
    _world->SetGravity(gravity);
}

- (void)dealloc {
    delete _world;
    _body = NULL;
    _world = NULL;
    [super dealloc];
}

@end