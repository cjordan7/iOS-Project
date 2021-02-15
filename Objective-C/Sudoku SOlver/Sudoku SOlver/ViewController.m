//
//  ViewController.m
//  Sudoku SOlver
//
//  Created by Cosme Jordan on 04.02.21.
//

#import "ViewController.h"
#import "Model/Sudoku.h"

#define MINIMUM_DIFFICULTY 33
#define MAXIMUM_DIFFICULTY 60

typedef struct {
    int x;
    int y;
} Coordinate;

@interface ViewController () {
    SudokuSolutions currentSudoku;
    Sudoku* sudoku;
    int currentDifficulty;
    BOOL hasCurrentDifficultyChanged;
}

@property (strong, nonatomic) NSMutableArray* buttons;
@property (strong, nonatomic) NSMutableArray* touchButtons;
@property (strong, nonatomic) NSMutableArray* choiceButtons;
@property (strong, nonatomic) NSMutableArray* difficultyButtons;
@property (strong, nonatomic) UIButton* temp;

@property (strong, nonatomic) UILabel* level;

@property (strong, nonatomic) NSMutableArray* currentSolution;

@end

@implementation ViewController

- (UIButton*)createAButton:(NSString*)title selector:(SEL)selector {
    UIButton* button = [[UIButton alloc] init];
    button.layer.borderColor = UIColor.blackColor.CGColor;
    button.layer.borderWidth = 1;
    button.titleLabel.font = [UIFont systemFontOfSize:35];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];

    return button;
}

- (NSArray*)createButtons:(int)number :(int)k selector:(SEL)selector{
    NSMutableArray* array = [[NSMutableArray alloc] init];

    for(int i = k; i < number+k; ++i) {
        UIButton* button = [[UIButton alloc] init];
        button.layer.borderColor = UIColor.blackColor.CGColor;
        button.layer.borderWidth = 1;
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:35];
        NSString* title = [NSString stringWithFormat:@"%d", i];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [[button layer] setMasksToBounds:YES];
        [array addObject:button];
    }

    return [NSArray arrayWithArray:array];
}

- (UIStackView*)createGrid {
    UIStackView* stack4 = [[UIStackView alloc] init];

    stack4.axis = UILayoutConstraintAxisVertical;
    stack4.distribution = UIStackViewDistributionFillEqually;
    stack4.translatesAutoresizingMaskIntoConstraints = NO;

    for(int z = 0; z < 3; ++z) {
        UIStackView* stack3 = [[UIStackView alloc] init];

        stack3.axis = UILayoutConstraintAxisHorizontal;
        stack3.distribution = UIStackViewDistributionFillEqually;
        stack3.layer.borderWidth = 4;
        stack3.translatesAutoresizingMaskIntoConstraints = NO;

        for(int j = 0; j < 3; ++j) {
            UIStackView* stack2 = [[UIStackView alloc] init];

            stack2.axis = UILayoutConstraintAxisVertical;
            stack2.distribution = UIStackViewDistributionFillEqually;
            stack2.translatesAutoresizingMaskIntoConstraints = NO;

            stack2.layer.borderWidth = 3;
            stack2.layer.borderColor = UIColor.blackColor.CGColor;

            for(int i = 0; i < 3; ++i) {
                NSArray* buttons = [self createButtons:3 :i*9+j*3+3*z*9 selector:@selector(touchElement:)];

                [_buttons addObjectsFromArray:buttons];

                UIStackView* stackView = [[UIStackView alloc] initWithArrangedSubviews:buttons];

                stackView.axis = UILayoutConstraintAxisHorizontal;
                stackView.distribution = UIStackViewDistributionFillEqually;
                stackView.translatesAutoresizingMaskIntoConstraints = NO;

                [stack2 addArrangedSubview:stackView];
            }

            [stack3 addArrangedSubview:stack2];
        }
        [stack4 addArrangedSubview:stack3];
    }

    return stack4;
}

- (void)touchElement:(UIButton*)sender {
    NSLog(@"Touched %ld", sender.tag);
    if(_temp) {
        [self resetButton:_temp];
    }

    _temp = sender;
    _temp.layer.borderColor = UIColor.blueColor.CGColor;
    _temp.layer.borderWidth = 2;
}

- (void)resetButton:(UIButton*)sender {
    _temp.layer.borderColor = UIColor.blackColor.CGColor;
    _temp.layer.borderWidth = 1;
}

- (void)touchChooseElement:(UIButton*)sender {
    NSLog(@"Touchedddd %ld", sender.tag);
    [self resetButton:sender];

    NSString* text = sender.titleLabel.text;
    [_temp setTitle:text forState:UIControlStateNormal];

    [self setArray];

    [_temp setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
}

- (void)setArray {
    int toRemove = -1;

    for(int i = 0; i < _currentSolution.count; ++i) {
        UIButton* button = [_currentSolution objectAtIndex:i];
        if(button.tag == _temp.tag) {
            toRemove = i;
            break;
        }
    }

    if(toRemove >= 0) {
        [_currentSolution removeObjectAtIndex:toRemove];
    }

    [_currentSolution addObject:_temp];
}


- (UIStackView*)chooseElements {
    UIStackView* stack3 = [[UIStackView alloc] init];

    stack3.axis = UILayoutConstraintAxisVertical;
    stack3.distribution = UIStackViewDistributionFillEqually;
    stack3.translatesAutoresizingMaskIntoConstraints = NO;


    NSArray* buttons = [self createButtons:10 :1 selector:@selector(touchChooseElement:)];
    [_touchButtons addObjectsFromArray:buttons];

    UIStackView* stack = [[UIStackView alloc] initWithArrangedSubviews:buttons];

    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.distribution = UIStackViewDistributionFillEqually;
    stack.translatesAutoresizingMaskIntoConstraints = NO;

    [stack3 addArrangedSubview:stack];


    [_choiceButtons addObject:[self createAButton:@"Check" selector:@selector(checkButton:)]];

    [_choiceButtons addObject:[self createAButton:@"Check Previous" selector:@selector(checkPreviousButton:)]];

    [_choiceButtons addObject:[self createAButton:@"Resolve" selector:@selector(resolve:)]];

    UIStackView* stack2 = [[UIStackView alloc] initWithArrangedSubviews:_choiceButtons];

    stack2.axis = UILayoutConstraintAxisHorizontal;
    stack2.distribution = UIStackViewDistributionFillEqually;
    stack2.translatesAutoresizingMaskIntoConstraints = NO;


    [stack3 addArrangedSubview:stack2];

    return stack3;
}

- (void)resetLevelLabel {
    NSString* text = [NSString stringWithFormat:@"Level %d", currentDifficulty-MINIMUM_DIFFICULTY+1];
    [_level setText:text];
}

- (UIStackView*)getDifficultyButtons {
    _level = [[UILabel alloc] init];

    [self resetLevelLabel];

    [_difficultyButtons addObject:[self createAButton:@"Easier" selector:@selector(easierDifficulty:)]];

    [_difficultyButtons addObject:[self createAButton:@"Reload" selector:@selector(reload:)]];

    [_difficultyButtons addObject:[self createAButton:@"Harder" selector:@selector(harderDifficulty:)]];

    UIStackView* stack = [[UIStackView alloc] init];

    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.distribution = UIStackViewDistributionFillEqually;
    stack.translatesAutoresizingMaskIntoConstraints = NO;

    [stack addArrangedSubview:_level];

    for(UIButton* b in _difficultyButtons) {
        [stack addArrangedSubview:b];
    }
    return stack;
}

- (void)checkOneElement:(UIButton*)sender {
    if(sender) {
        int i = sender.titleLabel.text.intValue;
        Coordinate coord = [self getCoordinatesFor:(int)sender.tag];

        if(i == currentSudoku.solution[coord.x][coord.y]) {
            sender.layer.borderColor = UIColor.greenColor.CGColor;
            sender.enabled = NO;
            [sender setTitleColor:UIColor.greenColor forState:UIControlStateNormal];
        } else {
            sender.layer.borderColor = UIColor.redColor.CGColor;
            [sender setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        }
        sender.layer.borderWidth = 2;
    }
}

- (void)checkButton:(UIButton*)sender {
    [self checkOneElement:_temp];
}

- (void)checkPreviousButton:(UIButton*)sender {
    for(UIButton* button in _currentSolution) {
        [self checkOneElement:button];
    }
}

- (void)resolve:(UIButton*)sender {
    for(UIButton* b in _buttons) {
        Coordinate coord = [self getCoordinatesFor:(int)b.tag];

        if(b.isEnabled) {
            int e = currentSudoku.solution[coord.x][coord.y];
            NSString* title = [NSString stringWithFormat:@"%d", e];
            [b setTitle:title forState:UIControlStateNormal];

            b.enabled = NO;
            [b setTitleColor:UIColor.greenColor forState:UIControlStateNormal];
        }
    }
}

- (void)testForButtons:(UIButton*)sender :(int)firstTest :(int)secondTest :(int)at {
    if(currentDifficulty == firstTest) {
        sender.enabled = NO;
        sender.hidden = YES;
    }

    if(currentDifficulty == secondTest) {
        ((UIButton*)[_difficultyButtons objectAtIndex:at]).enabled = YES;
        ((UIButton*)[_difficultyButtons objectAtIndex:at]).hidden = NO;
    }

    [self resetLevelLabel];

    hasCurrentDifficultyChanged = YES;
}

- (void)easierDifficulty:(UIButton*)sender {
    --currentDifficulty;
    [self testForButtons:sender :MINIMUM_DIFFICULTY :MAXIMUM_DIFFICULTY-1 :2];
}

- (void)harderDifficulty:(UIButton*)sender {
    ++currentDifficulty;
    [self testForButtons:sender :MAXIMUM_DIFFICULTY :MINIMUM_DIFFICULTY+1 :0];
}

- (void)reload:(UIButton*)sender {
    _temp = nil;
    [_currentSolution removeAllObjects];
    [self setSudoku:currentSudoku];

    if(hasCurrentDifficultyChanged) {
        currentSudoku = [sudoku generateSudoku:currentDifficulty];
        [self setSudoku:currentSudoku];

        hasCurrentDifficultyChanged = NO;
    }
}

- (Coordinate)getCoordinatesFor:(int)tag {
    Coordinate coord;
    coord.x = tag/9;
    coord.y = tag%9;

    return coord;
}

- (void)setSudoku:(SudokuSolutions)sudokuSolutions {
    for(int i = 0; i < 9; ++i) {
        for(int j = 0; j < 9; ++j) {
            UIButton* b = [_buttons objectAtIndex:i+j*9];
            Coordinate coord = [self getCoordinatesFor:(int)b.tag];

            if(sudokuSolutions.original[coord.x][coord.y] != 0) {
                int e = sudokuSolutions.original[coord.x][coord.y];
                NSString* title = [NSString stringWithFormat:@"%d", e];
                [b setTitle:title forState:UIControlStateNormal];

                b.enabled = NO;
            } else {
                [b setTitle:@"" forState:UIControlStateNormal];

            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    currentDifficulty = 55;
    sudoku = [[Sudoku alloc] init];

    hasCurrentDifficultyChanged = NO;
    currentSudoku = [sudoku generateSudoku:currentDifficulty];

    _buttons = [[NSMutableArray alloc] init];
    _touchButtons = [[NSMutableArray alloc] init];
    _choiceButtons = [[NSMutableArray alloc] init];
    _currentSolution = [[NSMutableArray alloc] init];
    _difficultyButtons = [[NSMutableArray alloc] init];

    UIStackView* difficulty = [self getDifficultyButtons];

    [self.view addSubview:difficulty];

    UIStackView* chooseElements = [self chooseElements];
    [self.view addSubview:chooseElements];


    UIStackView* stackView = [self createGrid];
    [self.view addSubview:stackView];

    NSDictionary* dictio = @{
        @"label": difficulty,
        @"stackView": stackView,
        @"choose": chooseElements
    };

    NSArray* labelH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[label]-20-|" options:0 metrics:nil views:dictio];
    NSArray* stackViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[stackView]-20-|" options:0 metrics:nil views:dictio];
    NSArray* chooseH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[choose]-20-|" options:0 metrics:nil views:dictio];

    NSArray* labelV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label(==60)]-5-[stackView]-10-[choose(==70)]-20-|" options:0 metrics:nil views:dictio];

    [self.view addConstraints:stackViewH];
    [self.view addConstraints:labelH];
    [self.view addConstraints:labelV];
    [self.view addConstraints:chooseH];

    [self setSudoku:currentSudoku];
}

@end
