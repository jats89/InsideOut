//
//  UIViewController+Helper.m
//  TravelMore
//
//  Created by Madan, Bunty on 25/07/15.
//  Copyright (c) 2015 Kumar Malana, Jatin. All rights reserved.
//

#import "UIViewController+Helper.h"

@implementation UIViewController (Helper)
+(void)sendNotificationWithTitle:(NSString *)title msg:(NSString *)msg  {
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.repeatInterval = NSDayCalendarUnit;
    [notification setAlertBody:@"Hello world"];
    [notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    [notification setTimeZone:[NSTimeZone  defaultTimeZone]];
    [[UIApplication sharedApplication] setScheduledLocalNotifications:[NSArray arrayWithObject:notification]];
}
@end
