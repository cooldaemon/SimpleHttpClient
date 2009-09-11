#import "TestEncodingURL.h"
#import "NSString+EncodingURL.h"

@implementation TestEncodingURL

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)test
{
    NSString *url = [@"debug\ndebug debug" stringByEncodingURL];

    NSAssert1(
        [url isEqualToString:@"debug%0Adebug+debug"],
        @"url string is %@.", url
    );
}

@end
