//
//  thumbGenerator.m
//  Homepwner
//
//  Created by Padme on 3/22/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import "thumbGenerator.h"
@implementation thumbGenerator



+(UIImage*) bigImageToThumbnail:(UIImage *)bigImage{
    
    // got big image size
    // create new rect of thumbnail size (ImageView in Xib size)
    // find ratio between those 2 BIG and Small

    // create 2nd context based on those rect
    
    // now we're currently living in context 2
    //  now create the " finalRect"  (auto centered)
    //extract image from context , save
    // quit context
    // now we back to main context
    
    CGSize   bigsize = bigImage.size;
    CGRect   thumbRect = CGRectMake(0, 0, 108, 50);
    
    CGRect finalRect;
    
    CGFloat ratioW =  thumbRect.size.width / bigsize.width ;
    CGFloat ratioH =  thumbRect.size.height / bigsize.height;
    float ratioClosestToBigsize = MAX(ratioW, ratioH);
    
    finalRect = CGRectMake(0, 0, bigsize.height*ratioClosestToBigsize,
                                 bigsize.width *ratioClosestToBigsize);

    
    UIGraphicsBeginImageContextWithOptions(finalRect.size,NO,0.0);
    [bigImage drawInRect:finalRect]; // draw image in SmallRect (While living in SmallContext , to avoid origin confusion)
    
    UIImage* imgFinal = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imgFinal;
}




@end
