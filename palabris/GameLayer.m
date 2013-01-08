//
//  GameLayer.m
//  palabris
//
//  Created by ipp on 27.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "AppDelegate.h"
#import "GameOverLayer.h"
#import <stdlib.h>

#pragma mark - GameLayer

@implementation GameLayer

// Helper class method that creates a Scene with the GameLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
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
		
        // ask director for the window size
        size = [[CCDirector sharedDirector] winSize];
        
        // create background
        background = [CCSprite spriteWithFile:@"background320x480.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild: background];
        
        // enable touch responding
        self.isTouchEnabled = YES;
        
        // set score to zero and create score label
        score = 0;
        scoreNameLabel = [CCLabelTTF labelWithString:@"Score: "
                                          dimensions:CGSizeMake(0, 0)
                                          hAlignment:UITextAlignmentCenter
                                            fontName:@"verdana"
                                            fontSize:25.0f];
        [scoreNameLabel setPosition:ccp(size.width - 2*size.width/5, size.height - size.height/30)];
        [self addChild:scoreNameLabel];
        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",score]
                                      dimensions:CGSizeMake(0, 0)
                                      hAlignment:UITextAlignmentCenter
                                        fontName:@"verdana"
                                        fontSize:25.0f];
        [scoreLabel setPosition:ccp(size.width - 1*size.width/10, size.height - size.height/30)];
        [self addChild:scoreLabel];
        
        // initialize wordController
        wordController = [[WordController alloc] init];
        
        // create the fragment label with an initial character
        fragment = [wordController getInitialCharacter];
        [fragment retain];
        fragmentLabel = [CCLabelTTF labelWithString:fragment
                                         dimensions:CGSizeMake(0, 0)
                                         hAlignment:UITextAlignmentCenter
                                           fontName:@"verdana"
                                           fontSize:25.0f];
        [fragmentLabel setPosition:ccp(size.width/2, size.height - size.height/10)];
        [self addChild:fragmentLabel];
        
        // create a bubble on the mid bottom
        bubble = [CCSprite spriteWithFile: @"bubble34.png"];
        bubble.position = ccp(size.width/2, 0);
        [self addChild:bubble];
        
        // create a label with the next character for the bubble
        nextChar = [wordController getNextCharacter:fragment];
        [nextChar retain];
        bubbleChar = [CCLabelTTF labelWithString:nextChar
                                      dimensions:[bubble contentSize]
                                      hAlignment:UITextAlignmentCenter
                                        fontName:@"verdana"
                                        fontSize:18.0f];
        [bubbleChar setPosition:ccp(bubble.contentSize.width/2, 2*bubble.contentSize.height/5)];
        [bubble addChild:bubbleChar];
        
        // schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
		
	}
	return self;
}

- (void) nextFrame:(ccTime)dt {
    // move upwards
    bubble.position = ccp(bubble.position.x, bubble.position.y + 100*dt);
    
    // if upper bound of screen reached
    if (bubble.position.y > size.height + bubble.texture.pixelsHigh/2) {
        [self replaceWithGameOverLayerScene];
    }
}

// enable possible responding to begin of a touch
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // save location where the touch began
    touchBeganLocation = [self convertTouchToNodeSpace: touch];
    
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchEndedlocation = [self convertTouchToNodeSpace: touch];
    
    if (touchEndedlocation.x - touchBeganLocation.x < -10) {
        // if sweeped to the left
        [fragment insertString:nextChar atIndex:0];
        
        // save sweeping direction for further word suggestions in case of game over
        sweepedLeft = true;
        
        [self handleFragmentChange];
    } else if (touchEndedlocation.x - touchBeganLocation.x > 10) {
        // if sweeped to the right
        [fragment appendString:nextChar];
        
        // save sweeping direction for further word suggestions in case of game over
        sweepedLeft = false;
        
        [self handleFragmentChange];
    }
}

// directs the behaviour when a new character is applied to the fragment
- (void) handleFragmentChange {    
    if (![wordController removeNonMatchingWords:fragment]) {
        // if no more possible solutions left
        
        if (sweepedLeft) {
            // append nextChar on the right to get possible solutions
            [fragment release];
            fragment = [NSMutableString stringWithString:[fragmentLabel string]];
            [fragment appendString:nextChar];
        } else {
            // append nextChar on the left to get possible solutions
            [fragment release];
            fragment = [NSMutableString stringWithString:nextChar];
            [fragment appendString:[fragmentLabel string]];
        }
        
        // remove non-matching words for the nextChar added at the right side
        [wordController removeNonMatchingWords:fragment];
        
        [self replaceWithGameOverLayerScene];
    } else if ([wordController isSolution:fragment]) {
        // if the fragment is a valid solution
        
        // display the new fragment
        [fragmentLabel setString:fragment];
        
        // update score
        score += [WordController getScore:fragment];
        [scoreLabel setString:[NSString stringWithFormat:@"%d", score]];
        
        // reset wordController, fragment and result
        [wordController release];
        wordController = [[WordController alloc] init];
        [fragment release];
        fragment = [wordController getInitialCharacter];
        [fragment retain];
        [fragmentLabel setString:fragment];
        
        // get next character and reset the bubble
        [nextChar release];
        nextChar = [wordController getNextCharacter:fragment];
        [nextChar retain];
        [bubbleChar setString:nextChar];
        bubble.position = ccp(size.width/2, 0);
    } else {
        // display the new fragment
        [fragmentLabel setString:fragment];
        
        // get next character and reset the bubble
        [nextChar release];
        nextChar = [wordController getNextCharacter:fragment];
        [nextChar retain];
        [bubbleChar setString:nextChar];
        bubble.position = ccp(size.width/2, 0);
    }
}

// switch to GameOverLayer scene
- (void) replaceWithGameOverLayerScene {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[GameOverLayer scene:wordController.words withScore:score] withColor:ccWHITE]];
}

// register at touch dispatcher for responding to touch input
-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    if (wordController != nil)
        [wordController release];
    if (fragment != nil)
        [fragment release];
    if (nextChar != nil)
        [nextChar release];
    
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
