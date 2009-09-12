#import <Foundation/Foundation.h>

@interface SimpleHttpClientFilterBase : NSObject
- (id)apply:(NSData *)data;
@end

