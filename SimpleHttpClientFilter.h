#import <Foundation/Foundation.h>
#import "SimpleHttpClientFilterBase.h"
#import "SimpleHttpClientFilterForJSON.h"
#import "SimpleHttpClientFilterForXML.h"

enum {
    SimpleHttpClientFilterJSON = 0,
    SimpleHttpClientFilterXML  = 1
};
typedef NSUInteger SimpleHttpClientFilterName;

@interface SimpleHttpClientFilter : NSObject {
    NSMutableDictionary           *_filters;

    SimpleHttpClientFilterForJSON *_filterForJSON;
    SimpleHttpClientFilterForXML  *_filterForXML;
}

- (id)init;

- (void)setFilter:(SimpleHttpClientFilterName)filterName
          forHost:(NSString *)host;
- (void)removeFilterForHost:(NSString *)host;

- (SimpleHttpClientFilterBase *)filterObjectForHost:(NSString *)host;

@end
