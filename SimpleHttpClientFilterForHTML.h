#import <Foundation/Foundation.h>
#import "SimpleHttpClientFilterBase.h"
#import "DDXML+HTML.h";

@interface SimpleHttpClientFilterForHTML : SimpleHttpClientFilterBase
- (id)apply:(NSData *)data;
@end

