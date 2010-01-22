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

    _filters       = [[NSMutableDictionary alloc] init];
    _filterForData = [[SimpleHttpClientFilterForData alloc] init];
    _filterForJSON = [[SimpleHttpClientFilterForJSON alloc] init];
    _filterForXML  = [[SimpleHttpClientFilterForXML  alloc] init];
    _filterForHTML = [[SimpleHttpClientFilterForHTML alloc] init];

    return self;
}

- (void)dealloc
{
    [_filters release], _filters = nil;
    [_filterForData release], _filterForData = nil;
    [_filterForJSON release], _filterForJSON = nil;
    [_filterForXML  release], _filterForXML  = nil;
    [_filterForHTML release], _filterForHTML = nil;
    [super dealloc];
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)setFilter:(SimpleHttpClientFilterName)filterName
          forHost:(NSString *)host
{
    SimpleHttpClientFilterBase *newFilter
        = [self filterObjectForName:filterName];
    if (!newFilter) {
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

- (SimpleHttpClientFilterBase *)filterObjectForName:(SimpleHttpClientFilterName)filterName
{
    switch (filterName) {
        case SimpleHttpClientFilterData:
            return _filterForData;
        case SimpleHttpClientFilterJSON:
            return _filterForJSON;
        case SimpleHttpClientFilterXML:
            return _filterForXML;
        case SimpleHttpClientFilterHTML:
            return _filterForHTML;
        default:
            return nil;
    }
}

@end
