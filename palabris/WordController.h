//
//  WordController.h
//  palabris
//
//  Created by ipp on 27.12.12.
//
//

#import <Foundation/Foundation.h>

@interface WordController : NSObject {
    NSMutableArray *words;
}

@property (nonatomic, retain) NSMutableArray *words;

+ (int) getScore: (NSMutableString*) fragment;
- (NSMutableString*) getInitialCharacter;
- (BOOL) removeNonMatchingWords: (NSMutableString*) fragment;
- (BOOL) isSolution: (NSMutableString*) fragment;
- (NSMutableString*) getNextCharacter: (NSMutableString*) fragment;

@end
