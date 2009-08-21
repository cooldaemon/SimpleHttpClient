#import <Foundation/Foundation.h>

@interface NSString (EncodingSHA1)
- (NSData *)dataByEncodingSHA1;
- (NSString *)stringByEncodingSHA1Hex;
@end

