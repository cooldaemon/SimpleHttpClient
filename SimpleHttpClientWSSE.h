#import <Foundation/Foundation.h>

@interface SimpleHttpClientWSSE : NSObject {
    NSString    *_username;
    NSString    *_password;

    NSDateFormatter *_dateFormatter;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

- (id)initWithUsername:(NSString *)username password:(NSString *)password;

- (NSString *)value;
- (NSDictionary *)header;

@end
