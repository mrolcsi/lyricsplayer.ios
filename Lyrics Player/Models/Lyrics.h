//
//  Lyrics.h
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.04.20..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lyrics : NSObject

-(id)initFromLRC:(NSString*) lrc;
-(id)initFromHTML:(NSString*) html;

@end
