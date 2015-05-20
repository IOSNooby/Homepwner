//
//  myTransformer.m
//  Homepwner
//
//  Created by Padme on 5/18/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import "myTransformer.h"
#import <UIKit/UIKit.h>
@implementation myTransformer

// Data source
// What type to transform to ?
+(Class)transformedValueClass{
    return [NSData class];
}



-(id) transformedValue:(id)value{
    
    if(!value){
        return nil;
    }
    if([value isKindOfClass:[NSData class]]){
        // if value is NSData , no need to convert
        return value;
    }
    return  UIImagePNGRepresentation(value);
    
}

-(id) reverseTransformedValue:(id)value{
    return [UIImage imageWithData:value];
}

@end
