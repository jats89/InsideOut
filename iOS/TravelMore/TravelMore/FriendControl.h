//
//  FriendControl.h
//  TravelMore
//
//  Created by Madan, Bunty on 25/07/15.
//  Copyright (c) 2015 Kumar Malana, Jatin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendControl;
@protocol FriendControlProtocol <NSObject>
-(void)tapped;
@end
@interface FriendControl : UIControl
@property (nonatomic, weak)id <FriendControlProtocol> delegate;
-(void)setUp;
@end
