#import "SimpleHttpClientRequest.h"
#import "NSString+EncodingURL.h"

@implementation SimpleHttpClientRequest

@synthesize request = _request;

//----------------------------------------------------------------------------//
#pragma mark -- Internal --
//----------------------------------------------------------------------------//

- (NSString *)makeParamString:(NSDictionary *)parameters
{
    NSMutableString *paramString = [NSMutableString string];
    if (!parameters) {
        return paramString;
    }

    NSEnumerator *paramEnum = [parameters keyEnumerator];
    id key;
    while (key = [paramEnum nextObject]) {
        if (![key isKindOfClass:[NSString class]]) {
            continue;
        }
        NSString *encodedKey = [key stringByEncodingURL];

        id value = [parameters objectForKey:key];

        if ([value isKindOfClass:[NSString class]]) {
            [paramString appendFormat:@"%@=%@&", encodedKey, [value stringByEncodingURL]];
            continue;
        }

        if (![value isKindOfClass:[NSArray class]]) {
            continue;
        }

        NSEnumerator *valueEnum = [value objectEnumerator];
        id valueElem;
        while (valueElem = [valueEnum nextObject]) {
            if (![valueElem isKindOfClass:[NSString class]]) {
                continue;
            }
            [paramString appendFormat:@"%@=%@&",
                encodedKey,
                [valueElem stringByEncodingURL]
            ];
        }
    }

    if (paramString.length > 0) { // delete last '&'.
        [paramString deleteCharactersInRange:NSMakeRange(paramString.length-1, 1)];
    }

    return paramString;
}

- (void)setRequestWithMethod:(SimpleHttpClientRequestMethod)method
                     headers:(NSDictionary *)headers
                        body:(NSString *)body
{
    [_request setHTTPMethod:(
        SimpleHttpClientRequestMethodPUT == method ? @"PUT" : @"POST"
    )];

    NSMutableDictionary *setHeaders = [NSMutableDictionary
        dictionaryWithDictionary:[_request allHTTPHeaderFields]
    ];
    [setHeaders addEntriesFromDictionary:headers];
    [_request setAllHTTPHeaderFields:setHeaders];

    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    [_request
                  setValue:[NSString stringWithFormat:@"%d", bodyData.length]
        forHTTPHeaderField:@"Content-Length"
    ];
    [_request setHTTPBody:bodyData];
}

- (void)setGetOrDeleteRequestWithMethod:(SimpleHttpClientRequestMethod)method
                                    url:(NSString *)url
                             parameters:(NSDictionary *)parameters
{
    NSString *paramString = [self makeParamString:parameters];

    NSMutableString *requestUrl = [NSMutableString stringWithString:url]; 
    if (paramString.length > 0) {
        [requestUrl appendString:@"?"];
        [requestUrl appendString:paramString];
    }

    [_request setURL:[NSURL URLWithString:requestUrl]];

    if (SimpleHttpClientRequestMethodDELETE == method) {
        [_request setHTTPMethod:@"DELETE"];
    }
}
 
- (void)setPostOrPutRequestWithMethod:(SimpleHttpClientRequestMethod)method
                           parameters:(NSDictionary *)parameters
{
    [self
        setRequestWithMethod:method
                     headers:[NSDictionary
                        dictionaryWithObject:@"application/x-www-form-urlencoded"
                                      forKey:@"Content-Type"
                      ]
                        body:[self makeParamString:parameters]
    ];
}

- (void)setRequestWithUrl:(NSString *)url
                userAgent:(NSString *)userAgent
                  timeout:(NSTimeInterval)timeout
{
    _request = [NSMutableURLRequest
         requestWithURL:[NSURL URLWithString:url]
            cachePolicy:NSURLRequestUseProtocolCachePolicy
        timeoutInterval:timeout
    ];

    [_request setHTTPShouldHandleCookies:YES];

    [_request
                  setValue:userAgent
        forHTTPHeaderField:@"User-Agent"
    ];
}

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)initWithMethod:(SimpleHttpClientRequestMethod)method
                 url:(NSString *)url
          parameters:(NSDictionary *)parameters
           userAgent:(NSString *)userAgent
             timeout:(NSTimeInterval)timeout
{
    if (![super init]) {
        return nil;
    }

    [self setRequestWithUrl:url userAgent:userAgent timeout:timeout];

    if (
           SimpleHttpClientRequestMethodGET    == method
        || SimpleHttpClientRequestMethodDELETE == method
    ) {
        [self
            setGetOrDeleteRequestWithMethod:method
                                        url:url
                                 parameters:(NSDictionary *)parameters
        ];
    } else {
        [self
            setPostOrPutRequestWithMethod:method
                               parameters:(NSDictionary *)parameters
        ];
    }

    return self;
}

- (id)initWithMethod:(SimpleHttpClientRequestMethod)method
                 url:(NSString *)url
             headers:(NSDictionary *)headers
                body:(NSString *)body
           userAgent:(NSString *)userAgent
             timeout:(NSTimeInterval)timeout
{
    if (![super init]) {
        return nil;
    }

    [self setRequestWithUrl:url userAgent:userAgent timeout:timeout];

    if (
           SimpleHttpClientRequestMethodPOST != method
        && SimpleHttpClientRequestMethodPUT  != method
    ) {
        return nil;
    }

    [self setRequestWithMethod:method headers:headers body:body];
    return self;
}

- (void)dealloc
{
    _request = nil;
    [super dealloc];
}

@end

