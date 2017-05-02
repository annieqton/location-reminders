//
//  AddReminderViewController.h
//  location-reminders
//
//  Created by Annie Ton-Nu on 5/2/17.
//  Copyright © 2017 Annie Ton-Nu. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@interface AddReminderViewController : UIViewController

@property(strong, nonatomic) NSString *annotationTitle;
@property(nonatomic) CLLocationCoordinate2D coordinate;  //because it's a struct, no strong or weak reference


@end
