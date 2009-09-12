#import <Foundation/Foundation.h>
#import "SimpleHttpClientFilterBase.h"
#import "DDXML+HTML.h";

@interface SimpleHttpClientFilterForXML : SimpleHttpClientFilterBase
- (id)apply:(NSData *)data;
@end

