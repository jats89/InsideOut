//
//  MapSceneInitialViewController.m
//  TravelMore
//
//  Created by Kumar Malana, Jatin on 25/07/15.
//  Copyright (c) 2015 Kumar Malana, Jatin. All rights reserved.
//

#import "MapSceneInitialViewController.h"
#import <MapKit/MapKit.h>
#import "PlaceInfo.h"
#import "MapControl.h"
#import "FriendControl.h"
#import "UIViewController+Helper.h"

@interface MapSceneInitialViewController ()<MKMapViewDelegate, FriendControlProtocol, MapControlDelegate>  {
    UIView *selectedAccesoryView;
}
@property (nonatomic, weak)IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *mapArray;

@property (nonatomic, strong) NSMutableArray *placeList;

@end

@implementation MapSceneInitialViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _placeList = [[NSMutableArray alloc]init];
    [self readSurvyes];
    [self fetchAdressInfo:_mapArray];
    [self setPlaces];
    // Do any additional setup after loading the view.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id < MKAnnotation >)annotation
{
    NSString *pinIdentifier = @"pin";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
    
    if(annotationView == nil)
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
    else
        annotationView.annotation = annotation;
    
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    annotationView.enabled = YES;
    annotationView.calloutOffset = CGPointMake(-5, -5);

    MapControl *customLeftBtn =   [[[NSBundle mainBundle] loadNibNamed:@"MapControl"
                                                                  owner:self
                                                                options:nil]
                                    objectAtIndex:0];
    [customLeftBtn setUp];
    customLeftBtn.delegate = self;
    customLeftBtn.backgroundColor = [UIColor blueColor];
    customLeftBtn.tintColor = [UIColor whiteColor];
    customLeftBtn.frame = CGRectMake(0, 0, 100, 100);

    annotationView.leftCalloutAccessoryView = customLeftBtn;
   
    FriendControl *friend =   [[[NSBundle mainBundle] loadNibNamed:@"Friend"
                                                               owner:self                                                              options:nil]
                                 objectAtIndex:0];
    friend.frame = CGRectMake(0, 0, 100, 100);
    [friend setUp];
    friend.delegate = self;
    annotationView.rightCalloutAccessoryView = friend;
    return annotationView;
}

-(void)tapped   {
    NSLog(@"friend tapped");
}

-(void)tappedMap    {
    NSLog(@"Pick now tapped ");
    [UIViewController sendNotificationWithTitle:@"ad" msg:@""];
}

- (void)mapView:(MKMapView *)mv annotationView:(MKAnnotationView *)pin calloutAccessoryControlTapped:(UIControl *)control {
    
    //    int index = (int)[self getSelectedIndex:pin.annotation.title];
    UIView *leftAccessoryView =  pin.leftCalloutAccessoryView;
    if (selectedAccesoryView != nil) {
        selectedAccesoryView.backgroundColor =  [UIColor blueColor];
        [((UIButton*)selectedAccesoryView) setTitle:@"Pick" forState:UIControlStateNormal];
        [((UIButton*)selectedAccesoryView) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    } if (leftAccessoryView != selectedAccesoryView) {
        leftAccessoryView.backgroundColor = [UIColor greenColor];
        if ([leftAccessoryView isKindOfClass:[UIButton class]]) {
            [((UIButton*)leftAccessoryView) setTitle:@"Picked" forState:UIControlStateNormal];
            [((UIButton*)leftAccessoryView) setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        selectedAccesoryView = leftAccessoryView;
        
    } else {
        selectedAccesoryView = nil;
    }
}


- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
}
-(void)readSurvyes {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"MapLocations" ofType:@"json"];
    NSError *error;
    NSData *contentData = [NSData dataWithContentsOfFile:path];
    if (contentData != nil) {
        _mapArray = [NSJSONSerialization  JSONObjectWithData:contentData options:NSJSONReadingAllowFragments error:&error];
    }
    if ((error) != nil) {
        NSLog(@"!!! Error reading JSON data for surveys");
    }
    
    
}
-(void)fetchAdressInfo:(NSArray *) addressArray{
    for (NSString* obj in addressArray) {
        NSArray *stringParts = [obj componentsSeparatedByString:@":"];
        PlaceInfo *placeObj = [[PlaceInfo alloc]initWithName:stringParts[0] AddressInfo:stringParts[1] cityInfo:stringParts[2] ZipInfo:stringParts[3] countryString:stringParts[4]];
        
        [_placeList addObject:placeObj];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (unsigned long)getSelectedIndex:(NSString *)title {
    
    NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name  contains[c] %@", title]];
    NSIndexSet *set = [_placeList indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [resultsPredicate evaluateWithObject:obj];
    }];
    return set.firstIndex;
}
-(void)setPlaces {
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for  (PlaceInfo *placeObj in _placeList) {
        CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
        [geoCoder geocodeAddressString:[placeObj getCompleteAddress]  completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks.count >0){
                CLPlacemark *placeMark  = placemarks[0];
                CLLocation *location = placeMark.location;
                CLLocationCoordinate2D coordinate = location.coordinate;
                MKPointAnnotation *annatationPoint = [[MKPointAnnotation alloc]init];
                annatationPoint.coordinate = coordinate;
                annatationPoint.title = placeObj.name;
                annatationPoint.subtitle = placeMark.name;
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annatationPoint.coordinate, 1000, 1000);
                MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.03);
                region.span = span;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView setRegion:region];
                    
                    [self.mapView addAnnotation:annatationPoint];
                    [self.mapView showAnnotations:self.mapView.annotations animated:true];
                });
            };
            
        }];
        
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
