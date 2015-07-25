//
//  MapControl.m
//  TravelMore
//
//  Created by Kumar Malana, Jatin on 25/07/15.
//  Copyright (c) 2015 Kumar Malana, Jatin. All rights reserved.
//

#import "MapControl.h"

@implementation MapControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    if(nil == (self = [super initWithFrame:frame]))
        return nil;
    [[NSBundle mainBundle] loadNibNamed:@"MapControl" owner:self options:nil];
    return self;
}

@end
