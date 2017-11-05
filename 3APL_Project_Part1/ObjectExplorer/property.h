//
//  property.h
//  OC1_v1
//
//  Created by ZHOUYi on 15/5/10.
//  Copyright (c) 2015年 ZHOUYi. All rights reserved.
//

#ifndef OC1_v1_property_h
#define OC1_v1_property_h

@interface Book: NSObject{}
@property(readwrite) NSString *title;
@property(readwrite) int number;
@property(readwrite) double  *description;
@end

@implementation Book
@synthesize title,number,description;
@end
#endif
