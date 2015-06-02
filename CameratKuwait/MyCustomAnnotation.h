//
//  MyCustomAnnotation.h
//  CameratKuwait
//
//  Created by Osama Rabie on 6/2/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyCustomAnnotation : NSObject <MKAnnotation>

@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString* title;
@property (nonatomic,strong) UIImage* image;

-(id)initWithTitle:(NSString*)newTitle location:(CLLocationCoordinate2D)location image:(UIImage*)image;
-(MKAnnotationView*)annotationView;

@end
