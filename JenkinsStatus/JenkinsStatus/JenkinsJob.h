//
//  JenkinsJob.h
//  JenkinsStatus
//
//  Created by Alexey Linkov on 12/30/12.
//  Copyright (c) 2012 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JenkinsJob : NSObject

@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *healthImageURL;

-(void)loadDetails:(NSString *)baseURL;

@end
