#import <Foundation/Foundation.h>
#import "SimpleHttpClientFilterBase.h"

@interface SimpleHttpClientFilterForJSON : SimpleHttpClientFilterBase {
}

- (id)apply:(NSData *)data;

@end

