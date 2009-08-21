#import "TestEncodingSHA1.h"
#import "NSString+EncodingSHA1.h"

@implementation TestEncodingSHA1

//----------------------------------------------------------------------------//
#pragma mark -- Internal --
//----------------------------------------------------------------------------//

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

- (void)runTest
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSLog(@"start TestEncodingSHA1\n");
    @try {
        NSString *sha1hex = [@"debug\ndebug" stringByEncodingSHA1Hex];

        NSAssert1(
            [sha1hex isEqualToString:@"fb91abbf9a90a826933479da50b3b8841c77bc4c"],
            @"sha1hex string is %@.", sha1hex
        );
    }
    @catch (NSException *ex) {
        NSLog(@"Name  : %@\n", [ex name]);
        NSLog(@"Reason: %@\n", [ex reason]);
    }
    NSLog(@"end TestEncodingSHA1\n");

    [pool release];
}

@end
