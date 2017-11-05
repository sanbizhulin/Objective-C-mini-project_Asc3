//
//  ViewController.m
//  SupCompass
//
//  Created by Local Administrator on 2/5/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "PointCampus.h"

@interface ViewController (){
    NSString *campusName;
    NSString *mindistanceCampusName;
    double mindistance;
    float loclongitude;
    float loclatitude;
}

@end

@implementation ViewController
@synthesize lonLabel;
@synthesize latLabel;
@synthesize disLabel;
@synthesize nameLabel;
@synthesize locManager;

PointViewController *PointCompass;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Create the image for the compass
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 130, 100, 100)];
    arrowImageView.image = [UIImage imageNamed:@"arrow.png"];
    [self.view addSubview:arrowImageView];
    
    PointCompass = [[PointViewController alloc] init];
    
    // Add the image to be used as the compass on the GUI
    [PointCompass setArrowImageView:arrowImageView];
    
    // Set the coordinates of the location to be used for calculating the angle
    
	//init and config locmanager
    locManager = [[CLLocationManager alloc]init];
    locManager.delegate = self;
    locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locManager.distanceFilter = 100;
    //start service
    [locManager startUpdatingLocation];
}


- (void)viewDidUnload
{
    
    [self setLonLabel:nil];
    [self setLatLabel:nil];
    [self setDisLabel:nil];
    [self setNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (void)dealloc {
    //stop service
    [locManager stopUpdatingLocation];
    //[super dealloc];
}




//when location updating use this method
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //coordinate
    CLLocationCoordinate2D loc = [newLocation coordinate];
    loclongitude = loc.longitude;
    loclatitude = loc.latitude;
    self.lonLabel.text = [NSString stringWithFormat:@"%f",loclongitude];
    self.latLabel.text = [NSString stringWithFormat:@"%f",loclatitude];
    
    //read the data
    NSString *path = [[NSBundle mainBundle]pathForResource:@"row-campus" ofType:@"txt"];
    
    //get the contents of file
    NSString *filecontents = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF16StringEncoding error:nil];
    //get the data line by line
    NSArray *linebyline = [filecontents componentsSeparatedByString:@"\n"];
    NSMutableArray *lines=[[NSMutableArray alloc] init];
    for (int i=0;i<[linebyline count];i++)
    {
        NSArray *one=[[linebyline objectAtIndex:i] componentsSeparatedByString:@"$$"]; 
        [lines addObject:one];
    }
    mindistance = 1000;
    for (NSArray *line in lines) {
        //new array for one line
        NSString * URL=[[NSString alloc]initWithFormat:@"http://dev.virtualearth.net/REST/v1/Locations/%@?&o=xml&key=AtrAzAN_IoIT9VLYHsQaRGhDpb7zPRee60FjoE-D1eYOa2EsDzuBi2v45ipbtLL3",[line objectAtIndex:0]];
        URL=[URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *req=[NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
        NSError *ERR=nil;
        NSData* data=[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&ERR];
        NSString *res=[[NSString alloc] initWithData:data encoding:
                       NSUTF8StringEncoding];
        NSRegularExpression *reg=[NSRegularExpression regularExpressionWithPattern:@"(?<=Point><Latitude>).*(?=</Longitude></Point>)" options:0 error:&ERR];
        NSString *result;
        if(reg!=nil)
        {
            NSTextCheckingResult *match=[reg firstMatchInString:res options:0 range:NSMakeRange(0, [res length])];
            if(match)
            {
                NSRange resultRange=[match rangeAtIndex:0];
                result=[res substringWithRange:resultRange];
            }
        }
        
        
        NSArray *coo=[result componentsSeparatedByString:@"</Latitude><Longitude>"];
        if([coo count]==2)
        {
        //hDp/ Get the coordinate of every campus
        NSString *deslongtitude = [coo objectAtIndex:0];
        double camlongtitude = [deslongtitude doubleValue];
        NSString *deslatitude = [coo objectAtIndex:1];
        double camlatitude = [deslatitude doubleValue];
        
        //Calculate the distance between current location and current 
        double distance = sqrt( pow((loclongitude-camlongtitude),2)+pow((loclatitude-camlatitude), 2));
        //CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:loclatitude longitude:loclongitude];
        //CLLocation *desLocation = [[CLLocation alloc] initWithLatitude:camlatitude longitude:camlongtitude];
        //CLLocationDistance d = [curLocation distanceFromLocation:desLocation];
        //double distance = d;
        campusName = [line objectAtIndex:0];
        if(distance < mindistance )
        {
            //Compare the distance with the minimum distance
            mindistance = distance;
            mindistanceCampusName = campusName;
        }
        
        }
    }
    self.disLabel.text = [NSString stringWithFormat:@"%f",mindistance];
    self.nameLabel.text = [NSString stringWithString:mindistanceCampusName];
}



//当位置获取或更新失败会调用的方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorMsg = nil;
    if ([error code] == kCLErrorDenied) {
        errorMsg = @"访问被拒绝";
    }
    if ([error code] == kCLErrorLocationUnknown) {
        errorMsg = @"获取位置信息失败";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Location" 
                                                      message:errorMsg delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
    [alertView show];
    //[alertView release];
}


@end