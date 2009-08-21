#import "NSString+EncodingURL.h"

@implementation NSString (EncodingURL)

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (NSString *)stringByEncodingURL
{
    NSMutableString *result = [NSMutableString string];

    for (const char *source = [self UTF8String]; *source; source++) {
        unsigned char append = *source;
        NSString* format = @"%c";

        if (' ' == append) {
            append = '+';
        } else if (!(
               '0' <= append && append <= '9'
            || 'A' <= append && append <= 'Z'
            || 'a' <= append && append <= 'z'
            || '-' == append
            || '_' == append
        )) {
            format = @"%%%02X";
        }

        [result appendFormat:format, append];
    }

    return result;
}

@end

