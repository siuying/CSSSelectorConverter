/*
podfile-start
platform :osx, '10.9'
pod 'CSSSelectorConverter', :local => '/Users/siuying/workspace/opensource/CSSSelectorConverter'
podfile-end
*/
@import Foundation;
#import "CSSSelectorParser.h"

int main(int argc, char *argv[]) {
    @autoreleasepool {
        if (argc >= 2)
        {
            CSSSelectorParser* parser = [[CSSSelectorParser alloc] init];
            [NSKeyedArchiver archiveRootObject:@{@"parser" : parser}
                                        toFile:[[NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding] stringByExpandingTildeInPath]];
        }
        else
        {
            NSLog(@"Usage: ParserGenerator <output path>");
        }
    }
}
