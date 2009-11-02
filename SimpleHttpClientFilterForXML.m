#import "SimpleHttpClientFilterForXML.h"

@implementation SimpleHttpClientFilterForXML

//----------------------------------------------------------------------------//
#pragma mark -- Internal --
//----------------------------------------------------------------------------//

- (NSData *)trimBlank:(NSData *)data
{
    NSInteger length = [data length];
    NSInteger count = 0;
    for (
        const unsigned char *source = [data bytes];
        count < length;
        source++, count++
    ) {
        if ('<' == *source) {
            break;
        }
    }

    if (0 == count || length - 1 == count) {
        return data;
    }

    return data = [data
        subdataWithRange:NSMakeRange(count, [data length]-count)
    ];
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (id)apply:(NSData *)data
{
    data = [self trimBlank:data];

    NSError *error = nil;
    DDXMLDocument *xmlDocument = [[DDXMLDocument alloc]
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
