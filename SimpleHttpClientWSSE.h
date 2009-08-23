#import <Foundation/Foundation.h>

@interface SimpleHttpClientWSSE : NSObject {
    NSMutableDictionary  *_credentials;
    NSDateFormatter      *_dateFormatter;
}

- (id)init;

- (void)setCredentialForHost:(NSString *)host
                    username:(NSString *)username
                    password:(NSString *)password;
- (void)removeCredentialForHost:(NSString *)host;

- (NSString *)valueForHost:(NSString *)host;
- (NSDictionary *)headerForHost:(NSString *)host;

@end
