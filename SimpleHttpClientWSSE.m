#import "SimpleHttpClientWSSE.h"

#import "NSString+EncodingSHA1.h"
#import "NSData+EncodingBase64.h"

@implementation SimpleHttpClientWSSE

@synthesize username = _username;
@synthesize password = _password;

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//
- (id)initWithUsername:(NSString *)username password:(NSString *)password
{
    if (![super init]) {
        return nil;
    }

    self.username = username;
    self.password = password;

    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:sszzz"];
    [_dateFormatter setLocale:[
        [[NSLocale alloc] initWithLocaleIdentifier:@"US"] autorelease
    ]];

    return self;
}

- (void)dealloc
{
    [self.username release], self.username = nil;
    [self.password release], self.password = nil;
    [_dateFormatter release], _dateFormatter = nil;
    [super dealloc];
}

//----------------------------------------------------------------------------//
#pragma mark -- APIs --
//----------------------------------------------------------------------------//

-(NSString *)value
{
    NSString *created = [_dateFormatter stringFromDate:[NSDate date]];

    srand(time(nil));
    NSString *tmpNonce = [
        [NSString stringWithFormat:@"%@%d", created, rand()]
            stringByEncodingSHA1Hex
    ];

    NSString *passwordDigest = [
        [[NSString stringWithFormat:@"%@%@%@", tmpNonce, created, self.password]
            dataByEncodingSHA1
        ]
            stringByEncodingBase64
    ];

    NSString *nonce = [[tmpNonce dataUsingEncoding:NSASCIIStringEncoding]
        stringByEncodingBase64
    ];

    return [NSString
        stringWithFormat:@"UsernameToken Username=\"%@\", "
                         @"PasswordDigest=\"%@\", "
                         @"Nonce=\"%@\", Created=\"%@\"",
            self.username, passwordDigest, nonce, created
    ];
}

- (NSDictionary *)header
{
    return [NSDictionary
        dictionaryWithObject:[self value]
                      forKey:@"X-WSSE"
    ];
}

@end
