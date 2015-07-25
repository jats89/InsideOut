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
#import "TRCustomAnnotationView.h"
#import "TRMCustomAnnotationView.h"


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
    [self.mapView showsUserLocation];
    // Do any additional setup after loading the view.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id < MKAnnotation >)annotation
{
    NSString *pinIdentifier = @"pin";
    
    
    TRMCustomAnnotationView *annotationView = (TRMCustomAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
    
    if(annotationView == nil)
        annotationView = [[TRMCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
    else
        annotationView.annotation = annotation;
    annotationView.image = [UIImage imageNamed:@"DrawingPin1_Blue"];
    annotationView.calloutOffset = CGPointMake(-5, -5);
    
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
//    TRCustomAnnotationView *customView = [[[NSBundle mainBundle] loadNibNamed:@"TRCustomAnnotationView"
//                                                                        owner:self
//                                                                      options:nil]
//                                          objectAtIndex:0];
//    customView.frame = CGRectMake(0, 0, 300, 100);
//    customView.center = CGPointMake(view.bounds.size.width*0.5f, self.view.bounds.size.height*0.5f);

    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[TRCustomAnnotationView class]]) {
            subView.hidden = true;
        }
    }
    
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
//    for (UIView *subView in view.subviews) {
//        if ([subView isKindOfClass:[TRCustomAnnotationView class]]) {
//            subView.hidden = false;
//        }
//    }
    TRCustomAnnotationView *customView = [[[NSBundle mainBundle] loadNibNamed:@"TRCustomAnnotationView"
                                                                        owner:self
                                                                      options:nil]
                                          objectAtIndex:0];
    customView.frame = CGRectMake(0, 0, 300, 60);
    customView.layer.cornerRadius = 10.0f;
    customView.layer.masksToBounds = true;
    customView.titlelabel.text = [view.annotation title];
    customView.subTitlelabel.text = [view.annotation subtitle];
    [customView.bookNowButton addTarget:self action:@selector(bookNowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [customView.friendsButton addTarget:self action:@selector(friendsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];


    [view addSubview:customView];

    customView.center = CGPointMake(view.bounds.size.width*0.5f, -view.bounds.size.height*0.8f);
    
}
-(void)bookNowButtonClicked:(id)sender {
    
}

-(void)friendsButtonClicked:(id)sender {
    
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
