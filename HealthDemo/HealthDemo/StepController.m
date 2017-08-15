//
//  StepController.m
//  HealthDemo
//
//  Created by dengtao on 2017/8/15.
//  Copyright © 2017年 JingXian. All rights reserved.
//

#import "StepController.h"
#import <HealthKit/HealthKit.h>

@interface StepController ()
@property (weak, nonatomic) IBOutlet UITextField *oldStepTF;
@property (weak, nonatomic) IBOutlet UITextField *addStepTF;

@property (nonatomic) HKHealthStore *healthStore;

@end

@implementation StepController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"步数";
    
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    //获取今天的当前步数:
    [self fetchSumOfSamplesTodayForType:stepType unit:[HKUnit countUnit] completion:^(double stepCount, NSError *error) {
        NSLog(@"%f",stepCount);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.oldStepTF.text = [NSString stringWithFormat:@"%.f",stepCount];
        });
    }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark - #pragma mark - writing HealthKit Data

- (IBAction)addSureAction:(UIButton *)sender {
    
     [self addstepWithStepNum:self.addStepTF.text.doubleValue];
    
}

#pragma mark - #pragma mark - Reading HealthKit Data

- (void)fetchSumOfSamplesTodayForType:(HKQuantityType *)quantityType unit:(HKUnit *)unit completion:(void (^)(double, NSError *))completionHandler {
    
    NSPredicate *predicate = [self predicateForSamplesToday];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        HKQuantity *sum = [result sumQuantity];
        
        if (completionHandler) {
            double value = [sum doubleValueForUnit:unit];
            
            completionHandler(value, error);
        }
    }];
    
    [self.healthStore executeQuery:query];
}

#pragma mark - Convenience

- (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDate *startDate = [calendar startOfDayForDate:now];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    return [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
}



- (void)addstepWithStepNum:(double)stepNum {
    // Create a new food correlation for the given food item.
    HKQuantitySample *stepCorrelationItem = [self stepCorrelationWithStepNum:stepNum];
    
    [self.healthStore saveObject:stepCorrelationItem withCompletion:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [self.view endEditing:YES];
                UIAlertView *doneAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [doneAlertView show];
            }
            else {
                NSLog(@"The error was: %@.", error);
                UIAlertView *doneAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [doneAlertView show];
                return ;
            }
        });
    }];
}

- (HKQuantitySample *)stepCorrelationWithStepNum:(double)stepNum {
    
    NSDate *endDate = [NSDate date];
    NSDate *startDate = [NSDate dateWithTimeInterval:-300 sinceDate:endDate];
    
    HKQuantity *stepQuantityConsumed = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:stepNum];
    
    HKQuantityType *stepConsumedType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    
    HKDevice *device = [[HKDevice alloc] initWithName:[UIDevice currentDevice].systemName
                                         manufacturer:[UIDevice currentDevice].systemName
                                                model:[UIDevice currentDevice].model
                                      hardwareVersion:@"iPhone6s plus"
                                      firmwareVersion:@"iPhone6s plus"
                                      softwareVersion:[UIDevice currentDevice].systemVersion
                                      localIdentifier:[UIDevice currentDevice].name
                                  UDIDeviceIdentifier:[UIDevice currentDevice].localizedModel];
    
    NSDictionary *stepCorrelationMetadata = @{HKMetadataKeyUDIDeviceIdentifier: @"test equipment",
                                                      HKMetadataKeyDeviceName:@"iPhone",
                                                      HKMetadataKeyWorkoutBrandName:@"Apple",
                                                      HKMetadataKeyDeviceManufacturerName:@"Apple"};
    
    HKQuantitySample *stepConsumedSample = [HKQuantitySample quantitySampleWithType:stepConsumedType quantity:stepQuantityConsumed startDate:startDate endDate:endDate device:device metadata:stepCorrelationMetadata];
    
    
    return stepConsumedSample;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(HKHealthStore *)healthStore{
    
    if (_healthStore == nil) {
        
        _healthStore = [[HKHealthStore alloc] init];
    }
    return _healthStore;
}

@end
