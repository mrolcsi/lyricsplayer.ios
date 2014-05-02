//
//  Lyrics.m
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.04.20..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import "Lyrics.h"
#import "LyricLine.h"

@implementation Lyrics

-(id)initFromLRC:(NSString*) lrc{
    if (self = [super init]){
        NSArray *lrcLines = [lrc componentsSeparatedByString:@"\n"];
        
        _lyricLines = [[NSMutableArray alloc]initWithCapacity:[lrcLines count]];
        [self parseLRCArray:lrcLines];
    }
    return self;
}

-(void)parseLRCArray:(NSArray*)lrcs{
    
    //get lines with LRC tag
    NSString *regexp = @"\\[([0-9]{2}:[0-9]{2}\\.[0-9]{2})](.*)";

    for (NSString *item in lrcs){
        NSString *line =[item stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexp options:0 error:&error];
        
        NSUInteger matchCount = [regex numberOfMatchesInString:line options:0 range:NSMakeRange(0, [line length])];
        
        if (matchCount == 1) {
            NSArray *matches = [regex matchesInString:line options:0 range:NSMakeRange(0, [line length])];
            
            for (NSTextCheckingResult *match in matches) {
                NSRange timeRange = [match rangeAtIndex:1];
                NSRange lyricRange = [match rangeAtIndex:2];
                
                double time = [Lyrics secondsFromTag:[line substringWithRange:timeRange]];
                NSString *lyric = [line substringWithRange:lyricRange];
                
                [_lyricLines addObject:[[LyricLine alloc]initWithTime:time Lyric:lyric]];
            }
        }
    }
    return;
}

+(double)secondsFromTag:(NSString*)tag{
    double seconds = 0;
    
    seconds += [[tag substringWithRange:NSMakeRange(0, 2)] doubleValue] * 60;
    seconds += [[tag substringWithRange:NSMakeRange(3, 2)]doubleValue];
    seconds += [[tag substringWithRange:NSMakeRange(5, 2)]doubleValue] / 100;
    
    return seconds;
}




@end
