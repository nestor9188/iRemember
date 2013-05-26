//
//  API.h
//  iReporter
//
//  Created by Fahim Farook on 9/6/12.
//  Copyright (c) 2012 Marin Todorov. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFNetworking.h"

typedef void (^JSONResponseBlock)(NSDictionary* json);

@interface API : AFHTTPClient

+(API*)sharedInstance;

-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;

@end
