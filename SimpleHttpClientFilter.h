#import <Foundation/Foundation.h>
#import "SimpleHttpClientFilterBase.h"
#import "SimpleHttpClientFilterForData.h"
#import "SimpleHttpClientFilterForJSON.h"
#import "SimpleHttpClientFilterForXML.h"
#import "SimpleHttpClientFilterForHTML.h"

enum {
    SimpleHttpClientFilterNil  = 0,
    SimpleHttpClientFilterData = 1,
    SimpleHttpClientFilterJSON = 2,
    SimpleHttpClientFilterXML  = 3,
    SimpleHttpClientFilterHTML = 4
};
typedef NSUInteger SimpleHttpClientFilterName;

@interface SimpleHttpClientFilter : NSObject {
    NSMutableDictionary           *_filters;

    SimpleHttpClientFilterForData *_filterForData;
    SimpleHttpClientFilterForJSON *_filterForJSON;
    SimpleHttpClientFilterForXML  *_filterForXML;
    SimpleHttpClientFilterForHTML *_filterForHTML;
}

- (id)init;

- (void)setFilter:(SimpleHttpClientFilterName)filterName
          forHost:(NSString *)host;
- (void)removeFilterForHost:(NSString *)host;

- (SimpleHttpClientFilterBase *)filterObjectForHost:(NSString *)host;
- (SimpleHttpClientFilterBase *)filterObjectForName:(SimpleHttpClientFilterName)filterName;

@end
