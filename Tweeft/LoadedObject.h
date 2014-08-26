//
//  LoadedObject.h
//  Tweeft
//
//  Created by Zixuan Li on 8/18/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadedObject : NSObject

@property (nonatomic, strong) NSString *htmlBody;
@property (nonatomic, strong) NSURL *url;

- (id)initWithHtmlBody:(NSString *)html url:(NSURL *)url;

@end
