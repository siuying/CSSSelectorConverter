#import "CSSSelectorParser.h"
#import "CSSSelectorGrammar.h"
#import "CSSSelectorTokeniser.h"

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

- (id<NSObject>)parse:(NSString *)css
{
    CPTokenStream *tokenStream = [self.tokeniser tokenise:css];
    return [self.parser parse:tokenStream];
}

#pragma mark - CPParserDelegate

- (id)parser:(CPParser *)parser didProduceSyntaxTree:(CPSyntaxTree *)syntaxTree
{
    return syntaxTree;
}

#pragma mark - CPTokeniserDelegate

- (BOOL)tokeniser:(CPTokeniser *)tokeniser shouldConsumeToken:(CPToken *)token
{
    return YES;
}

@end