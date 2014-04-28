////
////  XMLSerializeService.h
////  TheStoreApp
////
////  Created by linyy on 11-1-20.
////  Copyright vsc. All rights reserved.
////	用于XML的序列化与反序列化
//
//#import <Foundation/Foundation.h>
//
//@class ObjectArraySender;
//@class Trader;
//@class SenderMethodBody;
//@class ProductVO;
//@class ProvinceVO;
//@class Page;
//
//
//@interface XMLSerializeService : NSObject<NSXMLParserDelegate>{
//@private
//	NSString * currentResult;									//用来保存标签里面的值
//	id m_classId;												//用来保存成员实体指针
//	id c_classId;												//用来保存集合成员实体指针
//	NSString * i_tag;											//用来保存内部类标签
//	NSInteger i_endIndex;										//用来保存递归逻辑的结束下标
//	NSMutableData * serilizeData;								//用来解析的数据
//	NSString * c_classStr;										//集合实体名称（字符串）
//	NSString * i_classStr;										//内部类实体名称（字符串）
//	int serializeInnerClassStatus;								//用来记录内部实体类的解析状态，0表示未开始，1表示进行中，2表示解析结束
//	int serializeCollectionClassStatus;							//用来记录集合实体的解析状态，0表示未开始，1表示进行中，2表示解析结束
//	NSString * tabStr;											//用来记录当前xml标签
//	NSString * cmpStr;											//上一个标签的字符串，用于比较，防止多次赋值
//	NSString * attStr;											//当前类属性（字段）的字符串
//	NSString * classStr;										//当前类的类名
//	//NSString * collectionClassContentStr;						//集合类结束标签
//	NSString * cmpClassStr;										//类结束标签
//	NSString * cmpFirstListStr;									//出现集合关键字初始标签
//	NSString * cmpNextListStr;									//出现集合关键字结束标签
//	NSXMLParser * parser;										//解析器，通过这个成员变量可以触发解析XML事件
//	NSMutableArray * longArray;									//用于存放实体类成员long数组
//	NSMutableArray * stringArray;								//用于存放实体类成员string数组
//	NSMutableArray * intArray;									//用于存放实体类int数组
//	NSMutableArray * classArray;								//用于存放集合实体类的集合
//	NSString * methodStr;										//方法名
//	id dataObj;													//数据距柄
//	SEL m_methodSelector;										//成员方法选择器
//	BOOL headOfCollection;										//是否以一个集合标签开始
//	BOOL haveEntity;											//是否拥有实体类
//	NSMutableArray * resultClassArray;							//结果集，用于存储反射后的结果
//    NSObject * resultObject;
//	BOOL findFirstClass;										//是否是第一次查找类标签
//	BOOL haveAnotherClass;										//是否拥有不同类型的实体类
//	BOOL haveInnerClass;										//是否拥有内部类
//	int indexOfStartOfAClass;									//用于记录需要递归的实体类的开始字符所在下标
//    NSNumber * errorNumValue;                                   //错误码的值
//    NSString * globalErrorString;                               //错误码的描述字符串
//    int longArrayRetainCount;
//    int intArrayRetainCount;
//    int stringArrayRetainCount;
//    int classArrayRetainCount;
//    int resultClassArrayRetainCount;
//    BOOL isInnerClass;
//}
//
//@property(nonatomic)BOOL isInnerClass;
//- (NSObject *)fromXML:(NSData *)contentData;				//解析xml，为类成员赋值
//- (NSString *)toXML:(ObjectArraySender *)transportContent;		//通过方法实体，生成一个xml
//- (NSString *)addTagAndContentToXML:(NSString *)attrName 
//					 attributeValue:(NSString *)attrValue;		//添加一个tag标签
//- (void)createEntity:(NSString *)elementName;					//通过获取到的xml生成一个对象，为其分配空间
//- (void)setAttribute:(NSString *)elementName;					//通过获取到的xml为对象的成员变量(亦称属性)进行赋值(assignment)
//- (void)setCollection:(NSString *)elementName;					//通过获取到的xml为对象的成员变量(亦称属性)中的集合进行赋值(assignment)
//- (void)setClassCollection:(NSString *)elementName;				//通过获取到的xml为其作为成员的类对象进行赋值(assignment)
//- (NSObject *)setInnerClass:(NSString *)elementName;			//设置内部成员类
//- (NSString *)getSetterStr:(NSString *)value;					//生成一个set字样的方法的字符串
//@end
