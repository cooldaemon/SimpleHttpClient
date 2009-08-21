#import "TestEncodingURL.h"
#import "NSString+EncodingURL.h"

@implementation TestEncodingURL

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

    NSLog(@"start TestEncodingURL\n");
    @try {
        NSString *url = [@"debug\ndebug debug" stringByEncodingURL];

        NSAssert1(
            [url isEqualToString:@"debug%0Adebug+debug"],
            @"url string is %@.", url
        );
    }
    @catch (NSException *ex) {
        NSLog(@"Name  : %@\n", [ex name]);
        NSLog(@"Reason: %@\n", [ex reason]);
    }
    NSLog(@"end TestEncodingURL\n");

    [pool release];
}

@end
