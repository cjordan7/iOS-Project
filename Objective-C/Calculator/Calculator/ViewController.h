//
//  ViewController.h
//  Calculator
//
//  Created by Cosme Jordan on 01.02.21.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

typedef enum {
    PLUS,
    MINUS,
    TIMES,
    DIVISION,
    PERCENT,
    CHANGE_SIGN,
    EQUAL,
    NONE,
    BUG
} Operations;

@end

