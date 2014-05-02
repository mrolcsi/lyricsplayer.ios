//
//  LyricLine.m
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.05.01..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import "LyricLine.h"

@implementation LyricLine

-(id)initWithTime:(double)seconds Lyric:(NSString *)text{
    self = [super init];
    if (self) {
        _time = seconds;
        _lyric = text;
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"T=%f L=%@", _time,_lyric];
}

@end
