//
//  Utils.m
//  Textual OTR
//
//  Created by Joost on 26/01/15.
//  Copyright (c) 2015 Joost. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "Utils.h"

@implementation Utils

+ (const char*) filenameToPath:(NSString *)fname {
    return [[NSHomeDirectory() stringByAppendingString:fname] UTF8String];
}

@end