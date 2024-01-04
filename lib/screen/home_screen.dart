// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_key_in_widget_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, avoid_print, sized_box_for_whitespace, unused_local_variable, unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:milkman/Api/config.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/controller/catdetails_controller.dart';
import 'package:milkman/controller/home_controller.dart';
import 'package:milkman/controller/notification_controller.dart';
import 'package:milkman/controller/stordata_controller.dart';
import 'package:milkman/helpar/routes_helper.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/screen/onbording_screen.dart';
import 'package:milkman/utils/Colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

var currency;
var wallat1;

class _HomeScreenState extends State<HomeScreen> {
  HomePageController homePageController = Get.find();
  CatDetailsController catDetailsController = Get.find();
  StoreDataContoller storeDataContoller = Get.find();
  NotificationController notificationController = Get.find();

  int selectIndex = 0;
  String name = "";

  @override
  void initState() {
    getCurrentLatAndLong();
    super.initState();
    if (getData.read("UserLogin") != null) {
      setState(() {
        name = getData.read("UserLogin")["name"];
      });
    }
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getCurrentLatAndLong() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {}
    var currentLocation = await locateUser();
    List<Placemark> addresses = await placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);
    await placemarkFromCoordinates(
            currentLocation.latitude, currentLocation.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      address =
          '${placemarks.first.name!.isNotEmpty ? placemarks.first.name! + ', ' : ''}${placemarks.first.thoroughfare!.isNotEmpty ? placemarks.first.thoroughfare! + ', ' : ''}${placemarks.first.subLocality!.isNotEmpty ? placemarks.first.subLocality! + ', ' : ''}${placemarks.first.locality!.isNotEmpty ? placemarks.first.locality! + ', ' : ''}${placemarks.first.subAdministrativeArea!.isNotEmpty ? placemarks.first.subAdministrativeArea! + ', ' : ''}${placemarks.first.postalCode!.isNotEmpty ? placemarks.first.postalCode! + ', ' : ''}${placemarks.first.administrativeArea!.isNotEmpty ? placemarks.first.administrativeArea : ''}';
    });
    print("AAAAAAAAAAAAAAAAAAAAAAA" + address.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return exit(0);
      },
      child: Scaffold(
        backgroundColor: bgcolor,
        body: SafeArea(
          child: RefreshIndicator(
            color: gradient.defoultColor,
            onRefresh: () {
              return Future.delayed(
                Duration(seconds: 2),
                () {
                  homePageController.getHomeDataApi();
                },
              );
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: WhiteColor,
                  elevation: 0,
                  expandedHeight: 132,
                  floating: true,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: SizedBox(
                      height: 230,
                      width: Get.width,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${"Hello".tr},",
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        color: BlackColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        color: BlackColor,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      address,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyMedium,
                                        color: BlackColor,
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  notificationController.getNotificationData();
                                  Get.toNamed(Routes.notificationScreen);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child: Image.asset(
                                    "assets/Notification.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.profileScreen);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child: Image.asset(
                                    "assets/Profile.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () async {
                              Get.toNamed(Routes.homeSearchScreen, arguments: {
                                "statusWiseSearch": true,
                              });
                            },
                            child: Container(
                              height: 45,
                              width: Get.size.width,
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                    "assets/Search.png",
                                    height: 18,
                                    width: 18,
                                    color: Color(0xFF636268),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Search for stores".tr,
                                    style: TextStyle(
                                      color: greyColor,
                                      fontFamily: FontFamily.gilroyMedium,
                                    ),
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: GetBuilder<HomePageController>(builder: (context) {
                    return homePageController.isLoading
                        ? Column(
                            children: [
                              Container(
                                color: WhiteColor,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 190,
                                      width: Get.size.width,
                                      child: CarouselSlider(
                                        options: CarouselOptions(
                                          aspectRatio: 2.0,
                                          enlargeCenterPage: true,
                                          scrollDirection: Axis.horizontal,
                                          autoPlay: true,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              selectIndex = index;
                                            });
                                          },
                                        ),
                                        items: homePageController.bannerList
                                            .map(
                                              (item) => Container(
                                                width: Get.size.width,
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 5,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    fadeInCurve:
                                                        Curves.easeInCirc,
                                                    placeholder:
                                                        "assets/ezgif.com-crop.gif",

                                                    placeholderCacheHeight: 210,
                                                    placeholderFit: BoxFit.fill,
                                                    // placeholderScale: 1.0,
                                                    image: item,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                      width: Get.size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ...List.generate(
                                              homePageController
                                                  .homeInfo!
                                                  .homeData
                                                  .banlist
                                                  .length, (index) {
                                            return Indicator(
                                              isActive: selectIndex == index
                                                  ? true
                                                  : false,
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Fastest Delivery".tr,
                                        style: TextStyle(
                                          color: BlackColor,
                                          fontFamily:
                                              FontFamily.gilroyExtraBold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        "When you need it most".tr,
                                        style: TextStyle(
                                          color: BlackColor,
                                          fontFamily: FontFamily.gilroyMedium,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 260,
                                      width: Get.size.width,
                                      child: homePageController
                                              .homeInfo!
                                              .homeData
                                              .spotlightStore
                                              .isNotEmpty
                                          ? ListView.builder(
                                              itemCount: homePageController
                                                  .homeInfo
                                                  ?.homeData
                                                  .spotlightStore
                                                  .length,
                                              scrollDirection: Axis.horizontal,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () async {
                                                    catDetailsController.strId =
                                                        homePageController
                                                                .homeInfo
                                                                ?.homeData
                                                                .spotlightStore[
                                                                    index]
                                                                .storeId ??
                                                            "";
                                                    await storeDataContoller
                                                        .getStoreData(
                                                      storeId:
                                                          homePageController
                                                              .homeInfo
                                                              ?.homeData
                                                              .spotlightStore[
                                                                  index]
                                                              .storeId,
                                                    );
                                                    save("changeIndex", true);
                                                    homePageController.isback =
                                                        "1";
                                                    Get.toNamed(Routes
                                                        .bottombarProScreen);
                                                  },
                                                  child: Container(
                                                    height: 270,
                                                    width: 290,
                                                    margin: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          children: [
                                                            Container(
                                                              height: 150,
                                                              width: 290,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                                child: FadeInImage
                                                                    .assetNetwork(
                                                                  fadeInCurve:
                                                                      Curves
                                                                          .easeInCirc,
                                                                  placeholder:
                                                                      "assets/ezgif.com-crop.gif",
                                                                  placeholderCacheHeight:
                                                                      240,
                                                                  placeholderCacheWidth:
                                                                      290,
                                                                  placeholderFit:
                                                                      BoxFit
                                                                          .fill,
                                                                  image:
                                                                      "${Config.imageUrl}${homePageController.homeInfo?.homeData.spotlightStore[index].storeCover ?? ""}",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              bottom: -30,
                                                              right: 5,
                                                              child: Container(
                                                                height: 55,
                                                                width: 55,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child: Image
                                                                      .network(
                                                                    "${Config.imageUrl}${homePageController.homeInfo?.homeData.spotlightStore[index].storeLogo ?? ""}",
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      WhiteColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: SizedBox(
                                                            width: Get.width *
                                                                0.44,
                                                            child: Text(
                                                              homePageController
                                                                      .homeInfo
                                                                      ?.homeData
                                                                      .spotlightStore[
                                                                          index]
                                                                      .storeTitle ??
                                                                  "",
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                color:
                                                                    BlackColor,
                                                                fontFamily:
                                                                    FontFamily
                                                                        .gilroyExtraBold,
                                                                fontSize: 17,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Text(
                                                            homePageController
                                                                    .homeInfo
                                                                    ?.homeData
                                                                    .spotlightStore[
                                                                        index]
                                                                    .storeSlogan ??
                                                                "",
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              color: BlackColor,
                                                              fontFamily: FontFamily
                                                                  .gilroyMedium,
                                                              fontSize: 15,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                "assets/Location.png",
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              SizedBox(
                                                                width: Get.size
                                                                        .width *
                                                                    0.3,
                                                                child: Text(
                                                                  homePageController
                                                                          .homeInfo
                                                                          ?.homeData
                                                                          .spotlightStore[
                                                                              index]
                                                                          .storeAddress ??
                                                                      "",
                                                                  maxLines: 1,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .gilroyMedium,
                                                                    color:
                                                                        BlackColor,
                                                                    fontSize:
                                                                        13,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Image.asset(
                                                                "assets/Sport-mode.png",
                                                                height: 18,
                                                                width: 18,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                homePageController
                                                                        .homeInfo
                                                                        ?.homeData
                                                                        .spotlightStore[
                                                                            index]
                                                                        .restDistance ??
                                                                    "",
                                                                maxLines: 1,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .gilroyMedium,
                                                                  color:
                                                                      BlackColor,
                                                                  fontSize: 13,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(
                                              height: 300,
                                              width: Get.size.width,
                                              alignment: Alignment.center,
                                              child: Text(
                                                "No store available \nin your area."
                                                    .tr,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontFamily.gilroyBold,
                                                  fontSize: 15,
                                                  color: BlackColor,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              homePageController
                                      .homeInfo!.homeData.favlist.isNotEmpty
                                  ? SizedBox(
                                      height: 10,
                                    )
                                  : SizedBox(),
                              homePageController
                                      .homeInfo!.homeData.favlist.isNotEmpty
                                  ? Container(
                                      width: Get.size.width,
                                      color: WhiteColor,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            padding: EdgeInsets.only(left: 15),
                                            child: Text(
                                              "Your favorites".tr,
                                              style: TextStyle(
                                                color: BlackColor,
                                                fontFamily:
                                                    FontFamily.gilroyExtraBold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            padding: EdgeInsets.only(left: 15),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Milkman your love".tr,
                                                  style: TextStyle(
                                                    color: BlackColor,
                                                    fontFamily:
                                                        FontFamily.gilroyMedium,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Image.asset(
                                                  "assets/heart.png",
                                                  height: 18,
                                                  width: 18,
                                                  color: gradient.defoultColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 150,
                                            width: Get.size.width,
                                            child: ListView.builder(
                                              itemCount: homePageController
                                                  .homeInfo
                                                  ?.homeData
                                                  .favlist
                                                  .length,
                                              physics: BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () async {
                                                    catDetailsController.strId =
                                                        homePageController
                                                                .homeInfo
                                                                ?.homeData
                                                                .favlist[index]
                                                                .storeId ??
                                                            "";
                                                    await storeDataContoller
                                                        .getStoreData(
                                                      storeId:
                                                          homePageController
                                                              .homeInfo
                                                              ?.homeData
                                                              .favlist[index]
                                                              .storeId,
                                                    );
                                                    Get.toNamed(Routes
                                                        .bottombarProScreen);
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 110,
                                                        width: 90,
                                                        margin:
                                                            EdgeInsets.all(8),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          child: FadeInImage
                                                              .assetNetwork(
                                                            placeholderCacheHeight:
                                                                110,
                                                            placeholderCacheWidth:
                                                                90,
                                                            placeholderFit:
                                                                BoxFit.cover,
                                                            placeholder:
                                                                "assets/ezgif.com-crop.gif",
                                                            image:
                                                                "${Config.imageUrl}${homePageController.homeInfo?.homeData.favlist[index].storeCover ?? ""}",
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          // image: DecorationImage(
                                                          //   image: AssetImage(
                                                          //       "assets/foodimg.jpg"),
                                                          //   fit: BoxFit.cover,
                                                          // ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 95,
                                                        child: Text(
                                                          homePageController
                                                                  .homeInfo
                                                                  ?.homeData
                                                                  .favlist[
                                                                      index]
                                                                  .storeTitle ??
                                                              "",
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily: FontFamily
                                                                .gilroyMedium,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontSize: 15,
                                                            color: BlackColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                color: WhiteColor,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Shop by category".tr,
                                        style: TextStyle(
                                          color: BlackColor,
                                          fontFamily:
                                              FontFamily.gilroyExtraBold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    homePageController.homeInfo!.homeData
                                            .catlist.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: GridView.builder(
                                              itemCount: homePageController
                                                  .homeInfo
                                                  ?.homeData
                                                  .catlist
                                                  .length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                                mainAxisExtent: 130,
                                                crossAxisSpacing: 15,
                                                mainAxisSpacing: 3,
                                              ),
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () async {
                                                    await catDetailsController
                                                        .getCatWiseData(
                                                            catId: homePageController
                                                                    .homeInfo
                                                                    ?.homeData
                                                                    .catlist[
                                                                        index]
                                                                    .id ??
                                                                "");
                                                    Get.toNamed(
                                                      Routes.categoryScreen,
                                                      arguments: {
                                                        "catName":
                                                            homePageController
                                                                    .homeInfo
                                                                    ?.homeData
                                                                    .catlist[
                                                                        index]
                                                                    .title ??
                                                                "",
                                                        "catImag":
                                                            homePageController
                                                                    .homeInfo
                                                                    ?.homeData
                                                                    .catlist[
                                                                        index]
                                                                    .cover ??
                                                                "",
                                                      },
                                                    );
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 80,
                                                        width: 70,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          child: FadeInImage
                                                              .assetNetwork(
                                                            fadeInCurve: Curves
                                                                .easeInCirc,
                                                            placeholder:
                                                                "assets/ezgif.com-crop.gif",

                                                            placeholderCacheHeight:
                                                                80,
                                                            placeholderCacheWidth:
                                                                90,
                                                            placeholderFit:
                                                                BoxFit.fill,
                                                            // placeholderScale: 1.0,
                                                            image:
                                                                "${Config.imageUrl}${homePageController.homeInfo?.homeData.catlist[index].img ?? ""}",
                                                            // fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          // color:
                                                          //     Color(0xFFcfefe0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 40,
                                                        width: 100,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          homePageController
                                                                  .homeInfo
                                                                  ?.homeData
                                                                  .catlist[
                                                                      index]
                                                                  .title ??
                                                              "",
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily: FontFamily
                                                                .gilroyMedium,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : Container(
                                            height: 200,
                                            width: Get.size.width,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "The category \nis unavailable in your area."
                                                  .tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyBold,
                                                fontSize: 15,
                                                color: BlackColor,
                                              ),
                                            ),
                                          ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Shop by store".tr,
                                        style: TextStyle(
                                          color: BlackColor,
                                          fontFamily:
                                              FontFamily.gilroyExtraBold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    homePageController.homeInfo!.homeData
                                            .topStore.isNotEmpty
                                        ? ListView.builder(
                                            itemCount: homePageController
                                                .homeInfo
                                                ?.homeData
                                                .topStore
                                                .length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () async {
                                                  catDetailsController.strId =
                                                      homePageController
                                                              .homeInfo
                                                              ?.homeData
                                                              .topStore[index]
                                                              .storeId ??
                                                          "";
                                                  await storeDataContoller
                                                      .getStoreData(
                                                    storeId: homePageController
                                                        .homeInfo
                                                        ?.homeData
                                                        .topStore[index]
                                                        .storeId,
                                                  );
                                                  save("changeIndex", true);
                                                  homePageController.isback =
                                                      "1";
                                                  Get.toNamed(Routes
                                                      .bottombarProScreen);
                                                },
                                                child: Container(
                                                  height: 180,
                                                  width: Get.size.width,
                                                  margin: EdgeInsets.all(10),
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Container(
                                                        height: 180,
                                                        width: Get.size.width,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          child: FadeInImage
                                                              .assetNetwork(
                                                            placeholder:
                                                                "assets/ezgif.com-crop.gif",
                                                            placeholderCacheHeight:
                                                                180,
                                                            placeholderFit:
                                                                BoxFit.fill,
                                                            // placeholderScale: 1.0,
                                                            image:
                                                                "${Config.imageUrl}${homePageController.homeInfo?.homeData.topStore[index].storeCover ?? ""}",
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        right: 1,
                                                        left: 1,
                                                        child: Container(
                                                          height: 65,
                                                          width: Get.size.width,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 15,
                                                                    right: 15),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  height: 45,
                                                                  width: 45,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                    child: FadeInImage
                                                                        .assetNetwork(
                                                                      placeholder:
                                                                          "assets/ezgif.com-crop.gif",
                                                                      image:
                                                                          "${Config.imageUrl}${homePageController.homeInfo?.homeData.topStore[index].storeLogo ?? ""}",
                                                                    ),
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Color(
                                                                            0xFF000000)
                                                                        .withOpacity(
                                                                            0.5),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    SizedBox(
                                                                      width: Get
                                                                              .size
                                                                              .width *
                                                                          0.6,
                                                                      child:
                                                                          Text(
                                                                        homePageController.homeInfo?.homeData.topStore[index].storeTitle ??
                                                                            "",
                                                                        maxLines:
                                                                            1,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              WhiteColor,
                                                                          fontFamily:
                                                                              FontFamily.gilroyExtraBold,
                                                                          fontSize:
                                                                              20,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 3,
                                                                    ),
                                                                    SizedBox(
                                                                      width: Get
                                                                              .size
                                                                              .width *
                                                                          0.63,
                                                                      child:
                                                                          Text(
                                                                        homePageController.homeInfo?.homeData.topStore[index].storeSlogan ??
                                                                            "",
                                                                        maxLines:
                                                                            1,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              WhiteColor,
                                                                          fontFamily:
                                                                              FontFamily.gilroyMedium,
                                                                          fontSize:
                                                                              14,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(15),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                            image:
                                                                DecorationImage(
                                                              image: AssetImage(
                                                                  "assets/Rectangle.png"),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      homePageController
                                                                      .homeInfo
                                                                      ?.homeData
                                                                      .topStore[
                                                                          index]
                                                                      .couponTitle !=
                                                                  "0" &&
                                                              homePageController
                                                                      .homeInfo
                                                                      ?.homeData
                                                                      .topStore[
                                                                          index]
                                                                      .couponTitle !=
                                                                  ""
                                                          ? Positioned(
                                                              top: -10,
                                                              left: -11,
                                                              child: Container(
                                                                height: 35,
                                                                width: 80,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            4),
                                                                child: Text(
                                                                  homePageController
                                                                          .homeInfo
                                                                          ?.homeData
                                                                          .topStore[
                                                                              index]
                                                                          .couponTitle ??
                                                                      "",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .gilroyMedium,
                                                                    color:
                                                                        WhiteColor,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/topstorelable.png"),
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                      Positioned(
                                                        top: 10,
                                                        right: 10,
                                                        child: Container(
                                                          height: 25,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      8),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                "assets/ic_star_review.png",
                                                                height: 15,
                                                                width: 15,
                                                              ),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                              Text(
                                                                homePageController
                                                                        .homeInfo
                                                                        ?.homeData
                                                                        .topStore[
                                                                            index]
                                                                        .storeRate ??
                                                                    "",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .gilroyMedium,
                                                                  fontSize: 13,
                                                                  color:
                                                                      WhiteColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                    0xFF000000)
                                                                .withOpacity(
                                                                    0.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: WhiteColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .grey.shade300,
                                                        offset: const Offset(
                                                          0.5,
                                                          0.5,
                                                        ),
                                                        blurRadius: 0.5,
                                                        spreadRadius: 0.5,
                                                      ), //BoxShadow
                                                      BoxShadow(
                                                        color: Colors.white,
                                                        offset: const Offset(
                                                            0.0, 0.0),
                                                        blurRadius: 0.0,
                                                        spreadRadius: 0.0,
                                                      ), //BoxShadow
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : Container(
                                            height: 200,
                                            width: Get.size.width,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "No store available \nin your area."
                                                  .tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyBold,
                                                fontSize: 15,
                                                color: BlackColor,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            height: Get.size.height,
                            width: Get.size.width,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: gradient.defoultColor,
                              ),
                            ),
                          );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // final List<Widget> imageSliders = homePageController
  //                                             .homeInfo!.homeData.banlist .map((item) => Container(
  //         child: Container(
  //           margin: EdgeInsets.all(5.0),
  //           child: ClipRRect(
  //               borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //               child: Image.network("${item}", fit: BoxFit.cover, width: 1000.0),),
  //         ),
  //       ))
  //   .toList();
}

class Indicator extends StatelessWidget {
  final bool isActive;
  const Indicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        height: isActive ? 9 : 6,
        width: isActive ? 9 : 6,
        decoration: BoxDecoration(
          color: isActive ? Color(0xFF36393D) : Color(0xFFB3B2B7),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
