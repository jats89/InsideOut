//
//  LoginViewController.h
//  TravelMore
//
//  Created by Madan, Bunty on 25/07/15.
//  Copyright (c) 2015 Kumar Malana, Jatin. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+Helper.h"
#import "JVFloatLabeledTextField.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "DeformationButton.h"
#import "Constant.h"
#import "MapSceneInitialViewController.h"
#import "MenuViewController.h"
#import "Constants.h"



@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *myImage1;
@property (weak, nonatomic) IBOutlet UIImageView *myImage2;
@property (weak, nonatomic) IBOutlet UIImageView *myImage3;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSNumber *currentImageIndex;
@property (nonatomic, strong) DeformationButton *logInButton;
@property (nonatomic, strong) IBOutlet UIView *coverView;

@property (nonatomic, weak) IBOutlet JVFloatLabeledTextField *username;
@property (nonatomic, weak) IBOutlet JVFloatLabeledTextField *password;
@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5
                                                  target:self
                                                selector:@selector(updateImage:)
                                                userInfo:nil repeats:YES];
    _username.placeholder = @"Username";
    _password.placeholder = @"Password";
    
    _logInButton = [[DeformationButton alloc]initWithFrame:CGRectMake(0,0,370, 40) withColor:[UIColor redColor]];
    [self.coverView addSubview:_logInButton];
    [_logInButton.forDisplayButton.titleLabel setFont:[UIFont fontWithName:APP_FONT_BOLD size:20.0]];
    [_logInButton.forDisplayButton setTitle:@"Login With Facebook" forState:UIControlStateNormal];
    [_logInButton.forDisplayButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_logInButton.forDisplayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logInButton.forDisplayButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    [_logInButton.forDisplayButton setImage:[UIImage imageNamed:@"微博logo.png"] forState:UIControlStateNormal];
    
    
    [_logInButton addTarget:self action:@selector(facebookAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillDisappear:(BOOL)animated    {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateImage:(NSTimer *)timer    {
    static NSUInteger counter = 1;
    
    NSString *fadeOut = [NSString stringWithFormat:@"myImage%lu", (unsigned long)counter];
    counter++;
    
    if (counter > 3) {
        counter = 1;
    }
    
    NSString *fadeIn = [NSString stringWithFormat:@"myImage%lu", (unsigned long)counter];
    [[self valueForKey:fadeIn] setAlpha:1.0];
    
    UIColor *backgroundColor;
    switch (counter) {
        case 1:
            backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:fadeOut]];
            break;
        case 2:
            backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:fadeOut]];
            break;
        default:
            backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:fadeOut]];
            break;
    }
    
    [UIView animateWithDuration:2.0 animations:^{
        [[self valueForKey:fadeOut] setAlpha:0.0];
        
    } completion:^(BOOL finished) {
        UIImageView *fadeInView = [self valueForKey:fadeIn];
        [self.view bringSubviewToFront:fadeInView];
        [self.view bringSubviewToFront:self.coverView];
    }];
}

-(IBAction)loginAction:(id)sender   {
    
}

-(IBAction)facebookAction:(id)sender    {
//    [FBSDKAccessToken setCurrentAccessToken:nil];
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//    [login logInWithReadPermissions:@[@"email",@"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//        if (error) {
//            NSLog(@"Error");
//        } else if (result.isCancelled) {
//            NSLog(@"Cancel Pressed");
//        } else {
            [self showHome];
//        }
//    }];
}

-(void)showHome {
    MenuViewController *menCntrl = [[MenuViewController  alloc ]initWithNibName:@"MenuViewController" bundle:nil];

    [self presentViewController:menCntrl animated:true completion:nil];
    
    
    

    }
@end