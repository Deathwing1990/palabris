//
//  GameOverLayer.m
//  palabris
//
//  Created by ipp on 27.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "AppDelegate.h"
#import "GameLayer.h"
#import <stdlib.h>

#pragma mark - GameOverLayer

@implementation GameOverLayer

// Helper class method that creates a Scene with the GameOverLayer as the only child.
+(CCScene *) scene: (NSMutableArray*) newWords withScore:(int) newScore
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverLayer *layer = [GameOverLayer nodeWithWords:newWords andScore:newScore];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+ (id) nodeWithWords: (NSMutableArray*) newWords andScore: (int) newScore {
    return [[[self alloc] initWithWords:newWords andScore:newScore] autorelease];
}

// on "init" you need to initialize your instance
-(id) initWithWords: (NSMutableArray*) newWords andScore: (int) newScore
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        // save words and score
        if (words != nil)
            [words release];
        words = [newWords copy];
        score = newScore;
        
        // ask director for the window size
        size = [[CCDirector sharedDirector] winSize];
		
        // create title
        gameOverLabel = [CCLabelTTF labelWithString:@"Game Over"
                                         dimensions:CGSizeMake(0, 0)
                                         hAlignment:UITextAlignmentCenter
                                           fontName:@"verdana"
                                           fontSize:35.0f];
        [gameOverLabel setPosition:ccp(size.width/2, size.height - size.height/15)];
        [self addChild:gameOverLabel];
        
        // create score display
        NSMutableString *scoreString = [NSMutableString stringWithString:@"Score: "];
        [scoreString appendString:[NSString stringWithFormat:@"%d", score]];
        scoreLabel = [CCLabelTTF labelWithString:scoreString
                                      dimensions:CGSizeMake(0, 0)
                                      hAlignment:UITextAlignmentCenter
                                        fontName:@"verdana"
                                        fontSize:25.0f];
        [scoreLabel setPosition:ccp(size.width/2, size.height - size.height/7)];
        [self addChild:scoreLabel];
        
        // create displaying of maximum 5 possible solutions
        NSMutableString *wordsString = [NSMutableString stringWithString:@"Solutions would have been:"];
        int numberOfWords = min([words count], 5);
        for (int i = 0; i < numberOfWords; i++) {
            [wordsString appendString:@"\n"];
            [wordsString appendString:[words objectAtIndex:i]];
        }
        wordListLabel = [CCLabelTTF labelWithString:wordsString
                                         dimensions:CGSizeMake(0, 0)
                                         hAlignment:UITextAlignmentCenter
                                           fontName:@"verdana"
                                           fontSize:15.0f];
        [wordListLabel setPosition:ccp(size.width/2, size.height - size.height/3)];
        [self addChild:wordListLabel];
        
        // create retry item
        CCMenuItemFont *retryItem = [CCMenuItemFont itemWithString:@"Retry"
                                                            target:self
                                                          selector:@selector(onRetry)];
        CCMenu *menu = [CCMenu menuWithItems:retryItem, nil];
        [menu setPosition:ccp(size.width - size.width/3, size.height/15)];
        [self addChild:menu];
        		
	}
	return self;
}


- (void) onRetry {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[GameLayer scene] withColor:ccWHITE]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    if (words != nil)
        [words release];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
