//
//  TRCustomAnnotationView.m
//  TravelMore
//
//  Created by Kumar Malana, Jatin on 25/07/15.
//  Copyright (c) 2015 Kumar Malana, Jatin. All rights reserved.
//

#import "TRCustomAnnotationView.h"

@implementation TRCustomAnnotationView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib {
    [self.bookNowButton addTarget:self action:@selector(bookNowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)bookNowButtonClicked:(id)sender {
    _bookBlock(_coordinate);
}
@end
