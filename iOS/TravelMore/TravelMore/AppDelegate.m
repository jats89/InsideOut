//
//  AppDelegate.m
//  TravelMore
//
//  Created by Kumar Malana, Jatin on 25/07/15.
//  Copyright (c) 2015 Kumar Malana, Jatin. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>
#import <FBSDKCoreKit/FBSDKAppEvents.h>
#import "MPGNotification.h"
#import "Constant.h"

#define KResponseKey @"Notif"
@interface AppDelegate () {
    NSTimer *responseTimer;
    MPGNotification *notification;
    NSArray *reponseQuestions;
}

@end

@implementation AppDelegate

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    dispatch_queue_t backProcess = dispatch_queue_create("responseQueue", NULL);
    dispatch_async(backProcess, ^{
        reponseQuestions = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TMDynamic" ofType:@"plist"]];
    });
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
-(void)notifTimerInvoked  {
    if (self.questionCount >= reponseQuestions.count) {
        return;
    }
    NSArray *buttonArray;
    UIImage *icon;
    NSString *subtitle;
    responseTimer = nil;
    buttonArray = [NSArray arrayWithObjects:@"Like",@"Dislike", nil];
    
    icon = [UIImage imageNamed:@"_feedback"];
            subtitle = [reponseQuestions objectAtIndex:_questionCount];
 
       notification = [MPGNotification notificationWithTitle:@"Bunty" subtitle:subtitle backgroundColor:[UIColor lightGrayColor] iconImage:icon];
    [notification setButtonConfiguration:buttonArray.count withButtonTitles:buttonArray];
    notification.duration = 25.0;
    notification.swipeToDismissEnabled = NO;
    __weak typeof(self) weakSelf = self;
    [notification setDismissHandler:^(MPGNotification *notification) {
        //        [weakSelf.showNotificationButton setEnabled:YES];
    }];
    
    [notification setButtonHandler:^(MPGNotification *notification, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            if (_questionCount < reponseQuestions.count) {
              responseTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(notifTimerInvoked) userInfo:nil repeats:false];
                weakSelf.questionCount ++;
            }
        } else {
            if (_questionCount < reponseQuestions.count) {
                responseTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(notifTimerInvoked) userInfo:nil repeats:false];
                weakSelf.questionCount ++;
            }
        }
        
    }];
    
    //    if (!([_colorChooser selectedSegmentIndex] == 3 || [_colorChooser selectedSegmentIndex] == 1)) {
    [notification setTitleColor:[UIColor whiteColor]];
    [notification setSubtitleColor:[UIColor whiteColor]];
    //    }
    //
    //    switch ([_animationType selectedSegmentIndex]) {
    //        case 0:
    //            [notification setAnimationType:MPGNotificationAnimationTypeLinear];
    //            break;
    //
    //        case 1:
    //            [notification setAnimationType:MPGNotificationAnimationTypeDrop];
    //            break;
    //
    //        case 2:
    [notification setAnimationType:MPGNotificationAnimationTypeSnap];
    //            break;
    //
    //        default:
    //            break;
    //    }
    //
    [notification show];
    //    [_showNotificationButton setEnabled:NO];
}

@end