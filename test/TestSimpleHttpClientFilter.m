#import "TestSimpleHttpClientFilter.h"
#import "SimpleHttpClientFilter.h"

@implementation TestSimpleHttpClientFilter

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)test
{
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

@end
