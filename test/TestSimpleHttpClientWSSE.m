#import "TestSimpleHttpClientWSSE.h"
#import "SimpleHttpClientWSSE.h"

@implementation TestSimpleHttpClientWSSE

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)test
{
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

@end
