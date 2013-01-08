//
//  MenuLayer.m
//  palabris
//
//  Created by ipp on 27.12.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "MenuLayer.h"
#import "GameLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - MenuLayer

// MenuLayer implementation
@implementation MenuLayer

// Helper class method that creates a Scene with the MenuLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
        // create menu items
        CCMenuItemFont *startGameItem = [CCMenuItemFont itemWithString:@"Start Game"
                                                                target:self
                                                              selector:@selector(onStartGame)];
        
        CCMenuItemFont *registerItem = [CCMenuItemFont itemWithString:@"Register"
                                                               target:self
                                                             selector:@selector(onRegister)];
        
        CCMenuItemFont *highscoreItem = [CCMenuItemFont itemWithString:@"Highscore"
                                                                target:self
                                                              selector:@selector(onHighscore)];
        
        
        // create menu with items and align them
        mainMenu = [CCMenu menuWithItems:startGameItem, registerItem, highscoreItem, nil];
        [mainMenu alignItemsVertically];
        
        // add menu to layer
        [self addChild:mainMenu];
		
	}
	return self;
}

-(void) onStartGame
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[GameLayer scene] withColor:ccWHITE]];
}

-(void) onRegister {
    
}

-(void) onHighscore {
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
