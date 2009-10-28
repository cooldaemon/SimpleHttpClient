#import <Foundation/Foundation.h>
#import "SimpleHttpClientFilterBase.h"
#import "DDXML+HTML.h";

@interface SimpleHttpClientFilterForData : SimpleHttpClientFilterBase
- (id)apply:(NSData *)data;
@end

