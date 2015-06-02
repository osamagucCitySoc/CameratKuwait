//
//  ViewController.m
//  CameratKuwait
//
//  Created by Osama Rabie on 6/2/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MyCustomAnnotation.h"

@interface ViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;
@property (weak, nonatomic) IBOutlet MKMapView *map;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locations = [[NSMutableArray alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    [self.map setDelegate:self];
    [self.map setShowsUserLocation:YES];
    [self.map setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    
    
    MyCustomAnnotation* annotation = [[MyCustomAnnotation alloc]initWithTitle:@"40kmh" location:newLocation.coordinate image:[UIImage imageNamed:@"40kmh.gif"]];
    
    [self.map addAnnotation:annotation];
    
    // Add another annotation to the map.
    /*MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = newLocation.coordinate;
    [self.map addAnnotation:annotation];
    
    // Also add to our map so we can remove old values later
    self.locations = [[NSMutableArray alloc] init];
    [self.locations addObject:annotation];
    
    // Remove values if the array is too big
    while (self.locations.count > 100)
    {
        annotation = [self.locations objectAtIndex:0];
        [self.locations removeObjectAtIndex:0];
        
        // Also remove from the map
        [self.map removeAnnotation:annotation];
    }
    
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive)
    {
        // determine the region the points span so we can update our map's zoom.
        double maxLat = -91;
        double minLat =  91;
        double maxLon = -181;
        double minLon =  181;
        
        for (MKPointAnnotation *annotation in self.locations)
        {
            CLLocationCoordinate2D coordinate = annotation.coordinate;
            
            if (coordinate.latitude > maxLat)
                maxLat = coordinate.latitude;
            if (coordinate.latitude < minLat)
                minLat = coordinate.latitude;
            
            if (coordinate.longitude > maxLon)
                maxLon = coordinate.longitude;
            if (coordinate.longitude < minLon)
                minLon = coordinate.longitude;
        }
        
        MKCoordinateRegion region;
       // region.span.latitudeDelta  = (maxLat +  90) - (minLat +  90);
       // region.span.longitudeDelta = (maxLon + 180) - (minLon + 180);
        
        // the center point is the average of the max and mins
        region.center.latitude  = minLat + region.span.latitudeDelta / 2;
        region.center.longitude = minLon + region.span.longitudeDelta / 2;
        
        // Set the region of the map.
        //[self.map setCenterCoordinate:region.center animated:YES];// setRegion:region animated:YES];*/
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive)
    {
        NSLog(@"App is foreground. New location is %@", newLocation);
    }
    else
    {
        NSLog(@"App is backgrounded. New location is %@", newLocation);
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MyCustomAnnotation class]])
    {
        MyCustomAnnotation* annotation2 = (MyCustomAnnotation*)annotation;
        MKAnnotationView* view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"anotation"];
        if(view == nil)
        {
            view = annotation2.annotationView;
        }else
        {
            view.annotation = annotation;
        }
        
        return view;
    }else
    {
        return nil;
    }
}

@end
