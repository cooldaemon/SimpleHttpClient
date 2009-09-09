#import <Foundation/Foundation.h>
#import "SimpleHttpClientFilterBase.h"
#import "DDXML.h";

@interface SimpleHttpClientFilterForXML : SimpleHttpClientFilterBase {
}

- (id)apply:(NSData *)data;

@end

