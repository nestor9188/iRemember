//
//  HTLocationManager.m
//  iRemember
//
//  Created by nest0r on 13-4-18.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import "HTLocationManager.h"

@interface HTLocationManager () {
    OnExitBlock _onExitBlock;
}

@end

@implementation HTLocationManager

- (id)init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    return self;
}

+ (HTLocationManager *)sharedInstance {
    static HTLocationManager *instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (CLLocationManager *)sharedLocationManager {
    return [HTLocationManager sharedInstance].locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    /*
     * There is a bug in iOS that causes didEnter/didExitRegion to be called multiple
     * times for one location change (http://openradar.appspot.com/radar?id=2484401).
     * Here, we rate limit it to prevent performing the update twice in quick succession.
     */
    
    static long timestamp;
    
    if (timestamp == 0) {
        timestamp = [[NSDate date] timeIntervalSince1970];
    } else {
        if ([[NSDate date] timeIntervalSince1970] - timestamp < 10) {
            return;
        }
    }
    
    [manager stopMonitoringForRegion:region];
    _onExitBlock(region.identifier);
    NSLog(@"永远不会执行？？");
}

- (void)startMonitoringForRegion:(CLRegion *)region onExitBlock:(OnExitBlock)onExitBlock {
//    [[HTLocationManager sharedLocationManager] startMonitoringForRegion:region];
//    [[HTLocationManager sharedLocationManager] startUpdatingLocation];
    [self.locationManager startMonitoringForRegion:region];
    [self.locationManager startUpdatingHeading];
    _onExitBlock = onExitBlock;
}

@end
