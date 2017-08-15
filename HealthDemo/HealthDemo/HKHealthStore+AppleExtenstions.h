//
//  HKHealthStore+AppleExtenstions.h
//  HealthDemo
//
//  Created by dengtao on 2017/8/15.
//  Copyright © 2017年 JingXian. All rights reserved.
//

#import <HealthKit/HealthKit.h>

@interface HKHealthStore (AppleExtenstions)

- (void)mostRecentQuantitySampleOfType:(HKQuantityType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(HKQuantity *mostRecentQuantity, NSError *error))completion;

@end
