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
#import "FriendControl.h"
#import "Constant.h"
#import "JTSImageInfo.h"
#import "JTSImageViewController.h"


@interface MapSceneInitialViewController ()<MKMapViewDelegate>  {
    UIView *selectedAccesoryView;
    MPGNotification *notification;
    CLLocationCoordinate2D userCoordinate;
    CLLocationCoordinate2D hotelsCoordiante;
    
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
    userCoordinate = CLLocationCoordinate2DMake(37.3369444, -121.94);
    _placeList = [[NSMutableArray alloc]init];
    
    [self readSurvyes];
    [self fetchAdressInfo:_mapArray];
    [self setPlaces];
    [self.mapView showsUserLocation];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)notifTimerInvoked  {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.questionCount = 0;
    [appDelegate notifTimerInvoked];
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id < MKAnnotation >)annotation
{
    NSString *pinIdentifier;
    if (![[annotation title] isEqualToString:@"User"]) {
        pinIdentifier = @"pin";
    } else {
        pinIdentifier = @"user";
        
    }
    
    
    TRMCustomAnnotationView *annotationView = (TRMCustomAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
    
    if(annotationView == nil)
        annotationView = [[TRMCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
    else
        annotationView.annotation = annotation;
    if (![[annotation title] isEqualToString:@"User"]) {
        annotationView.image = [UIImage imageNamed:@"DrawingPin1_Blue"];
    } else {
        annotationView.image = [UIImage imageNamed:@"user"];
        
    }
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDetail:)];
    tap.numberOfTapsRequired = 1;
    [customView addGestureRecognizer:tap];
    
    customView.subTitlelabel.text = [view.annotation subtitle];
    [customView.bookNowButton addTarget:self action:@selector(bookNowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [customView.friendsButton addTarget:self action:@selector(friendsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];


    [view addSubview:customView];

    customView.center = CGPointMake(view.bounds.size.width*0.5f, -view.bounds.size.height*0.6f);
    
}

-(IBAction)showDetail:(UITapGestureRecognizer *)sender    {
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
        imageInfo.image = [UIImage imageNamed:@"rooftop2.jpg"];
    imageInfo.referenceRect = sender.view.frame;
    imageInfo.referenceView = sender.view.superview;
    imageInfo.referenceContentMode = sender.view.contentMode;
    imageInfo.referenceCornerRadius = sender.view.layer.cornerRadius;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

-(void)bookNowButtonClicked:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"Book Now"]) {
        [sender setTitle:@"Requested" forState:UIControlStateNormal];
        [self performSelector:@selector(response1:) withObject:sender afterDelay:Delay];
    } else if ([sender.titleLabel.text isEqualToString:@"Pay 10%"]) {
        [sender setTitle:@"Waiting" forState:UIControlStateNormal];
        [self performSelector:@selector(response2:) withObject:sender afterDelay:Delay];
    }
}
-(void)deselectAllAnnotationa {
    for (id currentAnnotation in self.mapView.annotations) {
        if ([currentAnnotation isKindOfClass:[MKPointAnnotation class]]) {
            [self.mapView deselectAnnotation:currentAnnotation animated:YES];
        }
    }
}


-(void)response2:(UIButton *)sender  {
    [sender setTitle:@"Booked" forState:UIControlStateNormal];
    [self performSelector:@selector(deselectAllAnnotationa) withObject:nil afterDelay:2];
    
    
    self.notifTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(notifTimerInvoked) userInfo:nil repeats:false];
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    MKPlacemark *placemark1 = [[MKPlacemark alloc] initWithCoordinate:hotelsCoordiante addressDictionary:nil];
    [request setSource:[[MKMapItem alloc] initWithPlacemark:placemark1]];
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:userCoordinate addressDictionary:nil];
    request.destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    
    
    // [request setDestination:myMapItem];
    [request setTransportType:MKDirectionsTransportTypeAutomobile]; // This can be limited to automobile and walking directions.
    [request setRequestsAlternateRoutes:YES]; // Gives you several route options.
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (!error) {
            if ([response routes].count >0) {
                MKRoute *route = [response routes][0];
                [self.mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];
            }
        }
    }];
    
}

-(void)response1:(UIButton *)sender  {
    [sender setTitle:@"Pay 10%" forState:UIControlStateNormal];
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
    __block int count = 0;
    for  (PlaceInfo *placeObj in _placeList) {
        CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
        [geoCoder geocodeAddressString:[placeObj getCompleteAddress]  completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks.count >0){
                count ++;
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
                [self.mapView setRegion:region];
                [self.mapView addAnnotation:annatationPoint];
                if (count == _placeList.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                        point.title = @"User";
                        point.coordinate = userCoordinate;
                        [self.mapView addAnnotation:point];
                        [self.mapView showAnnotations:self.mapView.annotations animated:true];
                    });
                }
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
