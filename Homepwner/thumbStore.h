//
//  thumbStore.h
//  Homepwner
//
//  Created by Padme on 3/18/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface thumbStore : NSObject

@property(strong,nonatomic,readonly) NSMutableDictionary* imageDic;

+(thumbStore*) sharedStore;

#pragma mark Add/Remove

-(void) addImageToDic:(UIImage*) image
         WithKey:(NSString*) UUID;

-(void) removeImageFromDic:(NSString*) UUID;

-(void) restoreImageToDic :(NSString*) UUID;

#pragma mark Persistent Methods
// use as cobination with above add/remove

-(void) removeFromPersistent:(NSString*) uuid;

-(void) saveToPersistent : (UIImage*) image
                 WithKey : (NSString*)uuid;

-(UIImage*) loadFromPersistentByKey : (NSString*) uuid;


#pragma mark special methods

-(void) createEmptyFolderForThumbstoreWhenAppInstalled;

#pragma mark DEBUGGING


@end
