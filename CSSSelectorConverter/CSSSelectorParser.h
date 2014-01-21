#import <Foundation/Foundation.h>
#import "CSSSelectorGroup.h"

extern NSString* const CSSSelectorParserException;

@class CSSSelectorGroup;

@interface CSSSelectorParser : NSObject <CPParserDelegate, CPTokeniserDelegate>

- (CSSSelectorGroup*)parse:(NSString *)css;

@end

