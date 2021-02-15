//
//  PerlinNoise.h
//  MapGenerator
//
//  Created by Cosme Jordan on 07.02.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PerlinNoise : NSObject

@property double persistence;
@property double frequency;
@property double amplitude;
@property int octave;
//TODO 
//int randomSeed;

@end

NS_ASSUME_NONNULL_END
