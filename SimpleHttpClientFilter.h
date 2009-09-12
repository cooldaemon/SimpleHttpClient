#import <Foundation/Foundation.h>
#import "SimpleHttpClientFilterBase.h"
#import "SimpleHttpClientFilterForJSON.h"
#import "SimpleHttpClientFilterForXML.h"
#import "SimpleHttpClientFilterForHTML.h"

enum {
    SimpleHttpClientFilterJSON = 0,
    SimpleHttpClientFilterXML  = 1,
    SimpleHttpClientFilterHTML = 2
};
typedef NSUInteger SimpleHttpClientFilterName;

@interface SimpleHttpClientFilter : NSObject {
    NSMutableDictionary           *_filters;

    SimpleHttpClientFilterForJSON *_filterForJSON;
    SimpleHttpClientFilterForXML  *_filterForXML;
    SimpleHttpClientFilterForHTML *_filterForHTML;
}

- (id)init;

- (void)setFilter:(SimpleHttpClientFilterName)filterName
          forHost:(NSString *)host;
- (void)removeFilterForHost:(NSString *)host;

- (SimpleHttpClientFilterBase *)filterObjectForHost:(NSString *)host;

@end
