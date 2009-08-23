#import "TestSimpleHttpClientWSSE.h"
#import "SimpleHttpClientWSSE.h"

@implementation TestSimpleHttpClientWSSE

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

    NSLog(@"start TestSimpleHttpClientWSSE\n");
    @try {
        NSString *host = @"google.com";

        SimpleHttpClientWSSE *wsse = [
            [[SimpleHttpClientWSSE alloc] init] autorelease
        ];
        [wsse
            setCredentialForHost:host
                        username:@"cooldaemon"
                        password:@"foo"
        ];

        NSString *wsseValue = [[wsse headerForHost:host] valueForKey:@"X-WSSE"];

        NSInteger length = [wsseValue length];
        NSAssert1(0 < length, @"%d byte.", length);

        NSLog(@"%@", wsseValue);

        NSDictionary *header = [wsse headerForHost:@"baz"];
        NSAssert1(nil == header, @"bad header is %@", header);
    }
    @catch (NSException *ex) {
        NSLog(@"Name  : %@\n", [ex name]);
        NSLog(@"Reason: %@\n", [ex reason]);
    }
    NSLog(@"end TestSimpleHttpClientWSSE\n");

    [pool release];
}

@end
