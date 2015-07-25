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
#import "MPGNotification.h"




@interface MapSceneInitialViewController ()<MKMapViewDelegate>  {
    UIView *selectedAccesoryView;
    MPGNotification *notification;
    
}
@property (nonatomic, weak)IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *mapArray;
@property (nonatomic, retain) MKPolyline *routeLine; //your line
@property (nonatomic, retain) MKPolylineView *routeLineView;
@property (nonatomic, strong) NSMutableArray *placeList;
@property (nonatomic, strong) NSTimer *notifTimer;

@end

@implementation MapSceneInitialViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _placeList = [[NSMutableArray alloc]init];
    
    [self readSurvyes];
    [self fetchAdressInfo:_mapArray];
    [self setPlaces];
    [self.mapView showsUserLocation];
    
    self.notifTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(notifTimerInvoked:) userInfo:nil repeats:false];
    // Do any additional setup after loading the view.
}
-(void)notifTimerInvoked:(NSTimer *)timer  {
    NSArray *buttonArray;
    UIImage *icon;
    NSString *subtitle;
    
    buttonArray = [NSArray arrayWithObjects:@"Reply",@"Later", nil];
    
    icon = [UIImage imageNamed:@"ChatIcon"];
    
    subtitle = @"Did you hear my new collab on Beatport? It's on #1. It's getting incredible reviews as well. Let me know what you think of it!";
    notification = [MPGNotification notificationWithTitle:@"Joey Dale" subtitle:subtitle backgroundColor:[UIColor blueColor] iconImage:icon];
    [notification setButtonConfiguration:buttonArray.count withButtonTitles:buttonArray];
    notification.duration = 2.0;
    notification.swipeToDismissEnabled = NO;
        __weak typeof(self) weakSelf = self;
    [notification setDismissHandler:^(MPGNotification *notification) {
        //        [weakSelf.showNotificationButton setEnabled:YES];
    }];
    
    [notification setButtonHandler:^(MPGNotification *notification, NSInteger buttonIndex) {
        NSLog(@"buttonIndex : %ld", (long)buttonIndex);
        //        [weakSelf.showNotificationButton setEnabled:YES];
    }];
    
    //    if (!([_colorChooser selectedSegmentIndex] == 3 || [_colorChooser selectedSegmentIndex] == 1)) {
    [notification setTitleColor:[UIColor whiteColor]];
    [notification setSubtitleColor:[UIColor whiteColor]];
    //    }
    //
    //    switch ([_animationType selectedSegmentIndex]) {
    //        case 0:
    //            [notification setAnimationType:MPGNotificationAnimationTypeLinear];
    //            break;
    //
    //        case 1:
    //            [notification setAnimationType:MPGNotificationAnimationTypeDrop];
    //            break;
    //
    //        case 2:
    [notification setAnimationType:MPGNotificationAnimationTypeSnap];
    //            break;
    //
    //        default:
    //            break;
    //    }
    //
    [notification show];
    //    [_showNotificationButton setEnabled:NO];
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
    //    [UIViewController sendNotificationWithTitle:@"ad" msg:@""];
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
    customView.coordinate = [view.annotation coordinate];
    customView.bookBlock = ^(CLLocationCoordinate2D coordinate){
        
        MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
        MKPlacemark *placemark1 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude) addressDictionary:nil];
        [request setSource:[[MKMapItem alloc] initWithPlacemark:placemark1]];
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(37.3369444, -121.8894459) addressDictionary:nil];
        request.destination = [[MKMapItem alloc] initWithPlacemark:placemark];
        
        
        // [request setDestination:myMapItem];
        [request setTransportType:MKDirectionsTransportTypeAutomobile]; // This can be limited to automobile and walking directions.
        [request setRequestsAlternateRoutes:YES]; // Gives you several route options.
        MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            if (!error) {
                if ([response routes].count >0) {
                    MKRoute *route = [response routes][0];
                    [mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];
                }
                           }
        }];
        //        CLLocationCoordinate2D coordinateArray[2];
        //        coordinateArray[0] = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
        //        coordinateArray[1] = CLLocationCoordinate2DMake(12.97563, 77.599282);
        //                self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
        //        [self.mapView setVisibleMapRect:[self.routeLine boundingMapRect]]; //If you want the route to be visible
        //
        //        [self.mapView addOverlay:self.routeLine];
    };
    
    [customView.friendsButton addTarget:self action:@selector(friendsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [view addSubview:customView];
    
    customView.center = CGPointMake(view.bounds.size.width*0.5f, -view.bounds.size.height*0.8f);
    
}


-(void)friendsButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"friend" sender:nil];
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
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.lineWidth = 3.0f;
        routeRenderer.strokeColor = [UIColor blueColor];
        return routeRenderer;
    }
    else return nil;
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
