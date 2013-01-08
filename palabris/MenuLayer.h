//
//  MenuLayer.h
//  palabris
//
//  Created by ipp on 27.12.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// MenuLayer
@interface MenuLayer : CCLayer {
    CCMenu *mainMenu;
    
}

// returns a CCScene that contains the MenuLayer as the only child
+(CCScene *) scene;

@end
