//
//  LoginViewController.h
//  TravelMore
//
//  Created by Madan, Bunty on 25/07/15.
//  Copyright (c) 2015 Kumar Malana, Jatin. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+Helper.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *myImage1;
@property (weak, nonatomic) IBOutlet UIImageView *myImage2;
@property (weak, nonatomic) IBOutlet UIImageView *myImage3;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSNumber *currentImageIndex;
@property (nonatomic, strong) IBOutlet UIButton *logInButton;
@property (nonatomic, strong) IBOutlet UIButton *coverView;
@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5
                                                  target:self
                                                selector:@selector(updateImage:)
                                                userInfo:nil repeats:YES];
    
    self.logInButton.backgroundColor = [UIColor colorWithHexString:@"382137"];
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
            backgroundColor = [UIColor colorWithHexString:@"382137"];
            break;
        case 2:
            backgroundColor = [UIColor colorWithHexString:@"2F415D"];
            break;
        default:
            backgroundColor = [UIColor colorWithHexString:@"2F2C26"];
            break;
    }
    
    [UIView animateWithDuration:2.0 animations:^{
        [[self valueForKey:fadeOut] setAlpha:0.0];
        self.logInButton.backgroundColor = backgroundColor;
        
    } completion:^(BOOL finished) {
        UIImageView *fadeInView = [self valueForKey:fadeIn];
        [self.view bringSubviewToFront:fadeInView];
    }];
}
@end