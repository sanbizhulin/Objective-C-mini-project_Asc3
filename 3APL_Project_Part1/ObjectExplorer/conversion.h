//
//  conversion.h
//  OC1_v1
//
//  Created by ZHOUYi on 15/4/29.
//  Copyright (c) 2015年 ZHOUYi. All rights reserved.
//

#ifndef OC1_v1_conversion_h
#define OC1_v1_conversion_h
const char *decode_type_char(char c)
{
    switch(c){
        case 'c':
            return("char");
            break;
        case 'C':
            return("unsigned char");
            break;
        case 'i':
            return("int");
            break;
        case 'I':
            return("unsigned int");
            break;
        case 'l':
            return("long");
            break;
        case 'L':
            return("unsigned long");
            break;
        case 'f':
            return("float");
            break;
        case 'd':
            return("double");
            break;
        case 'B':
            return("bool");
            break;
        case 'v':
            return("void");
            break;
        case '*':
            return("char*");
            break;
        case '@':
            return("Object");
            break;
        case '#':
            return("Class");
            break;
        case ':':
            return("SEL");
            break;
        default:
            return("Complex or unknown");
    }
}
char *decode_type_string(char *type_str)
{
     char *rv = NULL;
    if(type_str && strlen(type_str)){
        if(*type_str == '^'){
            char *tmp;
            tmp = decode_type_string(type_str+1);
            asprintf(&rv, "pointer to %s",tmp);
            free(tmp);
        }else{
            rv = strdup(decode_type_char(*type_str));
        }
    }
    return(rv);
}

#endif
