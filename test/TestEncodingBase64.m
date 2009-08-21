#import "TestEncodingBase64.h"
#import "NSData+EncodingBase64.h"

@implementation TestEncodingBase64

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

    NSLog(@"start TestEncodingBase64\n");
    @try {
        NSString *base64 = [[NSData dataWithBytes:"debug\ndebug" length:11]
            stringByEncodingBase64
        ];

        NSAssert1(
            [base64 isEqualToString:@"ZGVidWcKZGVidWc="],
            @"base64 string is %@.", base64
        );
    }
    @catch (NSException *ex) {
        NSLog(@"Name  : %@\n", [ex name]);
        NSLog(@"Reason: %@\n", [ex reason]);
    }
    NSLog(@"end TestEncodingBase64\n");

    [pool release];
}

@end
