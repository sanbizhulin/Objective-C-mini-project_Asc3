//
//  main.m
//  OC1_v1
//
//  Created by ZHOUYi on 15/4/28.
//  Copyright (c) 2015年 ZHOUYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"
#import "WelcomeInterface.h"
#import "conversion.h"
#import "FooClasstoTestFunction3.h"
#import "property.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        BOOL bigloop = true;
        while(bigloop==true)
{
    int FunctionNum= DisplayWelcomeInterface();
      
        
    if(FunctionNum==1)//list classes
     {
         
        int numClasses;
        Class *classes = NULL;
        
        classes = NULL;
        numClasses = objc_getClassList(NULL,0);//get the total number of classes
        NSLog(@"Number of classes: %d", numClasses);
        
        if(numClasses>0)
        {classes = (__unsafe_unretained Class *)malloc(sizeof(Class) *numClasses);
            numClasses = objc_getClassList(classes, numClasses);
            NSLog(@"now the second number of classses:%d",numClasses);
        
         for (int i=0;i<numClasses;i++)
         {NSLog(@"Class name: %s",class_getName(classes[i]));}
        }//if numClasses
    }//if FunctionNum==1
        
        if(FunctionNum==2)
        {
            NSLog(@"you can type any class has been defined by Objective-C");
            u_int count;
            char str2[20];
            char *arg_type;
            scanf("%s",str2);
            NSString *class_name=[[NSString alloc]initWithUTF8String:str2];
            const char *SecondClassName=[class_name cStringUsingEncoding:NSASCIIStringEncoding];
            Class SecondClass=objc_getClass(SecondClassName);
            Method* methods = class_copyMethodList(SecondClass,&count);
            NSLog(@"%d",count);
            for(int i=0;i<count;i++)
            {
                SEL name= method_getName(methods[i]);
                u_int arg_num =method_getNumberOfArguments(methods[i]);
                NSString *methodName =[NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];//convert to Objective-C string
                if(arg_num>0)
                {
                    for(int j=0;j<arg_num;j++)
                    {
                        char buffer[256];
                        
                        method_getArgumentType(methods[i], j, buffer, 256);
                        arg_type=decode_type_string(buffer);
                        NSLog(@" method %@ has %d argument,its %d parameter's type is %s",methodName,arg_num,j,arg_type);
                    }//for
                    
                }//if arg_num>0
            }//for
        }//if FunctionNum==2
        
       if(FunctionNum==3)
       {
           NSLog(@"There is a class has been defined by author whoose name is Foo , you can type 'Foo' to test this function.Also you can type any class which has been defined by Objective-C");
           u_int  i, count;
           Ivar *ivars;
           const char *name,*encode,*type;
           //char *type;
           char str3[20];
           scanf("%s",str3);
           NSString *classname3=[[NSString alloc]initWithUTF8String:str3];
           const char *ThirdClassName=[classname3 cStringUsingEncoding:NSASCIIStringEncoding];
         Class ThirdClass=objc_getClass(ThirdClassName);
           ivars = class_copyIvarList(ThirdClass,&count);
           for(i=0; i < count;i ++)
           {
               name = ivar_getName(ivars[i]);
               encode = ivar_getTypeEncoding(ivars[i]);
               type = decode_type_string(encode);
               NSLog(@"Ivar #%d name is %s and it's type code is %s\n",i,name,type);
           }//for
       }//if FunctionNum==3
        
        if(FunctionNum==4)
        {
            NSLog(@"There is a class has been defined by author whoose name is Book , you can type 'Book' to test this function.Also you can type any class which has been defined by Objective-C");
            u_int count;
            char *name,*attr,*type,*outputattr;
            char str4[20];
            objc_property_t *props;
            int i;
            scanf("%s",str4);
            NSString *classname4=[[NSString alloc]initWithUTF8String:str4];
            const char *ForthClassName=[classname4 cStringUsingEncoding:NSASCIIStringEncoding];
            Class ForthClass=objc_getClass(ForthClassName);
            props =class_copyPropertyList(ForthClass, &count);
            for(i=0;i<count;i++)
            {
                objc_property_t prop =props[i];
                name = property_getName(prop);
                attr = property_getAttributes(prop);
                outputattr = attr;
                if(attr)
                    attr=strdup(attr);
                type =NULL;
                if(attr)
                {
                    char *equal;
                    attr++;//skips the T++
                    equal = strchr(attr,',');
                    if(equal)
                    {
                        *equal='\0';
                        type= decode_type_string(attr);
                    }//if equal
                }//if attr
                NSLog(@"Property %s has attributes %s and its type is%s\n",name,outputattr,type);
            }//for
        }//if FunctionNum==4
        
        
        if(FunctionNum==5)
        {
            NSLog(@"You could type any class which has been defined by Objective-C");
            unsigned int count;
            char str5[20];
            const char *str;
            scanf("%s",str5);
            NSString *classname5=[[NSString alloc]initWithUTF8String:str5];
            const char *FifthClassName=[classname5 cStringUsingEncoding:NSASCIIStringEncoding];
            Class FifthClass=objc_getClass(FifthClassName);
            Protocol *__unsafe_unretained *protocols_list = class_copyProtocolList(FifthClass, &count);
            Protocol *p;
            for (unsigned int i=0;i<count ;i++) {
                p =protocols_list[i];
                str= protocol_getName(p);
                NSLog(@"%s",str);
            }//for
        }//if FunctionNum==5
        
        if(FunctionNum ==6)
        {
            NSLog(@"You could type any class which has been defined by Objective-C");
            char str6[20];
            u_int  ProtocolCount;
            scanf("%s",str6);
            NSString *classname6=[[NSString alloc]initWithUTF8String:str6];
            const char *SixthClassName=[classname6 cStringUsingEncoding:NSASCIIStringEncoding];
            Class SixthClass=objc_getClass(SixthClassName);
            Protocol *__unsafe_unretained *protocols_list = class_copyProtocolList(SixthClass, &ProtocolCount);
            Protocol *p;
            for(unsigned int i=0;i<ProtocolCount;i++) {
                p =protocols_list[i];
               
                void (^enumerate)(BOOL,BOOL)=^(BOOL isRequired,BOOL isInstance)
                { unsigned int descriptionCount;
                    struct objc_method_description* methodDescriptions = protocol_copyMethodDescriptionList(p, isRequired, isInstance, &descriptionCount);
                    for(int j=0;j<descriptionCount;j++)
                    {
                        struct objc_method_description d=methodDescriptions[j];
                        NSString *methodname=NSStringFromSelector(d.name);
                         Method method = class_getClassMethod(SixthClass, d.name);
                        u_int arg_num6 =method_getNumberOfArguments(method);
                        if(arg_num6>0)
                        {
                            for(int q=0;q<arg_num6;q++)
                            {
                                char buffer6[256],*arg_type;
                                method_getArgumentType(method, q, buffer6, 256);
                                arg_type=decode_type_string(buffer6);
                                NSLog(@"Protocol mehod %@ isRequired =%d isInstance=%d and its #%d parameter's type is %s",methodname,isRequired,isInstance,q,arg_type);                            }
                        }
                        
                    }//for
                 
                };//void
                
                enumerate(YES,YES);
                enumerate(YES,NO);
                enumerate(NO,YES);
                enumerate(NO,NO);
                
            
            }//for
            
        }//FunctionNum ==6
    
    if(FunctionNum==7)
    {
        bigloop =false;
    }
        
      }//bigloop while
    }//autroreleasepool
    return 0;
}//main
