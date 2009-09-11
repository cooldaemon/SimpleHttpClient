#import "TestEncodingSHA1.h"
#import "NSString+EncodingSHA1.h"

@implementation TestEncodingSHA1

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)test
{
    NSString *sha1hex = [@"debug\ndebug" stringByEncodingSHA1Hex];

    NSAssert1(
        [sha1hex isEqualToString:@"fb91abbf9a90a826933479da50b3b8841c77bc4c"],
        @"sha1hex string is %@.", sha1hex
    );
}

@end
