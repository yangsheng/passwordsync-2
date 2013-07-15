//
//  PSSObjectAttachment.h
//  Password Sync 2
//
//  Created by Remy Vanherweghem on 2013-06-27.
//  Copyright (c) 2013 Pumax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PSSBaseObjectVersion;

@interface PSSObjectAttachment : NSManagedObject

@property (nonatomic, retain) NSData * name;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSSet *encryptedObjectVersions;
@end

@interface PSSObjectAttachment (CoreDataGeneratedAccessors)

- (void)addEncryptedObjectVersionsObject:(PSSBaseObjectVersion *)value;
- (void)removeEncryptedObjectVersionsObject:(PSSBaseObjectVersion *)value;
- (void)addEncryptedObjectVersions:(NSSet *)values;
- (void)removeEncryptedObjectVersions:(NSSet *)values;

@end