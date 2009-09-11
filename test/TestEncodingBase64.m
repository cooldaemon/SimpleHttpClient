#import "TestEncodingBase64.h"
#import "NSData+EncodingBase64.h"

@implementation TestEncodingBase64

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)test
{
    NSString *base64 = [[NSData dataWithBytes:"debug\ndebug" length:11]
        stringByEncodingBase64
    ];

    NSAssert1(
        [base64 isEqualToString:@"ZGVidWcKZGVidWc="],
        @"base64 string is %@.", base64
    );
}

@end
