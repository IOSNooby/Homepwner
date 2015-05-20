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
       
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(solveMemory)
               name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
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

-(void) clearStore{
    [self.imageStoreDic removeAllObjects];
}

-(UIImage*) getImageFromKey:(NSString *)nameKey{
    
    // this Method should fetch Image and remove it Immediately
    //if([[self.imageStoreDic objectForKey:nameKey] isKindOfClass:[UIImage class]]){
    //  return [self.imageStoreDic objectForKey:nameKey];
    //}
    
    BOOL successLoadPersistentToStore = [self loadOneStoreItemFromPersistent:nameKey];
    if(successLoadPersistentToStore){
        
        id any = [self.imageStoreDic objectForKey:nameKey];
        if([any isKindOfClass:[UIImage class]]){
            
            UIImage* gotchaImage = any;
            return gotchaImage;
        }
    }
    
    return nil;
}
-(void) deleteImageByKey:(NSString *)nameKey{
        // Only called in IBAction
    if(!nameKey){
        return;
    }
    //
    [self.imageStoreDic removeObjectForKey:nameKey];
    
    NSMutableDictionary* persistentDic = [self summonPersistentDicData];
    
    [persistentDic removeObjectForKey:nameKey];
    
    NSLog(@"(DEBUG) Does Deletion WORK ?  = %lu",(unsigned long)[persistentDic count]);

    [self writeToPersistentLocation:persistentDic];
    
}

-(void) deleteOnlyImageInImageStoreDic:(NSString*) nameKey{
    [self.imageStoreDic removeObjectForKey:nameKey];

}


#pragma mark Persistent Methods 
// Load and Save To Persistents


// called in viewWillDisappear
-(BOOL) saveStoreToPersistent{
    // boolean PersistDic + self.imageStoreDic
    NSMutableDictionary* secondaryDic = [[NSMutableDictionary alloc]init];
    
    if([self.imageStoreDic count]){
        NSLog(@"Does self.imageStoreDic count before VC Disappear ?? =  %lu",
              (unsigned long)[self.imageStoreDic count]);

    for(NSString* key in self.imageStoreDic){
        UIImage* image = self.imageStoreDic[key];
        NSData* aData = [NSKeyedArchiver archivedDataWithRootObject:image];
        [secondaryDic setObject:aData forKey:key];
        
      }
    }
    
    NSMutableDictionary* persistentDic = [self summonPersistentDicData];
   // NSLog(@"Persistent Situation 111 = %@",persistentDic);

    [persistentDic addEntriesFromDictionary:secondaryDic];
    
  //  NSLog(@"Persistent Situation = %@",persistentDic);

    
    BOOL success = [self writeToPersistentLocation:persistentDic];
    return success;
}

-(BOOL) writeToPersistentLocation: (NSMutableDictionary*) dicToWrite {
    NSData* tosave =[NSKeyedArchiver archivedDataWithRootObject:dicToWrite];
    BOOL success = [tosave writeToURL:[self DefaultStoreURL] atomically:YES];
    NSLog(@"Success Write to Persistent = %i",success);
    return  success;
}

-(BOOL) loadOneStoreItemFromPersistent:(NSString*) uuidInput{
    
    // Loading One item from persistent to self.imageStoreDic
    // this method Expected "The item , alrdy - has - image - in Sandbox"
    
    if(!self.imageStoreDic[uuidInput]){ // if Key not exist in imageDic - LoadFromSandbox
        
        NSMutableDictionary* persistentDataBunch = [self summonPersistentDicData];
        NSData* gotSingleImageData = persistentDataBunch[uuidInput];
        if(gotSingleImageData){
            
            id someArchiveGot = [NSKeyedUnarchiver unarchiveObjectWithData:gotSingleImageData];
            if([someArchiveGot isKindOfClass:[UIImage class]]){
                UIImage* someImageGot = someArchiveGot;
                self.imageStoreDic[uuidInput] = someImageGot;
                return YES;
            }
        }
    }else if(self.imageStoreDic[uuidInput]) {
        return YES;
    }
    return NO;
}

#pragma mark Persistent Helpers
// For Short and Readable Codes


/// BUG HERE , work wrong
-(NSMutableDictionary*) summonPersistentDicData{
    // this Method return Dictionary contains NSData of Images
    // this Method called alot (in save and load methods)
    NSMutableDictionary* allImageDataDic;
    
    NSData* allDataFromPersistent = [NSData dataWithContentsOfURL:[self DefaultStoreURL]];
    
   // NSLog(@"NSData you got from Persistent = %@",allDataFromPersistent);

    id any = [NSKeyedUnarchiver unarchiveObjectWithData:allDataFromPersistent];
    // if any == nil , mean this is first time app create persistent
    //    create EMPTY dictionary and save to pessistent
    
    if(any == nil){
        [self whenPersistentNeverCreateDicbeforeMakeOne:any];
    }
    
    //NSLog(@"ANY IS CLASS %@",NSStringFromClass(any));
    
    if([any isKindOfClass:[NSMutableDictionary class]]){
        NSLog(@" Hybernated Persistent is NSMutableDictionary class type");
         allImageDataDic = any;
         return allImageDataDic;
    }
    return nil;
}

-(NSURL*) DefaultStoreURL{
    NSFileManager* manager = [NSFileManager new];
    NSURL* original = [manager URLForDirectory: NSDocumentDirectory
                                      inDomain:NSUserDomainMask
                             appropriateForURL:nil create:YES error:nil];
    NSURL* URLToSave = [original URLByAppendingPathComponent:@"ImageStore"];
    return URLToSave;
}
-(void) autoCreateFolderForURLwhenitsnotexist:(NSURL*) url{
    NSFileManager* manager = [NSFileManager new];
    NSURL* wantSaveHere = [self DefaultStoreURL];
    NSString* path = [wantSaveHere path];
   BOOL doesExist = [manager fileExistsAtPath:path];
    NSLog(@"Does path exist ?????? %i" ,doesExist);
    if(!doesExist){
        [manager createDirectoryAtURL:url
          withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
}

#pragma mark MemoryWarning

-(void) solveMemory{
    // if memoryWarning from APP center sent
    
    NSLog(@"Memory Empty = ");

    [self.imageStoreDic removeAllObjects];
    NSNotificationCenter* a = [NSNotificationCenter defaultCenter];
    [a removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

#pragma mark SolveBug Method (Update version 0.01)

// this version solve bug "Persistent Never save any dictionary so we got a NIL and Appcrash"
// solve by creating Empty dictionary and saved it to persistent , so the App has some Dic to do his job

-(void) whenPersistentNeverCreateDicbeforeMakeOne: (id) unknowtypeFileFetchFromHDD{
    // this method should be called only once since app installed to iPhones
    if(unknowtypeFileFetchFromHDD == nil){
        
        NSMutableDictionary* emptyDic = [NSMutableDictionary new];
        NSURL* urlToSave = [self DefaultStoreURL];
        NSData* dataToSave = [NSKeyedArchiver archivedDataWithRootObject:emptyDic];
        [dataToSave writeToURL:urlToSave atomically:YES];
    }
}

#pragma mark Debugging methods
/// REMOVE IN DEPLOY VERSION (ONLY USE IN NSLOG)
-(NSInteger) howmanyCount{
   return  [self.imageStoreDic count];
}
-(NSInteger) howmanyInSandbox{
    return [[self summonPersistentDicData] count];
}

@end
