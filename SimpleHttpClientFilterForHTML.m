#import "SimpleHttpClientFilterForHTML.h"

@implementation SimpleHttpClientFilterForHTML

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//
- (id)init
{
    if (![super init]) {
        return nil;
    }

    return self;
}

- (void)dealloc
{
    [super dealloc];
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (id)apply:(NSData *)data
{
    NSError *error = nil;

    NSXMLDocument *htmlDocument = [[DDXMLDocument alloc]
        initWithHTMLData:data
                 options:HTML_PARSE_NOWARNING | HTML_PARSE_NOERROR
                   error:&error
    ];
    [htmlDocument autorelease];

    if (error) {
        return nil;
    }

    return htmlDocument;
}

@end
