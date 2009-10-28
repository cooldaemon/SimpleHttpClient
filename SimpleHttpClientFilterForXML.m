#import "SimpleHttpClientFilterForXML.h"

@implementation SimpleHttpClientFilterForXML

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (id)apply:(NSData *)data
{
    NSError *error = nil;

    NSXMLDocument *xmlDocument = [[DDXMLDocument alloc]
        initWithData:data
             options:XML_PARSE_RECOVER
               error:&error
    ];
    [xmlDocument autorelease];

    if (error) {
        return nil;
    }

    return xmlDocument;
}

@end
