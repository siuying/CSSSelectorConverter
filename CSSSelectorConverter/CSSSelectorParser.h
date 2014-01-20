#import <Foundation/Foundation.h>

@interface CSSSelectorParser : NSObject <CPParserDelegate, CPTokeniserDelegate>

- (id<NSObject>)parse:(NSString *)css;

@end

