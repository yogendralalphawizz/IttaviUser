// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings, avoid_print, unused_field, unused_local_variable, prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:milkman/Api/config.dart';
import 'package:milkman/controller/catdetails_controller.dart';
import 'package:milkman/controller/productdetails_controller.dart';
import 'package:milkman/controller/stordata_controller.dart';
import 'package:milkman/controller/subscribe_controller.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/screen/home_screen.dart';
import 'package:milkman/utils/Colors.dart';
import 'package:milkman/utils/cart_item.dart';
import 'package:table_calendar/table_calendar.dart';

class SubScribeScreen extends StatefulWidget {
  const SubScribeScreen({super.key});

  @override
  State<SubScribeScreen> createState() => _SubScribeScreenState();
}

class _SubScribeScreenState extends State<SubScribeScreen> {
  CatDetailsController catDetailsController = Get.find();
  StoreDataContoller storeDataContoller = Get.find();
  SubScibeController subScibeController = Get.find();
  ProductDetailsController productDetailsController = Get.find();

  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  int? groupValue;

  String? selectItem;
  List<String> itemList = [];

  late Box<CartItem> cart;
  late final List<CartItem> items;

  String img = Get.arguments["img"];
  String title = Get.arguments["name"];
  String sprice = Get.arguments["sprice"];
  String aprice = Get.arguments["aprice"];
  String per = Get.arguments["per"];
  String attributeId = Get.arguments["attributeId"];
  String productTitle = Get.arguments["productTitle"];
  String isEmpty1 = Get.arguments["isEmpty"];
  String productID = Get.arguments["productId"];

  String finalPrice = "";
  List list = [];

  @override
  void initState() {
    print("!!!!!!!!!++++++++" + sprice.toString());
    setupHive();
    productDetailsController.getDeliverysDayList(
        storeID: storeDataContoller.storeDataInfo?.storeInfo.storeId);
    productDetailsController.getTimeSlotListApi(
      storeID: storeDataContoller.storeDataInfo?.storeInfo.storeId,
    );
    super.initState();
    selectItem = productTitle;
    if (isEmpty1 == "0") {
      setState(() {
        itemList = [];
        subScibeController.selectedIndexes = [];
        subScibeController.selectDay = "";
        subScibeController.selectMonth = "";
        subScibeController.selectYear = "";
        subScibeController.deliveries = "";
        subScibeController.selectTime = "";
        subScibeController.editDate = "";
      });
      for (var i = 0; i < subScibeController.day.length; i++) {
        subScibeController.selectedIndexes.add(subScibeController.day[i]);
      }
    }
  }

  Future<void> setupHive() async {
    await Hive.initFlutter();
    cart = Hive.box<CartItem>('cart');
    AsyncSnapshot.waiting();
    list = [];
    for (var element in cart.values) {
      if (element.storeID ==
          storeDataContoller.storeDataInfo?.storeInfo.storeId) {
        list.add(element.id);
      }
    }
  }

  getSubScriptionProductTypeList() {
    itemList = [];
    for (var element
        in productDetailsController.productInfo!.productData.productInfo) {
      if (element.subscriptionRequired != "0" && element.productOutStock=="0") {
        itemList.add(element.title);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (isEmpty1 == "0") {
          if (cart.isNotEmpty) {
            for (var element in cart.values) {
              if (element.storeID ==
                  storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                if (element.cartCheck == "1") {
                  if (element.selectDelivery == "" ||
                      element.startDate == "" ||
                      element.startTime == "") {
                    cart.delete(element.id);
                  }
                  Get.back();
                } else {
                  Get.back();
                }
              } else {
                Get.back();
              }
            }
          } else {
            Get.back();
          }
        } else {
          Get.back();
        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: WhiteColor,
        bottomNavigationBar: Container(
          height: 60,
          width: Get.size.width,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {

                },
                child: Container(
                  height: 45,
                  width: Get.size.width * 0.6,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 33,
                        width: 33,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: WhiteColor,
                        ),
                        child: Image.asset(
                          "assets/shopping-bag-bold.png",
                          height: 18,
                          width: 18,
                          color: gradient.defoultColor,
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.1,
                      ),
                      Text(
                        "SUBSCRIBE".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 15,
                          color: WhiteColor,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: gradient.btnGradient,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
        body: GetBuilder<ProductDetailsController>(builder: (context) {
          if (productDetailsController.isLoading == true) {
            getSubScriptionProductTypeList();
          }
          return SafeArea(
            child: productDetailsController.isLoading
                ? Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () {

                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.arrow_back,
                                size: 19,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Create Subscription".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 14,
                              color: BlackColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: 110,
                                width: Get.size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 90,
                                      width: 90,
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            "assets/ezgif.com-crop.gif",
                                        placeholderCacheHeight: 90,
                                        placeholderCacheWidth: 90,
                                        placeholderFit: BoxFit.cover,
                                        image: Config.imageUrl + img,
                                        fit: BoxFit.cover,
                                      ),
                                      decoration: BoxDecoration(
                                        color: WhiteColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            title,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              fontSize: 16,
                                              color: BlackColor,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          itemList.length > 1
                                              ? Container(
                                                  height: 30,
                                                  width: 100,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.only(
                                                      left: 15, right: 15),
                                                  child: DropdownButton(
                                                    onTap: () {},
                                                    value: selectItem,
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 25,
                                                    isExpanded: true,
                                                    // itemHeight: ,
                                                    underline:
                                                        SizedBox.shrink(),
                                                    items: itemList
                                                        .map((String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(
                                                            fontFamily: FontFamily
                                                                .gilroyMedium,
                                                            color: BlackColor,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      for (var i = 0;
                                                          i <
                                                              productDetailsController
                                                                  .productInfo!
                                                                  .productData
                                                                  .productInfo
                                                                  .length;
                                                          i++) {
                                                        print("============" +
                                                            value.toString());
                                                        print(
                                                            "===========${productDetailsController.productInfo?.productData.productInfo[i].title}");
                                                        if (value ==
                                                            productDetailsController
                                                                .productInfo
                                                                ?.productData
                                                                .productInfo[i]
                                                                .title) {
                                                          attributeId = productDetailsController
                                                                  .productInfo
                                                                  ?.productData
                                                                  .productInfo[
                                                                      i]
                                                                  .attributeId ??
                                                              "";
                                                          productTitle =
                                                              productDetailsController
                                                                      .productInfo
                                                                      ?.productData
                                                                      .productInfo[
                                                                          i]
                                                                      .title ??
                                                                  "";
                                                          sprice = productDetailsController
                                                                  .productInfo
                                                                  ?.productData
                                                                  .productInfo[
                                                                      i]
                                                                  .subscribePrice ??
                                                              "";
                                                          aprice = productDetailsController
                                                                  .productInfo
                                                                  ?.productData
                                                                  .productInfo[
                                                                      i]
                                                                  .normalPrice ??
                                                              "";
                                                          per = productDetailsController
                                                                  .productInfo
                                                                  ?.productData
                                                                  .productInfo[
                                                                      i]
                                                                  .productDiscount ??
                                                              "";
                                                          print(
                                                              productDetailsController
                                                                  .productInfo
                                                                  ?.productData
                                                                  .productInfo[
                                                                      i]
                                                                  .subscribePrice
                                                                  .toString());
                                                          print("|||||||" +
                                                              sprice);
                                                        }
                                                      }
                                                      setState(() {
                                                        selectItem = value;
                                                      });
                                                      subScibeController
                                                          .selectDay = "";
                                                      subScibeController
                                                          .selectMonth = "";
                                                      subScibeController
                                                          .selectYear = "";
                                                      subScibeController
                                                          .deliveries = "";
                                                      subScibeController
                                                          .selectTime = "";
                                                      setState(() {});
                                                    },
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: WhiteColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade200),
                                                  ),
                                                )
                                              : Text(
                                                  productTitle,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.gilroyMedium,
                                                    fontSize: 13,
                                                    color: greytext,
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            "${currency}${double.parse(sprice)}",
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          // Text(
                                          //   "${currency}${170}",
                                          //   style: TextStyle(
                                          //     fontSize: 16,
                                          //     fontFamily: FontFamily.gilroyBold,
                                          //     color: BlackColor,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: gradient.defoultColor.withOpacity(0.1),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                    "assets/shopping-basket.png",
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Choose quantity \n Per day".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 15,
                                      color: BlackColor,
                                    ),
                                  ),
                                  Spacer(),

                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                    "assets/calendar-clock.png",
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "Repeat Daily".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 15,
                                      color: BlackColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              GetBuilder<SubScibeController>(
                                  builder: (context) {
                                return SizedBox(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: Get.width * 0.05,
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount:
                                              subScibeController.day.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              height: Get.size.height * 0.09,
                                              width: Get.size.width * 0.09,
                                              margin: EdgeInsets.all(3),
                                              alignment: Alignment.center,
                                              child: Text(
                                                subScibeController.day[index]
                                                    [0],
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontFamily.gilroyBold,
                                                  color: subScibeController
                                                          .selectedIndexes
                                                          .contains(
                                                              subScibeController
                                                                  .day[index])
                                                      ? WhiteColor
                                                      : gradient.defoultColor,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: subScibeController
                                                        .selectedIndexes
                                                        .contains(
                                                            subScibeController
                                                                .day[index])
                                                    ? gradient.defoultColor
                                                    : transparent,
                                                border: Border.all(
                                                  color: gradient.defoultColor,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          chooseDaysSheet();
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 35,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(right: 4),
                                          padding: EdgeInsets.all(6),
                                          child: Image.asset(
                                            "assets/Editpen.png",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                    "assets/bolts.png",
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    "Recharge/Top".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 15,
                                      color: BlackColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    GetBuilder<SubScibeController>(
                                      builder: (controller) {
                                        return InkWell(
                                          onTap: () {
                                            selectDeliveries();
                                          },
                                          child: Text(
                                            controller.deliveries != ""
                                                ? "${controller.deliveries} Deliveries"
                                                : "Select Delivery".tr,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              color: controller.deliveries != ""
                                                  ? BlackColor
                                                  : greytext,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        selectDeliveries();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 35,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(right: 4),
                                        padding: EdgeInsets.all(6),
                                        child: Image.asset(
                                          "assets/Editpen.png",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                    "assets/calendar-check-alt.png",
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "Start Date".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 15,
                                      color: BlackColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    GetBuilder<SubScibeController>(
                                      builder: (controller) {
                                        return InkWell(
                                          onTap: () {

                                          },
                                          child: Text(
                                            isEmpty1 == "0"
                                                ? subScibeController
                                                            .selectDay !=
                                                        ""
                                                    ? "${"Starting on".tr} ${subScibeController.selectDay}-${subScibeController.selectMonth}-${subScibeController.selectYear}"
                                                    : "Start Date".tr
                                                : "${"Starting on".tr} ${subScibeController.editDate.toString()}",
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              color: isEmpty1 == "0"
                                                  ? subScibeController
                                                              .selectDay !=
                                                          ""
                                                      ? BlackColor
                                                      : greytext
                                                  : BlackColor,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {

                                      },
                                      child: Container(
                                        height: 50,
                                        width: 35,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(right: 4),
                                        padding: EdgeInsets.all(6),
                                        child: Image.asset(
                                          "assets/Editpen.png",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                    "assets/calendar-minus-alt.png",
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "Select Time".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 15,
                                      color: BlackColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    GetBuilder<SubScibeController>(
                                      builder: (controller) {
                                        return InkWell(
                                          onTap: () {

                                          },
                                          child: Text(
                                            subScibeController.selectTime != ""
                                                ? subScibeController.selectTime
                                                : "Start Time".tr,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              color: subScibeController
                                                          .selectTime !=
                                                      ""
                                                  ? BlackColor
                                                  : greytext,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {

                                      },
                                      child: Container(
                                        height: 50,
                                        width: 35,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(right: 4),
                                        padding: EdgeInsets.all(6),
                                        child: Image.asset(
                                          "assets/Editpen.png",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: gradient.defoultColor,
                    ),
                  ),
          );
        }),
      ),
    );
  }

  Future<void> onAddItem(int index, String qtys, {String? object}) async {
    String? id = attributeId.toString();
    String finalPrice = "${(double.parse(sprice) * double.parse(per)) / 100}";
    print("*******------*******" + finalPrice.toString());
    String? price = sprice.toString();
    int? qty = int.parse(qtys);
    qty = qty + 1;
    cart = Hive.box<CartItem>('cart');
    final newItem = CartItem();
    newItem.id = id;
    newItem.price = double.parse(price);
    newItem.quantity = qty;
    newItem.productPrice = double.parse(price);
    print("*******------*******" + newItem.productPrice.toString());
    newItem.strTitle =
        productDetailsController.productInfo?.productData.title ?? "";
    newItem.per = per.toString();
    newItem.isRequride = "1";
    newItem.storeID = storeDataContoller.storeDataInfo?.storeInfo.storeId;
    newItem.sPrice = double.parse(sprice);
    newItem.img = img;
    newItem.productTitle = productTitle;
    newItem.selectDelivery = subScibeController.deliveries != ""
        ? subScibeController.deliveries
        : "";
    newItem.startDate = subScibeController.selectDay != ""
        ? "${subScibeController.selectDay}-${subScibeController.selectMonth}-${subScibeController.selectYear}"
        : "";
    newItem.startTime = subScibeController.selectTime != ""
        ? subScibeController.selectTime
        : "";
    newItem.daysList = subScibeController.selectedIndexes; // daysList
    newItem.cartCheck = "1";
    newItem.productID = productID;
    if (qtys == "0") {
      cart.put(id, newItem);
      catDetailsController.getCartLangth();
      setState(() {});
    } else {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);
    }
  }

  void onRemoveItem(int index, String qtys) {
    String? id = attributeId.toString();
    String? price = sprice.toString();
    int? qty = int.parse(qtys);
    qty = qty - 1;
    cart = Hive.box<CartItem>('cart');
    if (qtys == "1") {
      cart.delete(id);
      setState(() {});
    } else {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);
    }
  }

  String isItem(String? index) {
    for (final item in cart.values) {
      if (item.id == index) {
        return item.quantity.toString();
      }
    }
    return "0";
  }

  Future chooseDaysSheet() {
    return Get.bottomSheet(
      GetBuilder<SubScibeController>(builder: (context) {
        return Container(
          height: Get.height * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  left: 20,
                ),
                child: Text(
                  "Choose Days".tr,
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GetBuilder<SubScibeController>(builder: (context) {
                return Container(
                  height: 50,
                  width: Get.size.width,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: Get.size.width * 0.09),
                  child: ListView.builder(
                    itemCount: subScibeController.day.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          subScibeController.addAndRemovedays(index);
                        },
                        child: Container(
                          height: Get.size.height * 0.09,
                          width: Get.size.width * 0.09,
                          margin: EdgeInsets.all(4),
                          alignment: Alignment.center,
                          child: Text(
                            subScibeController.day[index][0],
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              color: subScibeController.selectedIndexes
                                      .contains(subScibeController.day[index])
                                  ? WhiteColor
                                  : gradient.defoultColor,
                              fontSize: 13,
                            ),
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: subScibeController.selectedIndexes
                                    .contains(subScibeController.day[index])
                                ? gradient.defoultColor
                                : transparent,
                            border: Border.all(
                              color: gradient.defoultColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      subScibeController.dailySelection();
                      // cart = Hive.box<CartItem>('cart');
                      // var item = cart.get(attributeId);
                      // item?.daysList = subScibeController.selectedIndexes;
                      // cart.put(attributeId, item!);
                      // print("<2>" +
                      //     subScibeController.selectedIndexes.toString());

                      // subScibeController
                      //     .selectedIndexes = [];
                      // for (var i = 0;
                      //     i < day.length;
                      //     i++) {
                      //   subScibeController
                      //       .selectedIndexes
                      //       .add(day[i]);
                      // }
                      // setState(() {});
                    },
                    child: Container(
                      height: 33,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        "Daily".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          color: Colors.grey,
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: gradient.defoultColor),
                        color: gradient.defoultColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      subScibeController.weekdaysSelection();
                      // cart = Hive.box<CartItem>('cart');
                      // var item = cart.get(attributeId);
                      // item?.daysList = subScibeController.selectedIndexes;
                      // cart.put(attributeId, item!);

                      // subScibeController
                      //     .selectedIndexes = [];
                      // for (var i = 0; i < 5; i++) {
                      //   subScibeController
                      //       .selectedIndexes
                      //       .add(subScibeController
                      //           .day[i]);
                      // }
                      // setState(() {});
                    },
                    child: Container(
                      height: 33,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Weekdays".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          color: Colors.grey,
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: gradient.defoultColor),
                        color: gradient.defoultColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      subScibeController.weekendsSelection();
                      // cart = Hive.box<CartItem>('cart');
                      // var item = cart.get(attributeId);
                      // item?.daysList = subScibeController.selectedIndexes;
                      // cart.put(attributeId, item!);
                      // print("<4>" +
                      //     subScibeController.selectedIndexes.toString());

                      // subScibeController
                      //     .selectedIndexes = [];
                      // for (var i = 0;
                      //     i < day.length;
                      //     i++) {
                      //   if (day[i] == "Saturday" ||
                      //       day[i] == "Sunday") {
                      //     subScibeController
                      //         .selectedIndexes
                      //         .add(day[i]);
                      //   }
                      // }
                      // setState(() {});
                    },
                    child: Container(
                      height: 33,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Weekends".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          color: Colors.grey,
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: gradient.defoultColor),
                        color: gradient.defoultColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      print(subScibeController.selectedIndexes.toString());
                      // cart = Hive.box<CartItem>('cart');
                      // var item = cart.get(attributeId);
                      // item?.daysList = subScibeController.selectedIndexes;
                      // cart.put(attributeId, item!);
                      Get.back();
                      print("<5>" +
                          subScibeController.selectedIndexes.toString());
                    },
                    child: Container(
                      height: 40,
                      width: Get.size.width * 0.8,
                      alignment: Alignment.center,
                      child: Text(
                        "Confirm".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 15,
                          color: WhiteColor,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: gradient.btnGradient,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          decoration: BoxDecoration(
            color: WhiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        );
      }),
    );
  }

  Future selectDeliveries() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      // isScrollControlled: true,
      builder: (context) {
        return GetBuilder<ProductDetailsController>(builder: (context) {
          return productDetailsController.isLoading
              ? Container(
                  height: Get.size.height * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                          left: 20,
                        ),
                        child: Text(
                          "Choose Deliveries".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            color: greytext,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child:
                            GetBuilder<SubScibeController>(builder: (context) {
                          return ListView.builder(
                            itemCount: productDetailsController.dayinfo.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  subScibeController.changeIndex(
                                      index,
                                      productDetailsController
                                          .dayinfo[index].deDigit);
                                  // cart = Hive.box<CartItem>('cart');
                                  // var item = cart.get(attributeId);
                                  // item?.selectDelivery =
                                  //     productDetailsController
                                  //         .dayinfo[index].title
                                  //         .toString();
                                  // cart.put(attributeId, item!);
                                },
                                child: Container(
                                  height: 35,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(top: 10, left: 10),
                                  child: Text(
                                    productDetailsController
                                        .dayinfo[index].title,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 15,
                                      color: BlackColor,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: subScibeController.currentIndex ==
                                              index
                                          ? gradient.defoultColor
                                          : transparent,
                                    ),
                                    color: subScibeController.currentIndex ==
                                            index
                                        ? gradient.defoultColor.withOpacity(0.1)
                                        : transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              cart = Hive.box<CartItem>('cart');
                              // var item = cart.get(attributeId);
                              // item?.selectDelivery =
                              //     subScibeController.deliveries.toString();
                              // cart.put(attributeId, item!);
                              Get.back();
                            },
                            child: Container(
                              height: 40,
                              width: Get.size.width * 0.8,
                              alignment: Alignment.center,
                              child: Text(
                                "Confirm".tr,
                                style: TextStyle(
                                  fontFamily: FontFamily.gilroyBold,
                                  fontSize: 15,
                                  color: WhiteColor,
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: gradient.btnGradient,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: WhiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
        });
      },
    );
  }






}
