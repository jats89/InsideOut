//
//  PlaceInfo.h
//  TravelMore
//
//  Created by Kumar Malana, Jatin on 25/07/15.
//  Copyright (c) 2015 Kumar Malana, Jatin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceInfo : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *country;

- (instancetype)initWithName:(NSString *) nameString AddressInfo:(NSString *)addresstring cityInfo:(NSString *)cityString ZipInfo:(NSString *)zipString countryString:(NSString *)countryString;
-(NSString *)getCompleteAddress;
@end
