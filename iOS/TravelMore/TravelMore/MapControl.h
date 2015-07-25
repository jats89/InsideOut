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
-(void)setUp;
-(void)handleTap;
@property (nonatomic, weak) id<MapControlDelegate> delegate;
@end
