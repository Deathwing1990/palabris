//
//  GameLayer.h
//  palabris
//
//  Created by ipp on 27.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "WordController.h"

@interface GameLayer : CCLayer {
    CGSize size;
    CCSprite *background;
    CCSprite *bubble;
    CCLabelTTF *fragmentLabel;
    CCLabelTTF *bubbleChar;
    CGPoint touchBeganLocation;
    WordController *wordController;
    NSMutableString *fragment;
    NSString *nextChar;
    int score;
    CCLabelTTF *scoreLabel;
    CCLabelTTF *scoreNameLabel;
    BOOL sweepedLeft;
}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

@end
