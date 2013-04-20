//
//  HTLocationManager.h
//  iRemember
//
//  Created by nest0r on 13-4-18.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^OnExitBlock)(NSString *identifier);

@interface HTLocationManager : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (copy, nonatomic) dispatch_block_t exitRegionBlock;

+ (HTLocationManager *)sharedInstance;
+ (CLLocationManager *)sharedLocationManager;

- (id)init;
- (void)startMonitoringForRegion:(CLRegion *)region onExitBlock:(OnExitBlock)onExitBlock;

@end
