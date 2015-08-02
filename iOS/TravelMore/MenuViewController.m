//
//  MenuViewController.m
//  TravelMore
//
//  Created by Kumar Malana, Jatin on 25/07/15.
//  Copyright (c) 2015 Kumar Malana, Jatin. All rights reserved.
//

#import "MenuViewController.h"
#import "Constants.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myImage1;
@property (weak, nonatomic) IBOutlet UIImageView *myImage2;
@property (weak, nonatomic) IBOutlet UIImageView *myImage3;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [self setUpWithButtonCount:kKYCCircleMenuButtonsCount
                      menuSize:kKYCircleMenuSize
                    buttonSize:kKYCircleMenuButtonSize
         buttonImageNameFormat:kKYICircleMenuButtonImageNameFormat
              centerButtonSize:kKYCircleMenuCenterButtonSize
         centerButtonImageName:kKYICircleMenuCenterButton
centerButtonBackgroundImageName:kKYICircleMenuCenterButtonBackground] ;
    [super viewDidLoad];
    self.menu.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5
                                                  target:self
                                                selector:@selector(updateImage:)
                                                userInfo:nil repeats:YES];
    
    
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
        [self.view bringSubviewToFront:_nameLabel];
        [self.view bringSubviewToFront:self.coverView];
        [self.view bringSubviewToFront:menu_];
        [self.view bringSubviewToFront:centerButton_];


    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)runButtonActions:(id)sender
{
    [super runButtonActions:sender];
    
    // Configure new view & push it with custom |pushViewController:| method
    UIViewController * viewController = [[UIViewController alloc] init];
    [viewController.view setBackgroundColor:[UIColor blackColor]];
    [viewController setTitle:[NSString stringWithFormat:@"View %ld", (long)[sender tag]]];
    // Use KYCircleMenu's |-pushViewController:| to push vc
    [self pushViewController:viewController];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
