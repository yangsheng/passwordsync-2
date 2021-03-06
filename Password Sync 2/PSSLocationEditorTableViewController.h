//
//  PSSLocationEditorTableViewController.h
//  Password Sync 2
//
//  Created by Remy Vanherweghem on 2013-07-18.
//  Copyright (c) 2013 Pumax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSSLocationBaseObject.h"
#import "PSSObjectEditorProtocol.h"
@import CoreLocation;

@protocol PSSPasswordGeneratorTableViewControllerProtocol;

@interface PSSLocationEditorTableViewController : UITableViewController <PSSPasswordGeneratorTableViewControllerProtocol, CLLocationManagerDelegate>

@property (strong, nonatomic) PSSLocationBaseObject * locationBaseObject;
@property (weak, nonatomic) id<PSSObjectEditorProtocol> editorDelegate;

@end
