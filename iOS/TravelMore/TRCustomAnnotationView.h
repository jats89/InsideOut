//
//  TRCustomAnnotationView.h
//  TravelMore
//
//  Created by Kumar Malana, Jatin on 25/07/15.
//  Copyright (c) 2015 Kumar Malana, Jatin. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface TRCustomAnnotationView : UIView
@property (weak, nonatomic) IBOutlet UIButton *bookNowButton;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *friendslabel;
@property (weak, nonatomic) IBOutlet UIButton *friendsButton;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitlelabel;
@property  CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) void (^bookBlock)(CLLocationCoordinate2D,UIButton*);

@end
