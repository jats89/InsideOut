//
//  TRCustomAnnotationView.m
//  TravelMore
//
//  Created by Kumar Malana, Jatin on 25/07/15.
//  Copyright (c) 2015 Kumar Malana, Jatin. All rights reserved.
//

#import "TRCustomAnnotationView.h"
#import "Constant.h"

@implementation TRCustomAnnotationView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    _iconImage.layer.cornerRadius = 20.0;
    _iconImage.layer.masksToBounds= YES;
}
*/
-(void)awakeFromNib {
    [self.bookNowButton addTarget:self action:@selector(bookNowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _iconImage.layer.cornerRadius = 20.0;
    _iconImage.layer.masksToBounds= YES;
}
-(void)bookNowButtonClicked:(UIButton *)sender {
    _bookBlock(_coordinate,sender);
}
@end
