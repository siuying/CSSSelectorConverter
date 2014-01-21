#import "CSSSelectorParser.h"
#import "CSSSelectorGrammar.h"
#import "CSSSelectorTokeniser.h"

NSString* const CSSSelectorParserException = @"CSSSelectorParserException";

enum {
    CSSSelectorParserRuleQuotedString = 1
};

@interface CSSSelectorParser ()
@property (nonatomic, strong) CSSSelectorGrammar* grammar;
@property (nonatomic, strong) CSSSelectorTokeniser *tokeniser;
@property (nonatomic, strong) CPParser* parser;
@end

@implementation CSSSelectorParser

- (id)init {
    self = [super init];
    self.tokeniser = [[CSSSelectorTokeniser alloc] init];
    self.tokeniser.delegate = self;
    self.grammar = [[CSSSelectorGrammar alloc] init];
    self.parser = [CPLALR1Parser parserWithGrammar:self.grammar];
    self.parser.delegate = self;
    return self;
}

- (CSSSelectorGroup*)parse:(NSString *)css
{
    CPTokenStream *tokenStream = [self.tokeniser tokenise:css];
    return [self.parser parse:tokenStream];
}

#pragma mark - CPParserDelegate

- (id)parser:(CPParser *)parser didProduceSyntaxTree:(CPSyntaxTree *)syntaxTree
{
    switch ([[syntaxTree rule] tag]) {
        case CSSSelectorParserRuleQuotedString: {
            NSArray* children = [syntaxTree children];
            if ([children count] == 1 && [children[0] isQuotedToken]) {
                return [children[0] content];
            } else {
                [NSException raise:CSSSelectorParserException format:@"unexpected token: should be a quoted token, now: %@", syntaxTree];
            }
        }
            break;
            
        default:
            break;
    }
    return syntaxTree;
}

#pragma mark - CPTokeniserDelegate

- (BOOL)tokeniser:(CPTokeniser *)tokeniser shouldConsumeToken:(CPToken *)token
{
    return YES;
}

@end