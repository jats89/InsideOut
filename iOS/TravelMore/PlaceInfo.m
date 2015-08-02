//
//  PlaceInfo.m
//  TravelMore
//
//  Created by Kumar Malana, Jatin on 25/07/15.
//  Copyright (c) 2015 Kumar Malana, Jatin. All rights reserved.
//

#import "PlaceInfo.h"

@implementation PlaceInfo

- (instancetype)initWithName:(NSString *) nameString AddressInfo:(NSString *)addresstring cityInfo:(NSString *)cityString ZipInfo:(NSString *)zipString countryString:(NSString *)countryString{
    self = [super init];
    if (self) {
        self.address = addresstring;
        self.name = nameString;
        self.country = countryString;
        self.zipCode = zipString;
        self.city = cityString;
    }
    return self;
}
-(NSString *)getCompleteAddress{
    return  [NSString stringWithFormat:@"%@,%@,%@,%@,%@",self.name,self.address,self.city,self.zipCode,self.country];
}

@end
