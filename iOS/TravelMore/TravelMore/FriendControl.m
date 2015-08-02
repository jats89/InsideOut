//
//  FriendControl.m
//  TravelMore
//
//  Created by Madan, Bunty on 25/07/15.
//  Copyright (c) 2015 Kumar Malana, Jatin. All rights reserved.
//

#import "FriendControl.h"

@implementation FriendControl

-(void)setUp    {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

-(void)handleTap   {
    [self.delegate tapped];
}
@end
