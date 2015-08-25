//
//  ViewController.m
//  10-CoreBluetooth
//
//  Created by apple on 14/11/5.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()<CBCentralManagerDelegate, CBPeripheralDelegate>
/**
 *  外设
 */
@property (nonatomic, strong) NSMutableArray *peripherals;
/**
 *  中心管理者
 */
@property (nonatomic, strong) CBCentralManager *mgr;
@end

@implementation ViewController

- (NSMutableArray *)peripherals
{
    if (!_peripherals) {
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 1.创建中心设备
    CBCentralManager *mgr = [[CBCentralManager alloc] init];
    self.mgr = mgr;
    
    
    // 设置代理
    mgr.delegate = self;
    
    // 2.利用中心设备扫描外部设备
    /*
     如果指定数组代表只扫描指定的设备
     */
    [mgr scanForPeripheralsWithServices:nil options:nil];
}
#pragma mark - CBCentralManagerDelegate
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{

    // 保存扫描到得外部设备
    // 判断如果数组中不包含当前扫描到得外部设置才保存
    if (![self.peripherals containsObject:peripheral]) {
        
        peripheral.delegate = self;
        [self.peripherals addObject:peripheral];
    }
}

/**
 *  模拟点击, 然后连接所有的外设
 */
- (void)start
{
    for (CBPeripheral *peripheral in self.peripherals) {
        /**
         *  连接外设
         */
        [self.mgr connectPeripheral:peripheral options:nil];
    }
}
/**
 *  连接外设成功调用
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    // 扫描外设中得服务
    [peripheral discoverServices:nil];
}
/**
 *  连接外设失败调用
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}

#pragma makr - CBPeripheralDelegate
/**
 *  只要扫描到服务就会调用
 *
 *  @param peripheral 服务所在的外设
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
    // 获取外设中所有扫描到得服务
    NSArray *services = peripheral.services;
    for (CBService *service in services) {
        // 拿到需要的服务
        if ([service.UUID.UUIDString isEqualToString:@"123"])
        {
            // 从需要的服务中查找需要的特征
            // 从peripheral中得service中扫描特征
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

/**
 *  只要扫描到特征就会调用
 *
 *  @param peripheral 特征所属的外设
 *  @param service    特征所属的服务
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    // 拿到服务中所有的特诊
    NSArray *characteristics =  service.characteristics;
    // 遍历特征, 拿到需要的特征处理
    for (CBCharacteristic * characteristic in characteristics) {
        if ([characteristic.UUID.UUIDString isEqualToString:@"8888"]) {
            NSLog(@"设置闹钟");

        }
    }
}
@end
