//
// Created by David Newman on 3/7/16.
// Copyright (c) 2016 bluefletch. All rights reserved.
//

#import "PETTask.h"


@implementation PETTask {

}

- (instancetype)initWithName:(NSString *)name frequency:(NSTimeInterval)frequency lastPerformed:(NSDate *)lastPerformed nextPerformed:(NSDate *)nextPerformed {
    self = [super init];
    if (self) {
        self.name = name;
        self.frequency = frequency;
        self.lastPerformedDate = lastPerformed;
        self.nextPerformedDate = nextPerformed;
    }

    return self;
}

+ (instancetype)taskWithName:(nonnull NSString *)name frequency:(NSTimeInterval)frequency {
    return [[self alloc] initWithName:name frequency:frequency lastPerformed:[NSDate distantPast] nextPerformed:[NSDate date]];
}

- (enum TaskStatus)status {
    NSTimeInterval interval = _nextPerformedDate.timeIntervalSinceNow;
    if (interval <= 0) {
        return TaskStatusNeedsAttention;
    } else if (interval < _frequency/2) {
        return TaskStatusWillNeedAttention;
    } else {
        return TaskStatusDoesntNeedAttention;
    }
}

+ (instancetype)taskFromDictionary:(nonnull NSDictionary *)dictionary {
    return [[self alloc] initWithName:dictionary[@"name"]
                            frequency:[dictionary[@"frequency"] integerValue]
                        lastPerformed:[[PETTask sharedDateFormatter] dateFromString:dictionary[@"lastPerformedDate"]]
                        nextPerformed:[[PETTask sharedDateFormatter] dateFromString:dictionary[@"nextPerformedDate"]]];
}

- (NSDictionary *)toDictionary {
    NSString *lastPerformedString = [[PETTask sharedDateFormatter] stringFromDate:self.lastPerformedDate];
    NSString *nextPerformedString = [[PETTask sharedDateFormatter] stringFromDate:self.nextPerformedDate];

    return @{@"name" : self.name, @"frequency" : @(self.frequency), @"lastPerformedDate" : lastPerformedString, @"nextPerformedDate" : nextPerformedString};
}

+ (NSDateFormatter *)sharedDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
        });
    }
    return dateFormatter;
}

@end