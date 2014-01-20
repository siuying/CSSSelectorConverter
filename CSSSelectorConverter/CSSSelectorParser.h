#import <Foundation/Foundation.h>

extern NSString* const CSSSelectorParserException;

@interface CSSSelectorParser : NSObject <CPParserDelegate, CPTokeniserDelegate>

- (id<NSObject>)parse:(NSString *)css;

@end

