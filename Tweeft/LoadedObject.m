//
//  LoadedObject.m
//  Tweeft
//
//  Created by Zixuan Li on 8/18/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "LoadedObject.h"

@implementation LoadedObject

- (id)initWithHtmlBody:(NSString *)html url:(NSURL *)url {
    
    self = [super init];
    if (self) {
        
        _htmlBody = html;
        _url = url;
        
    }
    
    return self;
    
}

@end
