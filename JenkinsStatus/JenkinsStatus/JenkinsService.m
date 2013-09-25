//
//  JenkinsService.m
//  JenkinsStatus
//
//  Created by Alexey Linkov on 12/29/12.
//  Copyright (c) 2012 SDWR. All rights reserved.
//

#import "JenkinsService.h"
#import "JenkinsJob.h"

@interface JenkinsService ()

@property (nonatomic,strong) NSString *baseURL;
@property (nonatomic,strong) NSMutableData *receivedData;

@property (nonatomic,strong) NSURLConnection *connection;

@end

@implementation JenkinsService


-(id)initWithBaseURL:(NSString *)url {
    
    self = [super init];
    if (self) {
        self.baseURL = url;
    }
    
    return self;
}

-(NSArray *)parseJSON {
    
    NSError* errorInfo;
    NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&errorInfo];
    
    
    NSArray *jobs = [parsedJSON objectForKey:@"jobs"];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:jobs.count];
    
    for (NSDictionary *job in jobs) {
        JenkinsJob *j = [JenkinsJob new];
        j.name = [job objectForKey:@"name"];
        j.status = [NSString stringWithFormat:@"%@/images/48x48/%@.png",self.baseURL,[job objectForKey:@"color"]];
        [j loadDetails:self.baseURL];
        [result addObject:j];
    }
    
    return result;
}

- (void)getBase{
 	
    NSMutableData *dt = [[NSMutableData alloc] init];
 	self.receivedData = dt;
 	
    NSURLRequest *request = [[NSURLRequest alloc]
 							 initWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/json",self.baseURL]]
 							 cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
 							 timeoutInterval: 10
 							 ];
    
    self.connection = [[NSURLConnection alloc]
                       initWithRequest:request
                       delegate:self
                       startImmediately:YES];
}

#pragma mark NSURLConnection delegate methods
- (NSURLRequest *)connection:(NSURLConnection *)connection
 			 willSendRequest:(NSURLRequest *)request
 			redirectResponse:(NSURLResponse *)redirectResponse {
    return request;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

    [self.receivedData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[NSAlert alertWithError:error] runModal];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [self.delegate setValue:[NSArray arrayWithArray:[self parseJSON]] forKey:@"jobs"];
    [self.delegate performSelector:@selector(setNeedsDisplay:) withObject:[NSNumber numberWithBool:YES]];
 	
}


@end
