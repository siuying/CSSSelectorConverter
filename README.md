# CSSToXPathConverter

A CSS Selector to XPath Selector for Objective-C. 

Support mostly used subset of  [CSS Selector Level 3](http://www.w3.org/TR/css3-selectors/).

## Usage

```
#import "CSSSelectorConverter.h"

CSSToXPathConverter* converter = [[CSSToXPathConverter alloc] init];
[converter xpathWithCSS:@"p" error:nil];
// => "//p"

[converter xpathWithCSS:@"p.intro" error:nil];
// => "//p[contains(concat(' ', normalize-space(@class), ' '), ' intro ')]"
```

## Status

It supports following CSS Selectors:

```
*                                "//*"
p                                "//p"
p.intro                          "//p[contains(concat(' ', normalize-space(@class), ' '), ' intro ')]"
p#apple                          "//p[@id = 'apple']"
p *                              "//p//*"
p > *                            "//p/*"
H1 + P                           "//H1/following-sibling::*[1]/self::P"
H1 ~ P                           "//H1/following-sibling::P"
ul, ol                           "//ul | //ol"
p[align]                         "//p[@align]"
p[class~="intro"]                "//p[contains(concat(\" \", @class, \" \"),concat(\" \", 'intro', \" \"))]"
```

It supports following pseduo classes:

- first-child
- last-child
- first-of-type
- last-of-type
- only-child
- only-of-type
- empty
- nth-child()


## License

MIT License. See License.txt.