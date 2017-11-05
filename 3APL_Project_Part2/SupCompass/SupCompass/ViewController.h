//
//  ViewController.h
//  SupCompass
//
//  Created by Local Administrator on 2/5/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>



@interface ViewController : UIViewController<CLLocationManagerDelegate>

{
    
    CLLocationManager *locManager;
    
}

@property (weak, nonatomic) IBOutlet UILabel *lonLabel;
@property (weak, nonatomic) IBOutlet UILabel *latLabel;
@property (retain, nonatomic) IBOutlet UILabel *disLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;



@property (retain, nonatomic) CLLocationManager *locManager;



@end
