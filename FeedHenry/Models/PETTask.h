//
// Created by David Newman on 3/7/16.
// Copyright (c) 2016 bluefletch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TaskStatus) {
    TaskStatusNeedsAttention, TaskStatusWillNeedAttention, TaskStatusDoesntNeedAttention
};

@interface PETTask : NSObject

NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDate *lastPerformedDate;
@property (nonatomic, strong) NSDate *nextPerformedDate;
@property (nonatomic) NSTimeInterval frequency;
@property (nonatomic, readonly) TaskStatus status;

- (instancetype)initWithName:(NSString *)name frequency:(NSTimeInterval)frequency lastPerformed:(NSDate *)lastPerformed nextPerformed:(NSDate *)nextPerformed;
+ (instancetype)taskWithName:(nonnull NSString *)name frequency:(NSTimeInterval)frequency;

+ (instancetype)taskFromDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)toDictionary;
NS_ASSUME_NONNULL_END

@end