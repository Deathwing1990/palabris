//
//  WordController.m
//  palabris
//
//  Created by ipp on 27.12.12.
//
//

#import "WordController.h"
#import <stdlib.h>

@implementation WordController

@synthesize words;

// calculates the score of a given word
+ (int) getScore: (NSMutableString*) word {
    return [self factorial:[word length]];
}


// calculates the factorial of a given positive integer
+ (unsigned int) factorial: (unsigned int) number {
    int result;
    if (number == 0)
        result = 1;
    else
        result = number * [self factorial:number - 1];
    
    return result;
}

- (id) init {
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        // read from the dict file
        NSString *filename = [[NSBundle mainBundle] pathForResource:@"dict" ofType:@"txt"];
        NSError *error = nil;
        NSMutableString *filecontent = [[NSMutableString alloc] initWithContentsOfFile:filename
                                                                encoding:NSUTF8StringEncoding
                                                                   error:&error];
                
        // parse content into array
        words = [[filecontent componentsSeparatedByString:@"\n"] mutableCopy];
        
        // filecontent is no longer needed
        [filecontent release];
        
        // transform all words to uppercase
        for (int i = 0; i < [words count]; i++) {
            NSMutableString* wordInUpperCase = [NSMutableString stringWithString:[[words objectAtIndex:i] uppercaseString]];
            [words replaceObjectAtIndex:i withObject:wordInUpperCase];
        }
    }
    
    return self;
}

// creates a random character to start with
- (NSMutableString*) getInitialCharacter {
    NSMutableString* initialChar = nil;
    
    // calculate random number between 0 and 28 (A-Z plus Ä, Ö, Ü)
    int random = arc4random() % 29;

    if (random == 26) {
        initialChar = [NSMutableString stringWithString:@"Ä"];
    } else if (random == 27) {
        initialChar = [NSMutableString stringWithString:@"Ö"];
    } else if (random == 28) {
        initialChar = [NSMutableString stringWithString:@"Ü"];
    } else {
        initialChar = [NSMutableString stringWithFormat:@"%c", 'A' + random];
    }
    
    // remove words that don't contain this character
    [self removeNonMatchingWords:initialChar];
    
    return initialChar;
}

// removes all words from array that don't contain the given fragment
// returns false if there are no more words left, else true
- (BOOL) removeNonMatchingWords: (NSMutableString*) fragment {
    // deep copy of array as backup
    NSMutableArray *backup = [[NSMutableArray alloc] initWithArray:words copyItems:YES];
    
    // iterate and remove all strings that don't contain this fragment
    for (int i = 0; i < [words count]; i++) {
        NSMutableString* word = [words objectAtIndex:i];
        
        // tries to return the range of the given fragment
        NSRange textRange = [word rangeOfString:fragment];
        
        // if the fragment is not found, a NSNotFound enum is returned as location
        if (textRange.location == NSNotFound) {
            // remove the word from the array and decrement index to avoid skipping one object
            [words removeObjectAtIndex:i--];
        }
    }
    
    BOOL elementsLeft;
    if ([words count] < 1) {
        elementsLeft = false;
        
        // reset array to state before
        [words release];
        words = [backup copy];
        
    } else {
        elementsLeft = true;
    }
    [backup release];
    
    return elementsLeft;
}

// returns true if fragment is a solution, else false
- (BOOL) isSolution:(NSMutableString *)fragment {
    for (NSMutableString* word in words) {
        // if match found
        if ([word isEqualToString:fragment])
            
            return true;
    }
    
    // if no matching word found
    return false;
}

// chooses the next character to add to the fragment randomly from a remaining word
- (NSMutableString*) getNextCharacter:(NSMutableString *)fragment {
    // get a random word from array
    int random = arc4random() % [words count];
    NSMutableString* word = [words objectAtIndex:random];
    
    // get the range of the fragment within the word
    NSRange range = [word rangeOfString:fragment];
    
    NSMutableString* nextCharacter;
    if (range.location == 0) {
        // if the fragment is at the beginning of the word, take the char after the fragment
        nextCharacter = [NSMutableString stringWithString:[word substringWithRange:NSMakeRange(range.length, 1)]];
    } else if (range.location + range.length >= [word length]) {
        // if the fragment is at the end of the word, take the char before the fragment
        nextCharacter = [NSMutableString stringWithString:[word substringWithRange:NSMakeRange(range.location - 1, 1)]];
    } else {
        // if the fragment is in the mid of the word, we have to choose randomly whether to take the char before or after
        random = arc4random() % 2;
        if (random == 0) {
            // take the char before the fragment
            nextCharacter = [NSMutableString stringWithString:[word substringWithRange:NSMakeRange(range.location - 1, 1)]];
        } else {
            // take the char after the fragment
            nextCharacter = [NSMutableString stringWithString:[word substringWithRange:NSMakeRange(range.location + range.length, 1)]];
        }
    }
    
    return nextCharacter;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    if (words != nil)
        [words release];
    
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
