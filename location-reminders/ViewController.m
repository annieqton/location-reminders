//
//  ViewController.m
//  location-reminders
//
//  Created by Annie Ton-Nu on 5/1/17.
//  Copyright © 2017 Annie Ton-Nu. All rights reserved.
//

#import "ViewController.h"

#import "AddReminderViewController.h"

@import Parse;
@import MapKit;


@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property(strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    PFObject *testObject = [PFObject objectWithClassName:@"testObject"];
//    
//    testObject[@"testName"] = @"Adam Wallraff";
//    
//    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
//            NSLog(@"Success saving test object.");
//        } else {
//            NSLog(@"There was a problem saving. Save error: %@", error.localizedDescription);
//        }
//    }];
    
    
    //create a query
//    PFQuery *query = [PFQuery queryWithClassName:@"testObject"];
//    
//    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        if(error) {
//            NSLog(@"%@", error.localizedDescription);
//        } else {
//            NSLog(@"Query Reults %@", objects);
//        }
//    }];
    
    [self requestPermissions];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
}

-(void)requestPermissions{
    self.locationManager =[[CLLocationManager alloc]init];
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100;  //meters
    
    self.locationManager.delegate = self;
    
    [self.locationManager requestAlwaysAuthorization];
    
    [self.locationManager startUpdatingLocation];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"AddReminderViewController"] && [sender isKindOfClass:[MKAnnotationView class]]){
        MKAnnotationView *annotationView = (MKAnnotationView *)sender;
        AddReminderViewController *newReminderViewController = (AddReminderViewController *)segue.destinationViewController;  //cast here as AddReminderViewController so it can recognize the 2 properties set in the .h file
        
        newReminderViewController.coordinate = annotationView.annotation.coordinate;
        newReminderViewController.annotationTitle = annotationView.annotation.title;
        newReminderViewController.title = annotationView.annotation.title;

    }
}


- (IBAction)location1Pressed:(id)sender {
    
//    [self.locationManager stopUpdatingLocation];  //this is to stop updating location, problem here is there's no way to restart.
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.6566674, -122.351096);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)location2Pressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.4424882,-122.2308364);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)location3Pressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.618217,-122.3540207);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    [self.mapView setRegion:region animated:YES];
    
}


- (IBAction)userLongPressed:(UILongPressGestureRecognizer *)sender {
    
    if(sender.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchPoint = [sender locationInView:self.mapView];  //give a touch on the map, not the coordinates yet here on this line
        
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
        
        newPoint.coordinate = coordinate;
        newPoint.title =@"New Location";
        
        [self.mapView addAnnotation:newPoint];
        
    }
}



-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = locations.lastObject;
    
    NSLog(@"Coordinate: %f, %f - Altitude: %f", location.coordinate.latitude, location.coordinate.longitude, location.altitude);

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0);
    
    [self.mapView setRegion:region animated:YES];
}



//this method is to take annotation and give it annotationView
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }  //this is to make sure we don't lose our blue glowing dot and not set the annotation to user location
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];  //recycle from the mapview and assign it to annotationView
    
    annotationView.annotation = annotation;  //every annotation has to have coordinates to go with it.  if we reuse it from previous annotation, this
    
    //if annotation is nil, then allocation and init it using the annotationView
    if (!annotationView){
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    }
    
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    
    UIButton *rightCalloutAccessory = [UIButton buttonWithType:UIButtonTypeDetailDisclosure]; //callout button
    annotationView.rightCalloutAccessoryView = rightCalloutAccessory;
    
    return annotationView;
    
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    NSLog(@"Accessory tabpped.");
    
    [self performSegueWithIdentifier:@"AddReminderViewController" sender:view];  //the view is the (MKAnotationView *)view  written above
}




@end







