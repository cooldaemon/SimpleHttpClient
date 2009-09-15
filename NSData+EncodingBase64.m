#import "NSData+EncodingBase64.h"

static char *base64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSData (EncodingBase64)

//----------------------------------------------------------------------------//
#pragma mark -- Internal --
//----------------------------------------------------------------------------//
- (void)encodeElem:(unsigned long)elem
            length:(NSInteger)length
            result:(NSMutableString *)result
{
    for (NSInteger i = length; i < 2; i++) {
        elem <<= 8;
    }

    NSInteger count = 0;

    for (NSInteger base = 18; count < length + 2; count++, base -= 6) {
        char base64string[2];
        base64string[0] = base64[(unsigned long)((elem>>base) & 0x3F)];
        base64string[1] = '\0';

        [result appendString:[NSString
            stringWithCString:base64string
                     encoding:NSASCIIStringEncoding
        ]];
    }

    for (NSInteger j = count; j < 4; j++) {
        [result appendString:[NSString
            stringWithCString:"="
                     encoding:NSASCIIStringEncoding
        ]];
    }
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (NSString *)stringByEncodingBase64
{
    NSMutableString *result = [NSMutableString string];

    unsigned long elem = (unsigned long)0;
    NSInteger elemLength = 0;

    NSInteger length = [self length];
    NSInteger count = 0;
    for (const unsigned char *source = [self bytes];
        count < length;
        source++, count++
    ) {
        elem <<= 8;
        elem |= (unsigned long)*source;

        if (elemLength == 2) {
            [self encodeElem:elem length:elemLength result:result];
            elemLength = 0;
            elem = 0;
        } else {
            elemLength++;
        }
    }

    if (elemLength) {
        [self encodeElem:elem length:elemLength - 1 result:result];
    }

    return result;
}

@end

