#import "HelloWorldLayer.h"
#import "GameOverLayer.h"
#import "SimpleAudioEngine.h"

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
                                       itemWithNormalImage:@"btnCircle.png" selectedImage:@"btnCircleActive.png"
                                       target:self selector:@selector(jetButtonTapped:)];
            jetMenuItem.position = ccp(40, 40);
            jetMenuItem.scale = 0.5;
            CCMenu *jetMenu = [CCMenu menuWithItems:jetMenuItem, nil];
            jetMenu.position = CGPointZero;
            [self addChild:jetMenu z:0];
            
            // Standard method to create a button (right)
            CCMenuItem *jetRightMenuItem = [CCMenuItemImage
                                            itemWithNormalImage:@"btnCircle.png" selectedImage:@"btnCircleActive.png"
                                            target:self selector:@selector(jetRightButtonTapped:)];
            jetRightMenuItem.position = ccp(winSize.width -40, 40);
            jetRightMenuItem.scale = 0.5;
            CCMenu *jetRightMenu = [CCMenu menuWithItems:jetRightMenuItem, nil];
            jetRightMenu.position = CGPointZero;
            [self addChild:jetRightMenu z:0];
            
            //Toggle Pause/Play
            CCMenuItem *toggleItem = [CCMenuItemImage
                                       itemWithNormalImage:@"btnPause.png" selectedImage:@"btnPause.png"
                                       target:self selector:@selector(toggleTapped:)];
            toggleItem.position = ccp((winSize.width-30), (winSize.height-30));
            toggleItem.scale = 0.5;
            CCMenu *toggleMenu = [CCMenu menuWithItems:toggleItem, nil];
            toggleMenu.position = CGPointZero;
            [self addChild:toggleMenu z:0];
            
            //Background Image
            CCSprite *background = [CCSprite spriteWithFile:@"Background.png"];
            background.position = ccp(winSize.width/2, winSize.height/2);
            [self addChild:background z:-1];
            
            //Hoop Image
            CCSprite *hoop = [CCSprite spriteWithFile:@"Hoop.png" rect:CGRectMake(0, 0, 150, 150)];
            hoop.position = ccp(winSize.width/2, 295);
            [self addChild:hoop z:0];
            
            //Hoop Front Image
            CCSprite *hoopFront = [CCSprite spriteWithFile:@"HoopFront.png" rect:CGRectMake(0, 0, 150, 56)];
            hoopFront.position = ccp(winSize.width/2, 250);
            [self addChild:hoopFront z:5];
        }
        
        
        // Create Goal sprite and add it to the layer
        goal = [CCSprite spriteWithFile:@"transparent.png" rect:CGRectMake(25, 25, 1, 1)];
        goal.position = ccp(winSize.width/2, 250);
        [self addChild:goal z:2];
        
        // Create Basketball sprite and add it to the layer
        _ball = [CCSprite spriteWithFile:@"Basketball.png" rect:CGRectMake(0, 0, 52, 52)];
        _ball.position = ccp(52, 300);
        [self addChild:_ball];
        
        // Create Basketball body shape and fixture
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.position.Set(52/PTM_RATIO, 300/PTM_RATIO);
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
        
        //========= Create Hoop left bottom sprite and add it to the layer =========
        basketBottom = [CCSprite spriteWithFile:@"transparent.png" rect:CGRectMake(20, 20, 5, 5)];
        basketBottom.position = ccp(((winSize.width/2)-20), 240);
        [self addChild:basketBottom];
        
        //========= Create hoop left bottom shape and fixture =========
        b2BodyDef hoopBottomBodyDef;
        hoopBottomBodyDef.type = b2_staticBody;
        hoopBottomBodyDef.position.Set(((winSize.width/2)-20)/PTM_RATIO, 240/PTM_RATIO);
        hoopBottomBodyDef.userData = basketBottom;
        _basketBottom = _world->CreateBody(&hoopBottomBodyDef);
        
        b2PolygonShape hoopBottomShape;
        hoopBottomShape.SetAsBox(0.1f, 0.1f);
        
        b2FixtureDef hoopBottomShapeDef;
        hoopBottomShapeDef.shape = &hoopBottomShape;
        hoopBottomShapeDef.density = 1.0f;
        hoopBottomShapeDef.friction = 0.2f;
        hoopBottomShapeDef.restitution = 0.0f;
        _basketBottom->CreateFixture(&hoopBottomShapeDef);
        
        //========= Create Hoop right bottom sprite and add it to the layer =========
        basketRightBottom = [CCSprite spriteWithFile:@"transparent.png" rect:CGRectMake(20, 20, 5, 5)];
        basketRightBottom.position = ccp(((winSize.width/2)+20), 240);
        [self addChild:basketRightBottom];
        
        //========= Create hoop right bottom shape and fixture =========
        b2BodyDef hoopRightBottomBodyDef;
        hoopRightBottomBodyDef.type = b2_staticBody;
        hoopRightBottomBodyDef.position.Set(((winSize.width/2)+20)/PTM_RATIO, 240/PTM_RATIO);
        hoopRightBottomBodyDef.userData = basketBottom;
        _basketRightBottom = _world->CreateBody(&hoopRightBottomBodyDef);
        
        b2PolygonShape hoopRightBottomShape;
        hoopRightBottomShape.SetAsBox(0.1f, 0.1f);
        
        b2FixtureDef hoopRightBottomShapeDef;
        hoopRightBottomShapeDef.shape = &hoopBottomShape;
        hoopRightBottomShapeDef.density = 1.0f;
        hoopRightBottomShapeDef.friction = 0.2f;
        hoopRightBottomShapeDef.restitution = 0.0f;
        _basketRightBottom->CreateFixture(&hoopRightBottomShapeDef);
        
        //========= Create Hoop Left blocks sprite and add it to the layer =========
        basketLeft = [CCSprite spriteWithFile:@"transparent.png" rect:CGRectMake(20, 20, 5, 5)];
        basketLeft.position = ccp(100, 275);
        [self addChild:basketLeft];
        
        //========= Create hoop Left shape and fixture =========
        b2BodyDef hoopLeftBodyDef;
        hoopLeftBodyDef.type = b2_staticBody;
        hoopLeftBodyDef.position.Set(((contentSize_.width/2)-30)/PTM_RATIO, 275/PTM_RATIO);
        hoopLeftBodyDef.userData = basketLeft;
        _basketLeft = _world->CreateBody(&hoopLeftBodyDef);
        
        b2PolygonShape hoopLeftShape;
        hoopLeftShape.SetAsBox(0.1f, 0.1f);
        
        b2FixtureDef hoopLeftShapeDef;
        hoopLeftShapeDef.shape = &hoopLeftShape;
        hoopLeftShapeDef.density = 1.0f;
        hoopLeftShapeDef.friction = 0.2f;
        hoopLeftShapeDef.restitution = 0.0f;
        _basketLeft->CreateFixture(&hoopLeftShapeDef);
        
        //========= Create Hoop Right Blocks Sprite and add it to the layer =========
        basketRight = [CCSprite spriteWithFile:@"transparent.png" rect:CGRectMake(20, 20, 5, 5)];
        basketRight.position = ccp(((contentSize_.width/2)+30), 275);
        [self addChild:basketRight];
        
        //========= Create hoop Right shape and fixture =========
        b2BodyDef hoopRightBodyDef;
        hoopRightBodyDef.type = b2_staticBody;
        hoopRightBodyDef.position.Set(((contentSize_.width/2)+30)/PTM_RATIO, 275/PTM_RATIO);
        hoopRightBodyDef.userData = _basketRight;
        _basketRight = _world->CreateBody(&hoopRightBodyDef);
        
        b2PolygonShape hoopRightShape;
        hoopRightShape.SetAsBox(0.1f, 0.1f);
        
        b2FixtureDef hoopRightShapeDef;
        hoopRightShapeDef.shape = &hoopRightShape;
        hoopRightShapeDef.density = 1.0f;
        hoopRightShapeDef.friction = 0.2f;
        hoopRightShapeDef.restitution = 0.0f;
        _basketRight->CreateFixture(&hoopRightShapeDef);
        
        //========= Create Basketball Two sprite and add it to the layer =========
        //        _ball2 = [CCSprite spriteWithFile:@"Basketball.png" rect:CGRectMake(0, 0, 52, 52)];
        //        _ball2.position = ccp(100, 300);
        //        [self addChild:_ball2];
        //
        //        b2BodyDef ball2BodyDef;
        //        ball2BodyDef.type = b2_dynamicBody;
        //        ball2BodyDef.position.Set(50/PTM_RATIO, 300/PTM_RATIO);
        //        ball2BodyDef.userData = _ball2;
        //        _body2 = _world->CreateBody(&ball2BodyDef);
        //
        //        b2FixtureDef ball2ShapeDef;
        //        ball2ShapeDef.shape = &circle;
        //        ball2ShapeDef.density = 1.0f;
        //        ball2ShapeDef.friction = 0.2f;
        //        ball2ShapeDef.restitution = 0.4f;
        //        _body2->CreateFixture(&ball2ShapeDef);
        
        //========= Adding Collision for Ball and Goal Sprite =========
        
        _goalCollide = [[NSMutableArray alloc] init];
        _ballCollide = [[NSMutableArray alloc] init];
        
        
        
        //========= End Added Sprites and Bodies ============
        
        [self schedule:@selector(tick:)];
        [self setTouchEnabled:YES];
        [self setAccelerometerEnabled:YES];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"TinySeal.caf" loop:YES];
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
    
    if (CGRectIntersectsRect([goal boundingBox], [_ball boundingBox])) {
        CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }
    
    
}


//Push Button for Jet

- (void)jetButtonTapped:(id)sender {
    b2Vec2 force = b2Vec2(2, 5);
    _body->ApplyLinearImpulse(force, _body->GetPosition());
    [[SimpleAudioEngine sharedEngine] playEffect:@"Bubbles.aiff"];
    //_body2->ApplyLinearImpulse(force, _body2->GetPosition());
}

//Push Button Right for Jet

- (void)jetRightButtonTapped:(id)sender {
    b2Vec2 force = b2Vec2(-2, 5);
    _body->ApplyLinearImpulse(force, _body->GetPosition());
    [[SimpleAudioEngine sharedEngine] playEffect:@"Bubbles.aiff"];
    // _body2->ApplyLinearImpulse(force, _body2->GetPosition());
}

//Pause Button

- (void)toggleTapped:(id)sender

{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Paused" message:@"Press the button to..." delegate:self cancelButtonTitle:@"Resume" otherButtonTitles:nil];
    [alert show];
    [[CCDirector sharedDirector] pause];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
	[[CCDirector sharedDirector] resume];
    
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    // Portrait values
    b2Vec2 gravity(acceleration.x * 5, acceleration.y * 5);
    _world->SetGravity(gravity);
    
}


- (void)dealloc {
    
    delete _world;
    _body = NULL;
    //_body2 = NULL;
    _world = NULL;
    _basketBottom = NULL;
    _basketLeft = NULL;
    _basketRight = NULL;
    
    [super dealloc];
}

@end