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
#import <AVFoundation/AVFoundation.h>
#import "AudioController.h"

#define RAD_TO_DEG(r) ((r) * (180 / M_PI))
#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiandsToDegrees(x) (x * 180.0 / M_PI)

@interface ViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic, strong) NSArray* cameras;
@property (strong, nonatomic) AudioController *audioController;

@end

@implementation ViewController
{
    int lastID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isAbout"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:74.0/255 green:166.0/255 blue:230.0/255 alpha:1.0]];
    
    self.locations = [[NSMutableArray alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    [self.map setDelegate:self];
    [self.map setShowsUserLocation:YES];
    [self.map setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    lastID = 0;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cameras" ofType:@"json"];
    NSError* error2;
    NSString* string = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error2];
    string = [string stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    self.cameras = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    for(NSDictionary* cameraDict in self.cameras)
    {
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[cameraDict objectForKey:@"lat"] floatValue], [[cameraDict objectForKey:@"lng"] floatValue]);
        MyCustomAnnotation* annotation;
        if([[cameraDict objectForKey:@"type"] isEqualToString:@"red light camera"])
        {
            annotation = [[MyCustomAnnotation alloc]initWithTitle:@"كاميرة إشارة حمراء" location:location image:[UIImage imageNamed:@"Ampel.gif"]];
        }else if([[cameraDict objectForKey:@"type"] hasPrefix:@"combination"])
        {
            NSString* title = @"";
            NSString* image = @"";
            if([[cameraDict objectForKey:@"speed"] intValue] == 50)
            {
                title = [NSString stringWithFormat:@"%@ %@ %@",@"كاميرة إشارة حمراء",@"و",@"سرعة 50KMPH"];
                image = @"50Ampel.gif";
            }else if([[cameraDict objectForKey:@"speed"] intValue] == 60)
            {
                title = [NSString stringWithFormat:@"%@ %@ %@",@"كاميرة إشارة حمراء",@"و",@"سرعة 60KMPH"];
                image = @"60Ampel.gif";
            }else if([[cameraDict objectForKey:@"speed"] intValue] == 70)
            {
                title = [NSString stringWithFormat:@"%@ %@ %@",@"كاميرة إشارة حمراء",@"و",@"سرعة 70KMPH"];
                image = @"70Ampel.gif";
            }else if([[cameraDict objectForKey:@"speed"] intValue] == 80)
            {
                title = [NSString stringWithFormat:@"%@ %@ %@",@"كاميرة إشارة حمراء",@"و",@"سرعة 80KMPH"];
                image = @"80Ampel.gif";
            }
            annotation = [[MyCustomAnnotation alloc]initWithTitle:title location:location image:[UIImage imageNamed:image]];
        }else
        {
            
            NSString* title = [NSString stringWithFormat:@"%@ %i %@",@"كاميرة سرعة",[[cameraDict objectForKey:@"speed"] intValue],@"KMPH"];
            
            NSString* image = [NSString stringWithFormat:@"%i%@",[[cameraDict objectForKey:@"speed"] intValue],@"kmh.gif"];
            
            
            
            annotation = [[MyCustomAnnotation alloc]initWithTitle:title location:location image:[UIImage imageNamed:image]];
            
        }
        [self.map addAnnotation:annotation];
    }
    
    
    self.audioController = [[AudioController alloc] init];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isAbout"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isAbout"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self showTabBar:self.tabBarController];
    }
}

- (void)showTabBar:(UITabBarController *)tabbarcontroller
{
    tabbarcontroller.tabBar.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *view in tabbarcontroller.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-49.f, view.frame.size.width, view.frame.size.height)];
            }
            else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height-49.f)];
            }
        }
    } completion:^(BOOL finished) {
        //do smth after animation finishes
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    
    
    for(NSDictionary* dict in self.cameras)
    {
        CLLocation* cameraLoc = [[CLLocation alloc]initWithLatitude:[[dict objectForKey:@"lat"] floatValue] longitude:[[dict objectForKey:@"lng"] floatValue]];
        
        CLLocationDistance itemDist = [cameraLoc distanceFromLocation:newLocation];
        
        if(itemDist < 500)
        {
            if(lastID != [[dict objectForKey:@"id"] intValue])
            {
                lastID = [[dict objectForKey:@"id"] intValue];
                [self.audioController playSystemSound];
                
            }
            break;
        }
    }
    
    // heading > 200
    
    
    
    
    
    
    
    /*CLLocation* carLoc = [[CLLocation alloc]initWithLatitude:29.376211 longitude:47.985641];
     CLLocation* cameraLoc = [[CLLocation alloc]initWithLatitude:29.376440 longitude:47.985572];
     
     NSLog(@"%f -- %f",[carLoc distanceFromLocation:cameraLoc],[self getHeadingForDirectionFromCoordinate:carLoc.coordinate toCoordinate:cameraLoc.coordinate]);
     
     
     CLLocationCoordinate2D coord1 = newLocation.coordinate;
     CLLocationCoordinate2D coord2 = oldLocation.coordinate;
     
     CLLocationDegrees deltaLong = coord2.longitude - coord1.longitude;
     CLLocationDegrees yComponent = sin(deltaLong) * cos(coord2.latitude);
     CLLocationDegrees xComponent = (cos(coord1.latitude) * sin(coord2.latitude)) - (sin(coord1.latitude) * cos(coord2.latitude) * cos(deltaLong));
     
     CLLocationDegrees radians = atan2(yComponent, xComponent);
     CLLocationDegrees degrees = RAD_TO_DEG(radians) + 360;
     
     CLLocationDirection heading = fmod(degrees, 360);
     NSLog(@"loc: %f", heading);*/
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
        // NSLog(@"App is foreground. New location is %@", newLocation);
    }
    else
    {
        //NSLog(@"App is backgrounded. New location is %@", newLocation);
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


- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    float fLat = degreesToRadians(fromLoc.latitude);
    float fLng = degreesToRadians(fromLoc.longitude);
    float tLat = degreesToRadians(toLoc.latitude);
    float tLng = degreesToRadians(toLoc.longitude);
    
    float degree = radiandsToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    
    if (degree >= 0) {
        return degree;
    } else {
        return 360+degree;
    }
}

@end
