//
//  ImageStore.h
//  Homepwner
//
//  Created by Padme on 1/24/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageStore : NSObject 

+(instancetype) singletonImageStore;

-(void) setImage: (UIImage*) image
         withNameKey: (NSString*) nameKey;

-(UIImage*) getImageFromKey:(NSString*) nameKey;
-(void) deleteImageByKey:(NSString*) nameKey;

-(void) deleteOnlyImageInImageStoreDic:(NSString*)nameKey;

// this two methods called when VC disappear

-(BOOL) saveStoreToPersistent;

//-(BOOL) loadStore;

-(void) clearStore;
-(NSInteger) howmanyCount;
-(NSInteger) howmanyInSandbox;
@end
