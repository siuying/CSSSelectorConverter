/*
 podfile-start
 platform :osx, '10.9'
 pod 'CSSSelectorConverter', :local => '/Users/siuying/workspace/opensource/CSSSelectorConverter'
 podfile-end
 */

#include <stdio.h>
@import Foundation;
#import "CSSSelectorConverter.h"
#import "CSSSelectorGrammar.h"
#import "CPLALR1Parser.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if (argc >= 3)
        {
            NSString* grammaFile = [[NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding] stringByExpandingTildeInPath];
            NSString* outputFile = [[NSString stringWithCString:argv[2] encoding:NSASCIIStringEncoding] stringByExpandingTildeInPath];
            CSSSelectorGrammar* grammar = [[CSSSelectorGrammar alloc] initWithPath:grammaFile];
            CPLALR1Parser* parser1 = [CPLALR1Parser parserWithGrammar:grammar];
            [NSKeyedArchiver archiveRootObject:@{@"parser" : parser1}
                                        toFile:outputFile];
        }
        else
        {
            NSLog(@"Usage: CSSSelectorParserGenerator <gramma file> <output path>");
        }
    }
}

