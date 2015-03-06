//
//  ImageStore.m
//  Homepwner
//
//  Created by Padme on 1/24/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import "ImageStore.h"

// this Class built to Store Image Data


@interface ImageStore ()

@property(strong,nonatomic) NSMutableDictionary* imageStoreDic;

@end

@implementation ImageStore

#pragma mark NSCoding Protocol



#pragma mark LazyInits

-(NSMutableDictionary*) imageStoreDic{
    if(!_imageStoreDic){
        _imageStoreDic = [[NSMutableDictionary alloc]init];
    }
    return _imageStoreDic;
}


#pragma mark Singleton Implementations


+(instancetype) singletonImageStore{
    
        static ImageStore* singletonImageStore = nil;
        static dispatch_once_t token;
        dispatch_once (&token,^{
            singletonImageStore = [[self alloc]initPrivate];
            
        });
    
    return singletonImageStore;
    
}

-(instancetype) initPrivate{
    
    self = [super init];
    if(self){
        BOOL loadImageSuccess = [self loadStore];
        NSLog(@"loadImageSuccess %d",loadImageSuccess);
    }
    return self;
}

-(instancetype) init{
    @throw [NSException exceptionWithName:@"Singleton issue"
                                   reason:@"init not valid for this class"
                                 userInfo:nil];
    return nil;
}


#pragma mark Methods 

// most methods , Just wraping Private @property (to make it "Encapsulated")

-(void) setImage:(UIImage *)image withNameKey:(NSString *)nameKey{
    
    [self.imageStoreDic setValue:image forKey:nameKey];
    
}

-(UIImage*) getImageFromKey:(NSString *)nameKey{
    
    
    /// bug opinion : may be about "NSDAta  vs UIImage type conflict
    if([[self.imageStoreDic objectForKey:nameKey] isKindOfClass:[UIImage class]]){
    return [self.imageStoreDic objectForKey:nameKey];
    }
    return nil;
}
-(void) deleteImageByKey:(NSString *)nameKey{
    
    if(!nameKey){
        return;
    }
    [self.imageStoreDic removeObjectForKey:nameKey];
}

#pragma mark Persistent Methods 

-(BOOL) saveStore{
    
    NSMutableDictionary* secondaryDic = [[NSMutableDictionary alloc]init];
    for(NSString* key in self.imageStoreDic){
        UIImage* image = self.imageStoreDic[key];
        NSData* aData = [NSKeyedArchiver archivedDataWithRootObject:image];
        [secondaryDic setObject:aData forKey:key];
    }
   NSData* tosave =  [NSKeyedArchiver archivedDataWithRootObject:secondaryDic];
   BOOL successSave = [tosave writeToURL:[self DefaultStoreURL] atomically:YES];
    
    return successSave;
}

-(BOOL) loadStore{
    
    NSMutableDictionary* imgDic = [[NSMutableDictionary alloc]init];

    NSData* loaded  = [NSData dataWithContentsOfURL:[self DefaultStoreURL]];
    
    id any = [NSKeyedUnarchiver unarchiveObjectWithData:loaded];
    
    if([any isKindOfClass: [NSMutableDictionary class]]){
        NSLog(@" YO! loading loading = ");
        for(NSString* key in any){
            
            NSData* aData = any[key];
            UIImage* image = [NSKeyedUnarchiver unarchiveObjectWithData:aData];

            [imgDic setObject:image forKey:key];
        }
        self.imageStoreDic = imgDic;
        
        return YES;
    }
    
    return NO;
}

-(NSURL*) DefaultStoreURL{
    NSFileManager* manager = [NSFileManager new];
    NSURL* original = [manager URLForDirectory: NSDocumentDirectory
                      inDomain:NSUserDomainMask
                      appropriateForURL:nil create:YES error:nil];
    NSURL* URLToSave = [original URLByAppendingPathComponent:@"ImageStore"];
    return URLToSave;
}

@end
