//
//  thumbStore.m
//  Homepwner
//
//  Created by Padme on 3/18/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import "thumbStore.h"

@implementation thumbStore



#pragma mark init Methods

-(instancetype) init {
    NSException* ex = [[NSException alloc]initWithName:@"YO"
                       reason:@"This Class is singleton , you cant breed it"
                       userInfo:nil];
    @throw ex;
    return nil;
}

-(instancetype) initWithPrivate{
    
    self = [super init];
    if(self){
        
    }
    return self;
}

#pragma mark Getter Setter
// very encapsulated
-(NSMutableDictionary*) getImageDic{
    
    if(!_imageDic){
        _imageDic =  [NSMutableDictionary new];
    }
    
    return _imageDic ;
}

-(void) setImageDic:(NSMutableDictionary *)imageDic{
    _imageDic =imageDic;
}

#pragma mark SingleTon
+(thumbStore*) sharedStore{
    
    static thumbStore* mystore = nil;
    static dispatch_once_t token;
    dispatch_once(&token,^{
        mystore = [[thumbStore alloc]initWithPrivate];
    });
    return mystore;
}

#pragma mark Add / Remove 



-(void) addImageToDic:(UIImage*) image
         WithKey:(NSString*) UUID {
    
    [self.imageDic setObject:image forKey:UUID];
}

-(void) removeImageFromDic:(NSString*) UUID{
    // use in Deletion
    
    [self.imageDic removeObjectForKey: UUID];
    
}

-(void) restoreImageToDic : (NSString*) uuid{
    // use to optimize memory
    // run everytime the cell appeared
    UIImage* image = [self loadFromPersistentByKey:uuid];
    [self addImageToDic:image WithKey:uuid];
}


#pragma mark Persistent Methods 

-(void) removeFromPersistent:(NSString*) uuid{
    NSFileManager* ma = [NSFileManager defaultManager];
    [ma removeItemAtURL:[self generateURLForParticularImage:uuid]
                  error:nil];
}

-(void) saveToPersistent : (UIImage*) image
                 WithKey : (NSString*)uuid{
    
    NSData* imgData = UIImagePNGRepresentation(image);
    [imgData writeToURL:[self generateURLForParticularImage:uuid]
             atomically:YES];
}

-(UIImage*) loadFromPersistentByKey : (NSString*) uuid{
    UIImage* image;
    NSURL* place = [self generateURLForParticularImage:uuid];
    NSData* aData = [NSData dataWithContentsOfURL:place];
   id unknow  =  [NSKeyedUnarchiver unarchiveObjectWithData:aData];
    if([unknow isKindOfClass:[UIImage class]]){
         image = unknow;
    }
    return image;
}



#pragma mark Data Sources

-(NSURL*) defaultSaveURL{
    NSFileManager* manager  = [NSFileManager defaultManager];
    NSURL* original = [manager URLForDirectory:NSDocumentDirectory
                       inDomain:NSUserDomainMask appropriateForURL:nil
                              create:YES error:nil];
    NSURL* placeForThumb = [original URLByAppendingPathComponent:@"thumbStore"];
    return placeForThumb;

}

#pragma mark Helper Methods


// "Save one by one paradigm"

-(NSURL*) generateURLForParticularImage : (NSString*) uuid{
    NSURL* placeOfFile =  [[self defaultSaveURL] URLByAppendingPathComponent:uuid];
    return placeOfFile;
}

#pragma mark Unused Methods (Old ver.)

//  "Save All at once" paradigm   (May not use)
// should call this at beginning

-(void) createEmptyPersistentInSSD{
    // if You never create Empty dic , make one.
    NSMutableDictionary* dic;
    
    NSData* gotData = [NSData dataWithContentsOfURL:[self  defaultSaveURL]];
    id anyfile = [NSKeyedUnarchiver unarchiveObjectWithData:gotData];
    if([anyfile isKindOfClass:[NSMutableDictionary class]]){
        dic = anyfile;
    }
    if(dic  == nil){
        // make empty dic to fetch at initial
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [data writeToURL:[self defaultSaveURL] atomically:YES];
    };
    
}

@end
