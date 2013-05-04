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
        
        //Create Walls Hoop & Buttons
        {
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
        
        
        // Standard method to create a button (left)
        CCMenuItem *jetMenuItem = [CCMenuItemImage
                                   itemFromNormalImage:@"btnCircle.png" selectedImage:@"btnCircleActive.png"
                                   target:self selector:@selector(jetButtonTapped:)];
        jetMenuItem.position = ccp(40, 40);
        jetMenuItem.scale = 0.5;
        CCMenu *jetMenu = [CCMenu menuWithItems:jetMenuItem, nil];
        jetMenu.position = CGPointZero;
        [self addChild:jetMenu z:0];
        
        // Standard method to create a button (right)
        CCMenuItem *jetRightMenuItem = [CCMenuItemImage
                                        itemFromNormalImage:@"btnCircle.png" selectedImage:@"btnCircleActive.png"
                                        target:self selector:@selector(jetRightButtonTapped:)];
        jetRightMenuItem.position = ccp(winSize.width -40, 40);
        jetRightMenuItem.scale = 0.5;
        CCMenu *jetRightMenu = [CCMenu menuWithItems:jetRightMenuItem, nil];
        jetRightMenu.position = CGPointZero;
        [self addChild:jetRightMenu z:0];
        
        //Background Image
        CCSprite *background = [CCSprite spriteWithFile:@"Background.png"];
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:background z:-1];
        
        //Hoop Image
            CCSprite *hoop = [CCSprite spriteWithFile:@"Background.png" rect:CGRectMake(0, 0, 70, 60)];
            hoop.opacity = 175;
            hoop.position = ccp(winSize.width/2, 295);
        [self addChild:hoop z:1];
        }
        
        
        // Create Basketball sprite and add it to the layer
        _ball = [CCSprite spriteWithFile:@"Basketball.png" rect:CGRectMake(0, 0, 52, 52)];
        _ball.position = ccp(100, 300);
        [self addChild:_ball];
        
        // Create Basketball body shape and fixture
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.position.Set(50/PTM_RATIO, 300/PTM_RATIO);
        ballBodyDef.userData = _ball;
        _body = _world->CreateBody(&ballBodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 26.0/PTM_RATIO;
        
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.2f;
        ballShapeDef.restitution = 0.4f;
        _body->CreateFixture(&ballShapeDef);
        
        // Create Hoop blocks sprite and add it to the layer
        _basket = [CCSprite spriteWithFile:@"Background.png" rect:CGRectMake(20, 20, 50, 10)];
        _basket.position = ccp(100, 300);
        [self addChild:_basket];
        
        // Create hoop bottom shape and fixture
        b2BodyDef hoopBottomBodyDef;
        hoopBottomBodyDef.type = b2_staticBody;
        hoopBottomBodyDef.position.Set(((winSize.width/2))/PTM_RATIO, 270/PTM_RATIO);
        hoopBottomBodyDef.userData = _basket;
        _basketBottom = _world->CreateBody(&hoopBottomBodyDef);
        
        b2PolygonShape hoopBottomShape;
        hoopBottomShape.SetAsBox(0.7f, 0.1f);
        
        b2FixtureDef hoopBottomShapeDef;
        hoopBottomShapeDef.shape = &hoopBottomShape;
        hoopBottomShapeDef.density = 1.0f;
        hoopBottomShapeDef.friction = 0.2f;
        hoopBottomShapeDef.restitution = 0.0f;
        _basketBottom->CreateFixture(&hoopBottomShapeDef);
        
        // Create Hoop Left blocks sprite and add it to the layer
        _basket = [CCSprite spriteWithFile:@"Background.png" rect:CGRectMake(20, 20, 10, 50)];
        _basket.position = ccp(100, 300);
        [self addChild:_basket];
        
        // Create hoop Left shape and fixture
        b2BodyDef hoopLeftBodyDef;
        hoopLeftBodyDef.type = b2_staticBody;
        hoopLeftBodyDef.position.Set(((winSize.width/2)-30)/PTM_RATIO, 300/PTM_RATIO);
        hoopLeftBodyDef.userData = _basket;
        _basketLeft = _world->CreateBody(&hoopLeftBodyDef);
        
        b2PolygonShape hoopLeftShape;
        hoopLeftShape.SetAsBox(0.1f, 0.7f);
        
        b2FixtureDef hoopLeftShapeDef;
        hoopLeftShapeDef.shape = &hoopLeftShape;
        hoopLeftShapeDef.density = 1.0f;
        hoopLeftShapeDef.friction = 0.2f;
        hoopLeftShapeDef.restitution = 0.0f;
        _basketLeft->CreateFixture(&hoopLeftShapeDef);
        
        // Create Hoop Right blocks sprite and add it to the layer
        _basket = [CCSprite spriteWithFile:@"Background.png" rect:CGRectMake(20, 20, 10, 50)];
        _basket.position = ccp(100, 300);
        [self addChild:_basket];
        
        // Create hoop Right shape and fixture
        b2BodyDef hoopRightBodyDef;
        hoopRightBodyDef.type = b2_staticBody;
        hoopRightBodyDef.position.Set(((winSize.width/2)+30)/PTM_RATIO, 300/PTM_RATIO);
        hoopRightBodyDef.userData = _basket;
        _basketRight = _world->CreateBody(&hoopRightBodyDef);
        
        b2PolygonShape hoopRightShape;
        hoopRightShape.SetAsBox(0.1f, 0.7f);
        
        b2FixtureDef hoopRightShapeDef;
        hoopRightShapeDef.shape = &hoopRightShape;
        hoopRightShapeDef.density = 1.0f;
        hoopRightShapeDef.friction = 0.2f;
        hoopRightShapeDef.restitution = 0.0f;
        _basketRight->CreateFixture(&hoopRightShapeDef);


        
        //
        // Create Basketball Two sprite and add it to the layer
        _ball2 = [CCSprite spriteWithFile:@"Basketball.png" rect:CGRectMake(0, 0, 52, 52)];
        _ball2.position = ccp(100, 300);
        [self addChild:_ball2];
        
        // Create Basketball two body shape and fixture
        b2BodyDef ball2BodyDef;
        ball2BodyDef.type = b2_dynamicBody;
        ball2BodyDef.position.Set(50/PTM_RATIO, 300/PTM_RATIO);
        ball2BodyDef.userData = _ball2;
        _body2 = _world->CreateBody(&ball2BodyDef);
        
        b2FixtureDef ball2ShapeDef;
        ball2ShapeDef.shape = &circle;
        ball2ShapeDef.density = 1.0f;
        ball2ShapeDef.friction = 0.2f;
        ball2ShapeDef.restitution = 0.4f;
        _body2->CreateFixture(&ball2ShapeDef);
        
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
            CCSprite *sprite = (CCSprite *)b->GetUserData();
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                  b->GetPosition().y * PTM_RATIO);
            sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }
    
}

//Push Button for Jet

- (void)jetButtonTapped:(id)sender {
    b2Vec2 force = b2Vec2(2, 5);
    _body->ApplyLinearImpulse(force, _body->GetPosition());
    _body2->ApplyLinearImpulse(force, _body2->GetPosition());
}

//Push Button Right for Jet

- (void)jetRightButtonTapped:(id)sender {
    b2Vec2 force = b2Vec2(-2, 5);
    _body->ApplyLinearImpulse(force, _body->GetPosition());
    _body2->ApplyLinearImpulse(force, _body2->GetPosition());
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    // Portrait values
    b2Vec2 gravity(acceleration.x * 5, acceleration.y * 5);
    _world->SetGravity(gravity);
    
}


- (void)dealloc {
    delete _world;
    _body = NULL;
    _body2 = NULL;
    _world = NULL;
    _basketBottom = NULL;
    [super dealloc];
}

@end