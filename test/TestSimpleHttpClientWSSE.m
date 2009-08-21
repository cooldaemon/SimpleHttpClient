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
        SimpleHttpClientWSSE *wsse = [[[SimpleHttpClientWSSE alloc]
            initWithUsername:@"cooldaemon"
                    password:@"foobar"
        ] autorelease];

        NSString *wsseValue = [[wsse header] valueForKey:@"X-WSSE"];

        NSInteger length = [wsseValue length];
        NSAssert1(0 < length, @"%d byte.", length);

        NSLog(@"%@.", wsseValue);
    }
    @catch (NSException *ex) {
        NSLog(@"Name  : %@\n", [ex name]);
        NSLog(@"Reason: %@\n", [ex reason]);
    }
    NSLog(@"end TestSimpleHttpClientWSSE\n");

    [pool release];
}

@end
