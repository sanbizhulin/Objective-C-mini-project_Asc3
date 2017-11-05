//
//  WelcomeInterface.h
//  OC1_v1
//
//  Created by ZHOUYi on 15/4/28.
//  Copyright (c) 2015年 ZHOUYi. All rights reserved.
//

#ifndef OC1_v1_WelcomeInterface_h
#define OC1_v1_WelcomeInterface_h
int DisplayWelcomeInterface()
{
    int PressNum;
    NSLog(@"welcome to the Objectvie-C world!\n");
    printf("press 1 to list all avaliable classes;\n press 2 to list all methods of a particular class along with parameters and types;\n press 3 to list instance variables along with their types;\n press 4 to list all properties, with their type and access level;\n press 5 to list explicit protocols implemented by a  class(names only);\n press 6 to list protocol methods, along with parameters and types;\n press 7 to exit\n");
     scanf("%d",&PressNum);
    return PressNum;

}
#endif
