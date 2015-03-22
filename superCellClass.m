//
//  superCellClass.m
//  Homepwner
//
//  Created by Padme on 3/15/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import "superCellClass.h"

@implementation superCellClass

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel*) textLabel{
    return nil;
}

-(UILabel*) detailTextLabel{
    return nil;
}
-(UIImageView*) imageView{
    return nil;
}

-(void) setThumbnailFromImage:(UIImage*) imageOriginal{
    
    CGSize originalSize = imageOriginal.size;
    CGRect thumbRect = CGRectMake(0, 0, 40, 40);
    float ratio = MAX(thumbRect.size.width / originalSize.width,
                      thumbRect.size.height / originalSize.height);
    
    UIGraphicsBeginImageContextWithOptions(thumbRect.size, NO, 0.0);
    UIBezierPath* pathToCut = [UIBezierPath bezierPathWithRoundedRect:thumbRect cornerRadius:5.0];
    [pathToCut addClip];  // everything below this will be clip (aka. "masked" in PTS)
    
    CGRect AfterRatioCalculation;  // Because those 40x40 may not fit the image (unknow ratio) ex. image is 100x500 = 1:5
    AfterRatioCalculation.size.width = originalSize.width * ratio;
    AfterRatioCalculation.size.height = originalSize.height *ratio;
    
    AfterRatioCalculation.origin.x = (thumbRect.size.width - AfterRatioCalculation.size.width) /2.0;
    AfterRatioCalculation.origin.y = (thumbRect.size.height - AfterRatioCalculation.size.height) /2.0;
    
    [imageOriginal drawInRect:AfterRatioCalculation];
    UIImage* smallImage  = UIGraphicsGetImageFromCurrentImageContext();
    
    self.imageThumb.image = smallImage;
    
}


@end
