//
//  PerlinNoise.m
//  MapGenerator
//
//  Created by Cosme Jordan on 07.02.21.
//

#import "PerlinNoise.h"

@implementation PerlinNoise {

}

-(double) lerp:(double)x :(double)y alpha:(double)alpha {
    return alpha*(y-x) + x;
}

-(double) cerp:(double)x :(double)y alpha:(double)alpha{
    double piAlpha = alpha*M_PI;
    double g = (1 - cos(piAlpha))/2;

    return (1-g)*x + g*y;
}

-(double) sCurve:(double)t {
    return ( t * t * (3. - 2. * t) );
}

//- (float)makeNoise2D:(int)x :(int)y {
//    int n = x + y * 57;
//    n = (n >> 13) ^  (n * _functionSelector);
//    n = (n * (n * n * (int)_seed + 19990303) + 1376312589) & RAND_MAX;
//    return ( 1.0 - ( (n * (n * n * 15731 + 789221) + 1376312589) & RAND_MAX) / 1073741824.0);
//}

-(double) simpleNoise2D:(int) x :(int) y {
    int n = x + y * 257;
    n = (n << 13) ^ n;
    return (1.0 - ((n * (n * n * 15731 + 789221) + 1376312589) &
                    0x7fffffff) / 1073741824.0);
}

-(double) createNoise2D:(int)x :(int)y {



    return 0.0;
}

-(double) perlin2D:(int)x :(int)y {
    
}

@end
