#import "SimpleHttpClientFilterForJSON.h"

#import "NSDictionary+BSJSONAdditions.h"
#import "NSArray+BSJSONAdditions.h"

@implementation SimpleHttpClientFilterForJSON

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (id)apply:(NSData *)data
{
    NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];

    for (NSInteger i = 0; i < [jsonString length]; i++) {
        unichar nextChar = [jsonString characterAtIndex:i];
        switch (nextChar) {
            case '\n':
                break;
            case '\r':
                break;
            case '\t':
                break;
            case ' ':
                break;
            case '{':
                return [NSDictionary dictionaryWithJSONString:jsonString];
            case '[':
                return [NSArray arrayWithJSONString:jsonString];
            default:
                break;
        }
    }

    return nil;
}

@end
