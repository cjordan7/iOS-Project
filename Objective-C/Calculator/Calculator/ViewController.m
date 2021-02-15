//
//  ViewController.m
//  Calculator
//
//  Created by Cosme Jordan on 01.02.21.
//

#import "ViewController.h"

@interface ViewController() {
    NSDecimalNumber* leftOperand;
    NSDecimalNumber* rightOperand;
    Operations pendingOperation;

    BOOL isShowingCalculationClear;

    NSDecimalNumber* hundred;
}

@property (strong, nonatomic) IBOutlet UILabel* showingCalculation;
@property (strong, nonatomic) IBOutlet UIButton* clearButtonLabel;

@end

@implementation ViewController

-(IBAction)touchDigit:(UIButton*)sender {
    NSString* temp = _showingCalculation.text;

    if(![sender.titleLabel.text isEqualToString:@"0"]) {
        [self setClear];
    }

    if([temp isEqualToString:@"0"] || isShowingCalculationClear) {
        isShowingCalculationClear = false;
        [self addPoint:temp sender:sender];
    } else {
        if(!([sender.titleLabel.text isEqualToString:@"."] &&
           [_showingCalculation.text containsString:@"."])) {
            _showingCalculation.text = [temp stringByAppendingString: sender.titleLabel.text];
        }
    }
}

-(void)setClear {
    [_clearButtonLabel setTitle:@"C" forState:UIControlStateNormal];
}

-(NSDecimalNumber*)getNSDecimalNumber:(NSString*)stringNumber {
    return [NSDecimalNumber decimalNumberWithString:stringNumber];
}

-(IBAction)clear:(UIButton*)sender {
    [_clearButtonLabel setTitle:@"AC" forState:UIControlStateNormal];
    _showingCalculation.text = @"0";
    leftOperand = nil;
    rightOperand = nil;
    pendingOperation = NONE;
    isShowingCalculationClear = false;
}

-(void)addPoint:(NSString*)string sender:(UIButton*)sender {
    if([sender.titleLabel.text isEqualToString:@"."]) {
        _showingCalculation.text = [string stringByAppendingString: sender.titleLabel.text];
    } else {
        _showingCalculation.text = sender.titleLabel.text;
    }
}

-(IBAction)touchButtonDoCalculations:(UIButton *)sender {
    Operations operation = [self getOperations:sender.titleLabel.text];
    //leftOperand = [self setIfNil:leftOperand operation:operation];
    NSDecimalNumber* number = [self getNSDecimalNumber:_showingCalculation.text];
    [self doBinaryOperation:pendingOperation number:number];
    [self keepPrevious:operation];
    [self doUnaryOperation:operation number:number];
}

-(void)doUnaryOperation:(Operations)operation number:(NSDecimalNumber*)number {
    switch(operation) {
        case CHANGE_SIGN: {
            NSDecimalNumber* minus = [NSDecimalNumber.zero decimalNumberBySubtracting:number];
            _showingCalculation.text = [minus stringValue];
        }
            break;
        case PERCENT: {
            NSDecimalNumber* percent = [number decimalNumberByDividingBy:hundred];
            _showingCalculation.text = [percent stringValue];
        }
            break;
        case BUG:
            [self bugOperation];
            break;
        default:
            break;
    }
}

-(void)keepPrevious:(Operations)operation {
    switch(operation) {
        case PLUS:
        case MINUS:
        case TIMES:
        case DIVISION:
            pendingOperation = operation;
            break;
        case CHANGE_SIGN:
        case PERCENT:
        case EQUAL:
        case NONE:
            pendingOperation = NONE;
            break;
        case BUG:
            [self bugOperation];
            break;
    }
}

-(void)doBinaryOperation:(Operations)operation number:(NSDecimalNumber*)number{
    switch(operation) {
        case PLUS:
            leftOperand = [leftOperand decimalNumberByAdding:number];
            _showingCalculation.text = [leftOperand stringValue];

            break;
        case MINUS:
            leftOperand = [leftOperand decimalNumberBySubtracting:number];
            _showingCalculation.text = [leftOperand stringValue];

            break;
        case CHANGE_SIGN:
            break;
        case PERCENT:
            break;
        case TIMES:
            leftOperand = [leftOperand decimalNumberByMultiplyingBy:number];
            _showingCalculation.text = [leftOperand stringValue];

            break;
        case DIVISION:
            leftOperand = [leftOperand decimalNumberByDividingBy:number];
            _showingCalculation.text = [leftOperand stringValue];

            break;
        case EQUAL:
            _showingCalculation.text = [leftOperand stringValue];

            break;
        case NONE: {
            NSDecimalNumber* number = [self getNSDecimalNumber:_showingCalculation.text];
            leftOperand = number;
        }
            break;
        case BUG:
            [self bugOperation];
            break;
    }

    isShowingCalculationClear = true;
}

-(void)bugOperation {
    @throw [NSException exceptionWithName:@"Bug Exception"
                                   reason:@"Operations variable is set to bug. That should not happen."
                                 userInfo:nil];
}

-(Operations)getOperations:(NSString*)stringOperation {
    Operations op = BUG;

    if([stringOperation isEqualToString:@"+/-"]) {
        op = CHANGE_SIGN;
    } else if([stringOperation isEqualToString:@"%"]) {
        op = PERCENT;
    } else if([stringOperation isEqualToString:@"/"]) {
        op = DIVISION;
    } else if([stringOperation isEqualToString:@"x"]) {
        op = TIMES;
    } else if([stringOperation isEqualToString:@"+"]) {
        op = PLUS;
    } else if([stringOperation isEqualToString:@"-"]) {
        op = MINUS;
    } else if([stringOperation isEqualToString:@"="]) {
        op = EQUAL;
    }

    if(op == BUG) {
        [self bugOperation];
    }

    return op;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    leftOperand = nil;
    rightOperand = nil;
    pendingOperation = NONE;
    isShowingCalculationClear = false;

    hundred = [[NSDecimalNumber alloc] initWithDouble:100.0];
}

@end
