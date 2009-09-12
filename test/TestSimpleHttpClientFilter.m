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
    NSString *htmlHost = @"html.org";

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

    [filter
        setFilter:SimpleHttpClientFilterHTML
          forHost:htmlHost
    ];

    SimpleHttpClientFilterBase *jsonFilter = [filter filterObjectForHost:jsonHost];
    SimpleHttpClientFilterBase *xmlFilter  = [filter filterObjectForHost:xmlHost];
    SimpleHttpClientFilterBase *htmlFilter = [filter filterObjectForHost:htmlHost];

    NSAssert1(
        [jsonFilter isKindOfClass:[SimpleHttpClientFilterForJSON class]],
        @"jsonFilter is %@", jsonFilter
    );

    NSAssert1(
        [xmlFilter isKindOfClass:[SimpleHttpClientFilterForXML class]],
        @"xmlFilter is %@", xmlFilter
    );

    NSAssert1(
        [htmlFilter isKindOfClass:[SimpleHttpClientFilterForHTML class]],
        @"htmlFilter is %@", htmlFilter
    );
}

@end
