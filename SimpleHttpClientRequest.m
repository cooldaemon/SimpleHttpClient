#import "SimpleHttpClientRequest.h"
#import "NSString+EncodingURL.h"

@implementation SimpleHttpClientRequest

@synthesize request = _request;

//----------------------------------------------------------------------------//
#pragma mark -- Internal --
//----------------------------------------------------------------------------//

- (NSString *)makeParamPairWithKey:(NSString *)key value:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]) {
        value = [value description];
    }

    if (![value isKindOfClass:[NSString class]]) {
        return nil;
    }

    return [NSString
        stringWithFormat:@"%@=%@&", key, [value stringByEncodingURL]
    ];
}

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

        NSString *keyValuePair = [self
            makeParamPairWithKey:encodedKey
                           value:value
        ];
        if (keyValuePair) {
            [paramString appendString:keyValuePair];
            continue;
        }

        if (![value isKindOfClass:[NSArray class]]) {
            continue;
        }

        NSEnumerator *valueEnum = [value objectEnumerator];
        id valueElem;
        while (valueElem = [valueEnum nextObject]) {
            NSString *elemKeyValuePair = [self
                makeParamPairWithKey:encodedKey
                               value:valueElem
            ];
            if (elemKeyValuePair) {
                [paramString appendString:elemKeyValuePair];
            }
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
                     wsse:(SimpleHttpClientWSSE *)wsse
                  timeout:(NSTimeInterval)timeout
{
    _request = [NSMutableURLRequest
         requestWithURL:[NSURL URLWithString:url]
            cachePolicy:NSURLRequestUseProtocolCachePolicy
        timeoutInterval:timeout
    ];

    [_request setHTTPShouldHandleCookies:YES];

    if (wsse) {
        NSDictionary *wsse_header = [wsse headerForHost:_request.URL.host];
        if (wsse_header) {
            [_request setAllHTTPHeaderFields:wsse_header];
        }
    }

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
                wsse:(SimpleHttpClientWSSE *)wsse
             timeout:(NSTimeInterval)timeout
{
    if (![super init]) {
        return nil;
    }

    [self setRequestWithUrl:url userAgent:userAgent wsse:wsse timeout:timeout];

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
                wsse:(SimpleHttpClientWSSE *)wsse
             timeout:(NSTimeInterval)timeout
{
    if (![super init]) {
        return nil;
    }

    [self setRequestWithUrl:url userAgent:userAgent wsse:wsse timeout:timeout];

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

