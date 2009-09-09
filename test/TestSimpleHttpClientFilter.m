#import "TestSimpleHttpClientFilter.h"
#import "SimpleHttpClientFilter.h"

@implementation TestSimpleHttpClientFilter

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

    NSLog(@"start SimpleHttpClientFilter");
    @try {
        NSString *jsonHost = @"json.org";
        NSString *xmlHost  = @"xml.org";

        SimpleHttpClientFilter *filter = [
            [[SimpleHttpClientFilter alloc] init] autorelease
        ];

        [filter
            setFilter:SimpleHttpClientFilterJSON
              forHost:jsonHost
        ];

        [filter
            setFilter:SimpleHttpClientFilterXML
              forHost:xmlHost
        ];

        SimpleHttpClientFilterBase *jsonFilter = [filter filterObjectForHost:jsonHost];
        SimpleHttpClientFilterBase *xmlFilter  = [filter filterObjectForHost:xmlHost];

        NSAssert1(
            [jsonFilter isKindOfClass:[SimpleHttpClientFilterForJSON class]],
            @"jsonFilter is %@", jsonFilter
        );

        NSAssert1(
            [xmlFilter isKindOfClass:[SimpleHttpClientFilterForXML class]],
            @"xmlFilter is %@", xmlFilter
        );
    }
    @catch (NSException *ex) {
        NSLog(@"Name  : %@\n", [ex name]);
        NSLog(@"Reason: %@\n", [ex reason]);
    }
    NSLog(@"end SimpleHttpClientFilter");

    [pool release];
}

@end
