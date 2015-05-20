//
//  INWitem.h
//  Homepwner
//
//  Created by Zenjougahara on 12/10/14.
//  Copyright (c) 2014 Zenjougahara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface INWitem : NSObject <NSCoding>

@property (nonatomic,strong) NSString* itemName;
@property (nonatomic,strong) NSString* serialNumber;

@property (nonatomic,strong) NSNumber* valueInDollars;
@property (nonatomic,strong) NSDate* dateCreated;

@property (strong,nonatomic,readonly) NSString* myUUID;

@property (nonatomic) BOOL hasImage;

@property (strong,nonatomic) UIImage* thumb;

//+(INWitem*) randomItem;
+(INWitem*) createBlankItem;



@end
