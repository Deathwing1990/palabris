//
//  GameOverLayer.h
//  palabris
//
//  Created by ipp on 27.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayer {
    NSMutableArray *words;
    int score;
    CGSize size;
    CCLabelTTF *gameOverLabel;
    CCLabelTTF *scoreLabel;
    CCLabelTTF *wordListLabel;
}

// returns a CCScene that contains the GameOverLayer as the only child
+(CCScene *) scene: (NSMutableArray*) newWords withScore:(int) newScore;

@end
