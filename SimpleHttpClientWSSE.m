#import "SimpleHttpClientWSSE.h"

#import "NSString+EncodingSHA1.h"
#import "NSData+EncodingBase64.h"

@implementation SimpleHttpClientWSSE

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//
- (id)init
{
    if (![super init]) {
        return nil;
    }

    _credentials = [[NSMutableDictionary alloc] init];

    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:sszzz"];
    [_dateFormatter setLocale:[
        [[NSLocale alloc] initWithLocaleIdentifier:@"US"] autorelease
    ]];

    return self;
}

- (void)dealloc
{
    [_credentials release], _credentials = nil;
    [_dateFormatter release], _dateFormatter = nil;
    [super dealloc];
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

- (void)setCredentialForHost:(NSString *)host
                    username:(NSString *)username
                    password:(NSString *)password
{
    NSArray *username_password = [_credentials objectForKey:host];

    if (username_password) {
        [self removeCredentialForHost:host];
    }

    username_password = [NSArray arrayWithObjects:username, password, nil];
    [_credentials setObject:username_password forKey:host];
}

- (void)removeCredentialForHost:(NSString *)host
{
    [_credentials removeObjectForKey:host];
}

-(NSString *)valueForHost:(NSString *)host
{
    NSArray *username_password = [_credentials objectForKey:host];
    if (!username_password) {
        return nil;
    }
    NSString *username = [username_password objectAtIndex:0];
    NSString *password = [username_password objectAtIndex:1];

    NSString *created = [_dateFormatter stringFromDate:[NSDate date]];

    srand(time(nil));
    NSString *tmpNonce = [
        [NSString stringWithFormat:@"%@%d", created, rand()]
            stringByEncodingSHA1Hex
    ];

    NSString *passwordDigest = [
        [[NSString stringWithFormat:@"%@%@%@", tmpNonce, created, password]
            dataByEncodingSHA1
        ]
            stringByEncodingBase64
    ];

    NSString *nonce = [[tmpNonce dataUsingEncoding:NSASCIIStringEncoding]
        stringByEncodingBase64
    ];

    return [NSString
        stringWithFormat:@"UsernameToken Username=\"%@\", "
                         @"PasswordDigest=\"%@=\", "
                         @"Nonce=\"%@\", Created=\"%@\"",
            username, passwordDigest, nonce, created
    ];
}

- (NSDictionary *)headerForHost:(NSString *)host;
{
    NSString *value = [self valueForHost:host];
    if (!value) {
        return nil;
    }
    return [NSDictionary dictionaryWithObject:value forKey:@"X-WSSE"];
}

@end
