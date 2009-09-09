#import "SimpleHttpClientFilterForXML.h"

@implementation SimpleHttpClientFilterForXML

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

    NSXMLDocument *xmlDocument = [[DDXMLDocument alloc]
        initWithData:data
             options:0
               error:&error
    ];
    [xmlDocument autorelease];

    if (error) {
        return nil;
    }

    return xmlDocument;
}

@end
