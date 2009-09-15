#import <CommonCrypto/CommonDigest.h>
#import "NSString+EncodingSHA1.h"

@implementation NSString (EncodingSHA1)

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (NSData *)dataByEncodingSHA1
{
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1((const unsigned char *)[self UTF8String], [self length], digest);
    return [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
} 

- (NSString *)stringByEncodingSHA1Hex
{
    const unsigned char *source = [[self dataByEncodingSHA1] bytes];

    char finaldigest[2*CC_SHA1_DIGEST_LENGTH+1];
    for (NSInteger count = 0; count < CC_SHA1_DIGEST_LENGTH; count++) {
        sprintf(finaldigest + count * 2, "%02x", source[count]);
    }
    finaldigest[2*CC_SHA1_DIGEST_LENGTH] = '\0';

    return [NSString
        stringWithCString:finaldigest
                 encoding:NSASCIIStringEncoding
    ];
}

@end

