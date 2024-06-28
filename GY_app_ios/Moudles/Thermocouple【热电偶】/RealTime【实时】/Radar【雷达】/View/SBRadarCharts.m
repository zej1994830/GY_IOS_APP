//
//  SBRadarCharts.m
//  Tools
//
//  Created by 赵恩家 on 2024/5/9.
//  Copyright © 2024 zej. All rights reserved.
//

#import "SBRadarCharts.h"

#define ColorWithHEAL [UIColor colorWithRed:0/255.0f green:197/255.0f blue:188/255.0f alpha:1]//大图层的颜色

#define P_M(x,y) CGPointMake(x, y)

@interface SBRadarCharts (){
    NSMutableArray *labelarray;
    NSMutableArray *layerarray;
}
@property (nonatomic,assign) CGFloat radiusmax;
@property (nonatomic,assign) CGFloat radiusnor;

@end

@implementation SBRadarCharts


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{    
    _dioWdith = 4;
    _dioBoderWdith = 4;

    _labelWidth = 20;
    _labelHeight = 22.5;
    
    _labelWidth2 = 65;
    _labelHeight2 = 22.5;
    
    _themColor = ColorWithHEAL;
    _cirlColor = [UIColor colorWithRed:22/255.0f green:93/255.0f blue:255/255.0f alpha:1];
    
    _cirlMargin = 30;
    
    _imgWidth = 20;
    _imgBoderWidth = 1;
    
    _proportion = 0.2;

    _img = [UIImage imageNamed:@"背景.jpg"];
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    //设置frame
}


#pragma mark - 空心圆
- (void)drawRect:(CGRect)rect
{
    for (CAShapeLayer *shapeLayer in layerarray) {
        [shapeLayer removeFromSuperlayer];
    }
    
    _values = [[NSMutableArray alloc]init];
    _titles = [[NSMutableArray alloc]init];
    labelarray = [[NSMutableArray alloc]init];
    layerarray = [[NSMutableArray alloc]init];
    _radius = (self.frame.size.width)/2.0;

    _radiusmax = [_dataDic[@"max_radius"] doubleValue];
    _radiusnor = [_dataDic[@"min_radius"] doubleValue];
    
    for (UIView *vi in self.subviews) {
        [vi removeFromSuperview];
    }
    
    //绘制方向定位坐标
    [self showDirectionalcoordinates];
    
    NSArray *resultModelArray = _dataDic[@"resultModel"];
    [_values removeAllObjects];
    CGFloat offsetAngle = [_dataDic[@"offsetAngle"] floatValue];
    CGFloat offsetAngle2 = [_dataDic[@"offsetAngle2"] floatValue];
//    CGFloat tureangle =
    
    for (int i = 0; i < resultModelArray.count; i++) {
        NSDictionary * tempdic = resultModelArray[i];
        [_values addObject:tempdic[@"insertion_height"]];
        [_titles addObject:[NSString stringWithFormat:@"%@,%@",tempdic[@"temperature"],tempdic[@"name"]]];
    }

    //画虚线的
    CGFloat dashPattern[] = {3,3};// 实线长为前，空白为后
    CGFloat lineWidth = 0.5;
    
    CGFloat _headerimageR = _imgWidth/2.0;//头像的半径
    
    //最外面的一个圆  这里微调了下为了好看，理论上y为0
    UIBezierPath* aPath_yuanhuan = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1,(self.frame.size.width - 2), (self.frame.size.width - 2))];
    aPath_yuanhuan.lineWidth = 1;
    [_cirlColor set];
    aPath_yuanhuan.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath_yuanhuan.lineJoinStyle = kCGLineJoinRound; //终点处理
    [aPath_yuanhuan stroke];
    
    //内环
    CGFloat radius2 = (_radiusnor / _radiusmax) * (((self.frame.size.width - 2)) / 2);
    UIBezierPath* aPath_yuanhuan2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake((self.frame.size.width - 2) / 2, (self.frame.size.width - 2) / 2) radius:radius2 startAngle:0 endAngle:(M_PI * 2) clockwise:true];
    aPath_yuanhuan2.lineWidth = 0.5;
    [_cirlColor setStroke];
    aPath_yuanhuan2.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath_yuanhuan2.lineJoinStyle = kCGLineJoinRound; //终点处理
    [aPath_yuanhuan2 stroke];//画的圆环
    
    [[UIColor colorWithRed:(CGFloat)(242.0/255.0)
                     green:(CGFloat)(242.0/255.0)
                      blue:(CGFloat)(242.0/255.0)
                     alpha:1] setFill];
    [aPath_yuanhuan fill];
    
    [[UIColor whiteColor] setFill];
    [aPath_yuanhuan2 fill];
    
    //内环
    UIBezierPath* aPath_yuanhuan3 = [UIBezierPath bezierPathWithArcCenter:CGPointMake((self.frame.size.width - 2) / 2, (self.frame.size.width - 2) / 2) radius:radius2 startAngle:0 endAngle:(M_PI * 2) clockwise:true];
    aPath_yuanhuan3.lineWidth = 0.5;
    [_cirlColor set];
    aPath_yuanhuan3.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath_yuanhuan3.lineJoinStyle = kCGLineJoinRound; //终点处理
    [aPath_yuanhuan3 stroke];//画的圆环
    
    
    float maxValue = [[_values valueForKeyPath:@"@max.floatValue"] floatValue];//value array里面的最大值
    UIBezierPath* aPath = [UIBezierPath bezierPath];//🌿外边的😊大图层
    aPath.lineWidth = 1.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineJoinRound; //终点处理
    
    UIBezierPath* aPathsmall = [UIBezierPath bezierPath];//🌿里边的😊小图层
    aPathsmall.lineWidth = 1.0;
    aPathsmall.lineCapStyle = kCGLineCapRound; //线条拐角
    aPathsmall.lineJoinStyle = kCGLineJoinRound; //终点处理
    
    NSMutableArray *pointArray = [NSMutableArray array];//大图层的顶点位置
    NSMutableArray *pointArraysmall = [NSMutableArray array];//小涂层的顶点位置
    NSMutableArray *pointslidesmall = [NSMutableArray array];//圆边的顶点位置
    //提取出大小图层的point
    for (int i = 0; i<resultModelArray.count; i++) {
        NSDictionary * tempdic = resultModelArray[i];
        CGFloat insertion_angle = [tempdic[@"insertion_angle"] floatValue];
        
        NSValue *value = [NSValue valueWithCGPoint:[self calcCircleCoordinateWithCenter:CGPointMake(_radius, _radius) andWithAngle:insertion_angle + offsetAngle + offsetAngle2 andWithRadius:((_radiusmax - [_values[i] floatValue] * 1000) / _radiusmax) * _radius]];
        
        [pointArray addObject:value];
        
        NSValue *valuesmall = [NSValue valueWithCGPoint:[self calcCircleCoordinateWithCenter:CGPointMake(_radius, _radius) andWithAngle:insertion_angle + offsetAngle + offsetAngle2 andWithRadius:((_radiusmax - [_values[i] floatValue] * 1000) / _radiusmax) * _radius]];
        [pointArraysmall addObject:valuesmall];
        
        NSValue *valueslide = [NSValue valueWithCGPoint:[self calcCircleCoordinateWithCenter:CGPointMake(_radius, _radius) andWithAngle:insertion_angle + offsetAngle + offsetAngle2 andWithRadius:_radius]];
        [pointslidesmall addObject:valueslide];
        
    }
    
    for (int i = 0; i<pointArray.count; i++) {
        NSDictionary * tempdic = resultModelArray[i];
        CGFloat insertion_angle = [tempdic[@"insertion_angle"] floatValue];
        
        UIBezierPath *path3 = [UIBezierPath bezierPath];
        [path3 moveToPoint:CGPointMake(_radius,_radius)];
        CGPoint pointyuanshangde = [self calcCircleCoordinateWithCenter:CGPointMake(_radius,_radius) andWithAngle:insertion_angle + offsetAngle + offsetAngle2 andWithRadius:_radius];
        [path3 addLineToPoint:pointyuanshangde];
        [path3 setLineWidth:0.5];
//        [path3 setLineDash:dashPattern count:1 phase:1];
        [[self colorWithHexString:@"#CCCCCC" alpha:1] setStroke];
        [path3 stroke];//直线
        CGPoint p = [pointArray[i] CGPointValue];
        CGPoint psmall = [pointArraysmall[i] CGPointValue];
        
        CGFloat pointradius = ((_radiusmax - [_values[i] floatValue] * 1000) / _radiusmax) * _radius;
        UIBezierPath* aPath_yuanhuan = [UIBezierPath bezierPathWithArcCenter:CGPointMake((self.frame.size.width - 2) / 2, (self.frame.size.width - 2) / 2) radius:pointradius startAngle:0 endAngle:(M_PI * 2) clockwise:true];
        [aPath_yuanhuan setLineDash:dashPattern count:2 phase:1];
        aPath_yuanhuan.lineWidth = lineWidth;
        [[self colorWithHexString:@"#165DFF" alpha:0.35] set];
        aPath_yuanhuan.lineCapStyle = kCGLineCapRound; //线条拐角
        aPath_yuanhuan.lineJoinStyle = kCGLineJoinRound; //终点处理
        [aPath_yuanhuan stroke];//画的圆环
        
        if (i == 0) {
            [aPath moveToPoint:p];
            [aPathsmall moveToPoint:psmall];
        }else{
            //画曲线 找出控制点
            //            CGPoint nextP = [pointArray[i-1] CGPointValue];
            //            CGPoint control1 = P_M(p.x + (nextP.x - p.x) / 2.0, nextP.y);
            //            CGPoint control2 = P_M(p.x + (nextP.x - p.x) / 2.0, p.y);
            //
            //            [aPath addCurveToPoint:p controlPoint1:control1 controlPoint2:control2];
        }
        
        [aPath addLineToPoint:p];
        [aPathsmall addLineToPoint:psmall];
        [[_themColor colorWithAlphaComponent:0.3] setFill];
        
        
        UIView *cile = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _dioWdith, _dioWdith)];
        cile.backgroundColor = [UIColor whiteColor];
        
        cile.layer.borderWidth = _dioBoderWdith;
        cile.layer.borderColor = _themColor.CGColor;
        cile.layer.masksToBounds = YES;
        cile.layer.cornerRadius = _dioWdith/2.0;
        cile.center = p;
        [self addSubview:cile];
        
        double doubleValue = [[_titles[i] componentsSeparatedByString:@","].firstObject doubleValue];
        int roundedIntValue = (int)round(doubleValue);
        UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _labelWidth, _labelHeight)];
        [label setTitle:[NSString stringWithFormat:@"%d",roundedIntValue] forState:UIControlStateNormal];
        label.titleLabel.font = [UIFont systemFontOfSize:5 weight:UIFontWeightMedium];
        [label setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        label.tag = 100 + i;
        [label addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *label2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _labelWidth2, _labelHeight2)];
        [label2 setTitle:[_titles[i] componentsSeparatedByString:@","].lastObject forState:UIControlStateNormal];
        label2.titleLabel.font = [UIFont systemFontOfSize:5];
        [label2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        label2.tag = 1000 + i;
        [label2 addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([tempdic[@"alarm"] isEqualToString: @"0"]) {
//            label.backgroundColor = [UIColor colorWithRed:(CGFloat)(234/255) green:(CGFloat)(23/255) blue:(CGFloat)(61/255) alpha:1];
            label.backgroundColor = [UIColor colorWithRed:(CGFloat)(234.0/255.0)
                                                    green:(CGFloat)(23.0/255.0)
                                                     blue:(CGFloat)(61.0/255.0)
                                                    alpha:1];
            label2.backgroundColor = [UIColor colorWithRed:(CGFloat)(234.0/255.0)
                                                     green:(CGFloat)(23.0/255.0)
                                                      blue:(CGFloat)(61.0/255.0)
                                                     alpha:0.18];;
        }else {
            label.backgroundColor = [self colorFromDecimalValue:[tempdic[@"color"] intValue] alpha:1];
            label2.backgroundColor = [self colorFromDecimalValue:[tempdic[@"color"] intValue] alpha:0.18];
        }
        
        CGFloat selfWidth = self.frame.size.width;
        CGFloat selfHeight = self.frame.size.height;
        CGFloat labelWidth = label.frame.size.width;
        CGFloat labelHeight = label.frame.size.height;
        
        if (p.x<selfWidth/2-labelWidth) {
            CGFloat x = p.x - labelWidth/2;
            CGFloat y;
            if (p.y<(selfHeight/2-labelHeight)) {
                y = p.y - labelHeight/2;
                
            } else {
                y = p.y + labelHeight/2;
                
            }
            label.center = CGPointMake(x, y);
        } else {
            CGFloat x = p.x + labelWidth/2;
            
            CGFloat y;
            if (p.y<(selfHeight/2-labelHeight)) {
                y = p.y - labelHeight/2;
            } else {
                y = p.y + labelHeight/2;
            }
            label.center = CGPointMake(x, y);
        }
        if (p.y>(selfHeight/2-labelHeight/2)&&p.y<(selfHeight/2+labelHeight/2)) {
            if (p.x<selfWidth/2-labelHeight) {
                label.center = CGPointMake(p.x-labelWidth/2, p.y);
            }else{
                label.center = CGPointMake(p.x+labelWidth/2, p.y);
            }
        }else{
            if (p.x>(selfWidth/2-labelWidth/2)&&p.x<(selfWidth/2+labelWidth/2)) {
                if (p.y<selfHeight/2-labelWidth) {
                    label.center = CGPointMake(p.x, p.y-labelHeight/2);
                } else {
                    label.center = CGPointMake(p.x, p.y+labelHeight/2);
                }
            }
        }
        
        [label sizeToFit];
        [label2 sizeToFit];
        
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width - 15, 5);
        label2.frame = CGRectMake(label2.frame.origin.x, label2.frame.origin.y, label2.frame.size.width - 5, 5);
        
        UIBezierPath *path4 = [UIBezierPath bezierPath];//线条指向的坐标记录
//        [path4 moveToPoint:p];
        CGPoint slidesmall = [pointslidesmall[i] CGPointValue];
        [path4 moveToPoint:slidesmall];
        if (p.x <= _radius && p.y >= _radius) {//左下
            label.frame = CGRectMake([self calcCircleCoordinateWithCenter:CGPointMake(_radius,_radius) andWithAngle:insertion_angle + offsetAngle + offsetAngle2 andWithRadius:_radius + 70].x, [self calcCircleCoordinateWithCenter:CGPointMake(_radius,_radius) andWithAngle:insertion_angle + offsetAngle + offsetAngle2 andWithRadius:_radius + 20].y, label.frame.size.width, label.frame.size.height);
            label2.frame = CGRectMake(label.frame.origin.x + label.frame.size.width, label.frame.origin.y, label2.frame.size.width, label2.frame.size.height);
            
            while ([self hitView:label] || [self hitView:label2]) {
                label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y + 5, label.frame.size.width, label.frame.size.height);
                label2.frame = CGRectMake(label.frame.origin.x + label.frame.size.width, label.frame.origin.y, label2.frame.size.width, label2.frame.size.height);
            }
            [path4 addLineToPoint:CGPointMake(label2.frame.origin.x + label2.frame.size.width, label.frame.origin.y + label.frame.size.height / 2)];
        }else if (p.x > _radius && p.y >= _radius) {//右下
            label.frame = CGRectMake([self calcCircleCoordinateWithCenter:CGPointMake(_radius,_radius) andWithAngle:insertion_angle + offsetAngle + offsetAngle2 andWithRadius:_radius + 25].x, [self calcCircleCoordinateWithCenter:CGPointMake(_radius,_radius) andWithAngle:insertion_angle + offsetAngle + offsetAngle2 andWithRadius:_radius + 15].y, label.frame.size.width, label.frame.size.height);
            label2.frame = CGRectMake(label.frame.origin.x + label.frame.size.width, label.frame.origin.y, label2.frame.size.width, label2.frame.size.height);

            while ([self hitView:label] || [self hitView:label2]) {
                label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y + 5, label.frame.size.width, label.frame.size.height);
                label2.frame = CGRectMake(label.frame.origin.x + label.frame.size.width, label.frame.origin.y, label2.frame.size.width, label2.frame.size.height);
            }
            [path4 addLineToPoint:CGPointMake(label.frame.origin.x, label.frame.origin.y + label.frame.size.height / 2)];
        }else if (p.x > _radius && p.y <= _radius) {//右上
            label.frame = CGRectMake([self calcCircleCoordinateWithCenter:CGPointMake(_radius,_radius) andWithAngle:insertion_angle + offsetAngle + offsetAngle2 andWithRadius:_radius + 25].x, [self calcCircleCoordinateWithCenter:CGPointMake(_radius,_radius) andWithAngle:insertion_angle + offsetAngle + offsetAngle2 andWithRadius:_radius + 25].y, label.frame.size.width, label.frame.size.height);
            label2.frame = CGRectMake(label.frame.origin.x + label.frame.size.width, label.frame.origin.y, label2.frame.size.width, label2.frame.size.height);

            while ([self hitView:label] || [self hitView:label2]) {
                label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y - 5, label.frame.size.width, label.frame.size.height);
                label2.frame = CGRectMake(label.frame.origin.x + label.frame.size.width, label.frame.origin.y, label2.frame.size.width, label2.frame.size.height);
            }
            [path4 addLineToPoint:CGPointMake(label.frame.origin.x, label.frame.origin.y + label.frame.size.height / 2)];
        }else if (p.x < _radius && p.y <= _radius) {//左上
            label.frame = CGRectMake([self calcCircleCoordinateWithCenter:CGPointMake(_radius,_radius) andWithAngle:insertion_angle + offsetAngle + offsetAngle2 andWithRadius:_radius + 70].x, [self calcCircleCoordinateWithCenter:CGPointMake(_radius,_radius) andWithAngle:insertion_angle + offsetAngle + offsetAngle2 andWithRadius:_radius + 25].y, label.frame.size.width, label.frame.size.height);
            label2.frame = CGRectMake(label.frame.origin.x + label.frame.size.width, label.frame.origin.y, label2.frame.size.width, label2.frame.size.height);

            while ([self hitView:label] || [self hitView:label2]) {
                label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y - 5, label.frame.size.width, label.frame.size.height);
                label2.frame = CGRectMake(label.frame.origin.x + label.frame.size.width, label.frame.origin.y, label2.frame.size.width, label2.frame.size.height);
            }
            [path4 addLineToPoint:CGPointMake(label2.frame.origin.x + label2.frame.size.width, label.frame.origin.y + label.frame.size.height / 2)];
        }        
        
        // 创建 CAShapeLayer
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path4.CGPath;
        // 设置线条样式
        shapeLayer.strokeColor = [UIColor colorWithRed:(CGFloat)(153.0/255.0)
                                                 green:(CGFloat)(153.0/255.0)
                                                  blue:(CGFloat)(153.0/255.0)
                                                 alpha:1].CGColor; // 线条颜色
        shapeLayer.lineWidth = 0.5; // 线条宽度
        shapeLayer.fillColor = [UIColor colorWithRed:(CGFloat)(153.0/255.0)
                                               green:(CGFloat)(153.0/255.0)
                                                blue:(CGFloat)(153.0/255.0)
                                               alpha:1].CGColor; // 填充颜色
//        [[super layer] addSublayer:shapeLayer];
        

//        [path4 stroke];//直线
        
        [layerarray addObject:shapeLayer];
        [labelarray addObject:label];
        [labelarray addObject:label2];
        [self addSubview:label];
        [self addSubview:label2];
        
        CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue=[NSNumber numberWithFloat:0.0f];
        animation.toValue=[NSNumber numberWithFloat:1.0f];
        animation.duration=5.0;
        animation.fillMode=kCAFillModeForwards;
        animation.removedOnCompletion=NO;
        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [shapeLayer addAnimation:animation forKey:@"animation"];
        
        CGFloat radius = self.frame.size.width / 2;
        for (int i = 0; i < 4; i++){
            //画虚线的
            CGFloat dashPattern[] = {3,3};// 实线长为前，空白为后
            UIBezierPath *path3 = [UIBezierPath bezierPath];
            [path3 moveToPoint:CGPointMake(radius,radius)];
            //这里是判断坐标顺逆时针的地方
            CGPoint p = [self calcCircleCoordinateWithCenter:CGPointMake(radius,radius) andWithAngle:(offsetAngle + offsetAngle2 + 90 * i) andWithRadius:radius];
            [path3 addLineToPoint:p];
            [path3 setLineWidth:0.5];
            [path3 setLineDash:dashPattern count:1 phase:1];
            [[self colorWithHexString:@"#CCCCCC" alpha:1] setStroke];
            [path3 stroke];//直线
        }
    }
}

//超出当前self的范围也可点击
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return  YES;
}

//判断碰撞
- (BOOL)hitView:(UIButton *)label  {
    // 遍历 Label 的父视图的子视图
    for (UIButton *sublabel in labelarray) {
        // 忽略自身
        if (sublabel == label) {
            continue;
        }
        
        // 如果当前视图与其他视图相交
        if (CGRectIntersectsRect(label.frame, sublabel.frame)) {
            return 1;
        }
    }
    
    // 如果没有碰撞到其他视图，则返回 nil
    return 0;
}


#pragma mark 计算圆圈上点在IOS系统中的坐标
-(CGPoint) calcCircleCoordinateWithCenter:(CGPoint) center  andWithAngle : (CGFloat) angle andWithRadius: (CGFloat) radius{
    int clockwise =  [_dataDic[@"clockwise"] intValue];
    //1是顺时针，其余是逆时针
    if (clockwise == 1){
        angle = -angle;
    }
    CGFloat x2 = radius*cosf(angle*M_PI/180);
    CGFloat y2 = radius*sinf(angle*M_PI/180);
    return CGPointMake(center.x+x2, center.y-y2);
}
//坐标方向显示用的 + 点的角度
-(void) showDirectionalcoordinates{
    CGFloat offsetAngle = [_dataDic[@"offsetAngle"] floatValue];
    CGFloat offsetAngle2 = [_dataDic[@"offsetAngle2"] floatValue];
    CGFloat radius = self.frame.size.width / 2;
    //0 90 180 270
    for (int i = 0; i < 4; i++) {
        //只是初始角度
        CGFloat x1 = radius*cosf(-(offsetAngle + offsetAngle2 + 90 * i)*M_PI/180);
        CGFloat y1 = radius*sinf(-(offsetAngle + offsetAngle2 + 90 * i)*M_PI/180);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(radius + x1, radius - y1, 35, 20)];
        label.tag = 10000 + 90 * i;
        label.text = [NSString stringWithFormat:@"%d°",90 * i];
        label.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        
        //这里是判断坐标顺逆时针的地方
        CGPoint p = [self calcCircleCoordinateWithCenter:CGPointMake(radius,radius) andWithAngle:(offsetAngle + offsetAngle2 + 90 * i) andWithRadius:radius];
        
        CGFloat selfWidth = (self.frame.size.width - 2);
        CGFloat selfHeight = self.frame.size.height;
        CGFloat labelWidth = label.frame.size.width;
        CGFloat labelHeight = label.frame.size.height;
        
        if (p.x<selfWidth/2-labelWidth) {
            CGFloat x = p.x - labelWidth/2;
            CGFloat y;
            if (p.y<(selfHeight/2-labelHeight)) {
                y = p.y - labelHeight/2;
                
            } else {
                y = p.y + labelHeight/2;
                
            }
            label.center = CGPointMake(x, y);
            
        } else {
            CGFloat x = p.x + labelWidth/2;
            
            CGFloat y;
            if (p.y<(selfHeight/2-labelHeight)) {
                y = p.y - labelHeight/2;
                
            } else {
                y = p.y + labelHeight/2;
                
            }
            label.center = CGPointMake(x, y);
        }
        if (p.y>(selfHeight/2-labelHeight/2)&&p.y<(selfHeight/2+labelHeight/2)) {
            if (p.x<selfWidth/2-labelHeight) {
                
                label.center = CGPointMake(p.x-labelWidth/2, p.y);
            }else{
                label.center = CGPointMake(p.x+labelWidth/2, p.y);
            }
        }else{
            if (p.x>(selfWidth/2-labelWidth/2)&&p.x<(selfWidth/2+labelWidth/2)) {
                if (p.y<selfHeight/2-labelWidth) {
                    label.center = CGPointMake(p.x, p.y-labelHeight/2);
                } else {
                    label.center = CGPointMake(p.x, p.y+labelHeight/2);
                }
            }
        }
    }
    NSArray *resultModelArray = _dataDic[@"resultModel"];
   
    for (int i = 0; i<resultModelArray.count; i++) {
        NSDictionary * tempdic = resultModelArray[i];
        CGFloat insertion_angle = [tempdic[@"insertion_angle"] floatValue];
        CGPoint p = [self calcCircleCoordinateWithCenter:CGPointMake(_radius, _radius) andWithAngle:insertion_angle + offsetAngle + offsetAngle2 andWithRadius:_radius + 10];
        
        //距离太近角度的不显示
        UILabel *templabel = [self viewWithTag:10000 + insertion_angle];
        UILabel *templabel2 = [self viewWithTag:10000 + insertion_angle + 1];
        UILabel *templabel3 = [self viewWithTag:10000 + insertion_angle + 2];
        UILabel *templabel4 = [self viewWithTag:10000 + insertion_angle - 1];
        UILabel *templabel5 = [self viewWithTag:10000 + insertion_angle - 2];
        UILabel *templabel6 = [self viewWithTag:10000 + insertion_angle - 3];
        if (templabel != nil || templabel2 != nil || templabel3 != nil || templabel4 != nil || templabel5 != nil || templabel6 != nil) {
            continue;
        }
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(1, 1, 35, 20)];
        label.tag = 10000 + insertion_angle;
        label.text = [NSString stringWithFormat:@"%.0f°",insertion_angle];
        label.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.center = p;
        [self addSubview:label];
        
    }
}

- (void)buttonClick:(UIButton *)button {
    _block(button.tag - 100);
}

- (void)buttonClick2:(UIButton *)button {
    _block2(button.tag - 1000);
}


//十六进制
- (UIColor *)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha{
    NSString *cString = [[hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

//十进制
- (UIColor *)colorFromDecimalValue:(int)colorValue  alpha:(CGFloat)alpha{
    CGFloat red = ((colorValue & 0xFF0000) >> 16) / 255.0;
    CGFloat green = ((colorValue & 0xFF00) >> 8) / 255.0;
    CGFloat blue = (colorValue & 0xFF) / 255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

// 移动圆上的点沿着半径朝外移动
- (CGPoint )movePointOutward:(CGPoint) point distance:(CGFloat) distance angle:(CGFloat) angle {
    int clockwise =  [_dataDic[@"clockwise"] intValue];
    //1是顺时针，其余是逆时针
    if (clockwise == 1){
        angle = -angle;
    }
    CGFloat newX = point.x + distance * cos(angle); // 在角度方向上移动点
    CGFloat newY = point.y + distance * sin(angle);
    return CGPointMake(newX, newY);
}
//生成外环和内环之间路径
- (UIBezierPath *)pathBetweenOuterPath:(UIBezierPath *)outerPath andInnerPath:(UIBezierPath *)innerPath {
    [outerPath appendPath:innerPath]; // 添加内环路径到外环路径
    return outerPath;
}
/**
 ：douxindong
 ：2017-4-20 1:02:26
 : 1.0.0
 --------------------------------------------------------------
 功能说明
 --------------------------------------------------------------
 根据IOS视图中圆组件的中心点(x,y)、半径(r)、圆周上某一点与圆心的角度这3个
 条件来计算出该圆周某一点在IOS中的坐标(x2,y2)。
 
 注意：
 （1）IOS坐标体系与数学坐标体系有差别，因此不能完全采用数学计算公式。
 （2）数学计算公式：
 x2=x+r*cos(角度值*PI/180)
 y2=y+r*sin(角度值*PI/180)
 （3）IOS中计算公式：
 x2=x+r*cos(角度值*PI/180)
 y2=y-r*sin(角度值*PI/180)
 
 --------------------------------------------------------------
 参数说明
 --------------------------------------------------------------
 @param (CGPoint) center
 
 圆圈在IOS视图中的中心坐标，即该圆视图的center属性
 
 @param (CGFloat) angle
 角度值，是0～360之间的值。
 注意：
 （1）请使用下面坐标图形进行理解。
 （2）角度是逆时针转的，从x轴中心(0,0)往右是0度角（或360度角），往左是180度角，往上是90度角，往下是270度角。
 
 (y)
 ^
 |
 |
 |
 |
 -----------------> (x)
 |(0,0)
 |
 |
 |
 
 @param (CGFloat) radius
 圆周半径
 */

- (void)showDirectionalcoordinates:(CGFloat)offsetAngle :(CGFloat)offsetAngle2 {
}

@end
