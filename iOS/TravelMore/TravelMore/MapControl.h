//
//  MapControl.h
//  TravelMore
//
//  Created by Kumar Malana, Jatin on 25/07/15.
//  Copyright (c) 2015 Kumar Malana, Jatin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MapControl;
@protocol MapControlDelegate <NSObject>
-(void)tappedMap;
@end
@interface MapControl : UIControl
@property (nonatomic, strong)IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong)IBOutlet UILabel *infoLabel;
@end
