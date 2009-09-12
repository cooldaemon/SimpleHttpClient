#import "SimpleHttpClientFilter.h"

@implementation SimpleHttpClientFilter

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//
- (id)init
{
    if (![super init]) {
        return nil;
    }

    _filters       = [NSMutableDictionary dictionary];
    _filterForJSON = [[SimpleHttpClientFilterForJSON alloc] init];
    _filterForXML  = [[SimpleHttpClientFilterForXML  alloc] init];
    _filterForHTML = [[SimpleHttpClientFilterForHTML alloc] init];

    return self;
}

- (void)dealloc
{
    _filters = nil;
    [_filterForJSON release]; _filterForJSON = nil;
    [_filterForXML  release]; _filterForXML  = nil;
    [_filterForHTML release]; _filterForHTML = nil;
    [super dealloc];
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)setFilter:(SimpleHttpClientFilterName)filterName
          forHost:(NSString *)host
{
    SimpleHttpClientFilterBase *newFilter = nil;

    switch (filterName) {
        case SimpleHttpClientFilterJSON:
            newFilter = _filterForJSON;
            break;
        case SimpleHttpClientFilterXML:
            newFilter = _filterForXML;
            break;
        case SimpleHttpClientFilterHTML:
            newFilter = _filterForHTML;
            break;
        default:
            return;
    }

    SimpleHttpClientFilterBase *oldFilter = [self filterObjectForHost:host];
    if (oldFilter) {
        [self removeFilterForHost:host];
    }

    [_filters setObject:newFilter forKey:host];
}

- (void)removeFilterForHost:(NSString *)host;
{
    [_filters removeObjectForKey:host];
}

- (SimpleHttpClientFilterBase *)filterObjectForHost:(NSString *)host
{
    return [_filters objectForKey:host];
}

@end
