//
//  HotalDetailViewController.m
//  TravelMore
//
//  Created by Madan, Bunty on 26/07/15.
//  Copyright (c) 2015 Kumar Malana, Jatin. All rights reserved.
//

#import "HotalDetailViewController.h"
#import "JTSImageInfo.h"
#import "JTSImageViewController.h"

@interface HotalDetailViewController ()
@end

@implementation HotalDetailViewController

-(IBAction)dismiss:(id)sender   {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    int xCor = 0;
    self.view.backgroundColor = [UIColor clearColor];
    for (int i=0; i<3; i++) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(test:)];
        tap.numberOfTapsRequired = 1;
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(xCor, 0, 405, 800)];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.userInteractionEnabled = true;
        if (i == 0) {
            view.image = [UIImage imageNamed:@"PS_Hotel_KingRoom_new.jpg"];
        }else if (i == 1) {
            view.image = [UIImage imageNamed:@"zee22.jpg"];
        } else {
            view.image = [UIImage imageNamed:@"rooftop2.jpg"];
        }
        [view addGestureRecognizer:tap];
        [self.scroll addSubview:view];
        xCor+=405;
    }
    self.scroll.contentSize = CGSizeMake(xCor, 200);
    
    
    // Do any additional setup after loading the view.
}

-(IBAction)test:(UITapGestureRecognizer *)sender  {
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    if (sender.view.tag == 0) {
        imageInfo.image = [UIImage imageNamed:@"PS_Hotel_KingRoom_new.jpg"];
    }else if (sender.view.tag == 1) {
        imageInfo.image = [UIImage imageNamed:@"zee22.jpg"];
    } else {
        imageInfo.image = [UIImage imageNamed:@"rooftop2.jpg"];
    }
    imageInfo.referenceRect = sender.view.frame;
    imageInfo.referenceView = sender.view.superview;
    imageInfo.referenceContentMode = sender.view.contentMode;
    imageInfo.referenceCornerRadius = sender.view.layer.cornerRadius;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
