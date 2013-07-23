//
//  PSSLocationMapCell.h
//  Password Sync 2
//
//  Created by Remy Vanherweghem on 2013-07-20.
//  Copyright (c) 2013 Pumax. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;
@import CoreLocation;

@interface PSSLocationMapCell : UITableViewCell <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView * mapView;
@property (strong, nonatomic) MKPointAnnotation * locationPin;

-(void)rearrangePinAndMapLocationWithLocation:(CLLocationCoordinate2D)pinLocation;
-(void)rearrangePinAndMapLocationWithPlacemark:(CLPlacemark*)pinPlacemark;

@end