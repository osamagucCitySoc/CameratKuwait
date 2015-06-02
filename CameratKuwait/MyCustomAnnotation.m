//
//  MyCustomAnnotation.m
//  CameratKuwait
//
//  Created by Osama Rabie on 6/2/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "MyCustomAnnotation.h"


@implementation MyCustomAnnotation



-(id)initWithTitle:(NSString*)newTitle location:(CLLocationCoordinate2D)location image:(UIImage*)image
{
    self = [super init];
    
    if(self)
    {
        _title = newTitle;
        _coordinate = location;
        _image = image;
    }
    
    return self;
    
}


-(MKAnnotationView*)annotationView
{
    MKAnnotationView* annotationView = [[MKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"anotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = NO;
    annotationView.image = _image;

    
    return annotationView;
}

@end
