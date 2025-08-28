import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/onboard/controllers/onboard_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}
class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    Get.find<OnBoardingController>().getOnBoardingList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(builder: (onBoardingController) {
      return Scaffold(
        body: onBoardingController.onBoardingList != null
            ? Stack(
          children: [


            PageView.builder(
              controller: _pageController,
              itemCount: onBoardingController.onBoardingList!.length,
              onPageChanged: (index) {
                onBoardingController.changeSelectIndex(index);
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 28.0),
                  child: CustomAssetImageWidget(
                    onBoardingController.onBoardingList![index].imageUrl,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),

            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: onBoardingController.selectedIndex ==
                      onBoardingController.onBoardingList!.length - 1
                      ? const SizedBox()
                      : InkWell(
                    onTap: _configureToRouteInitialPage,
                    child: Text(
                      "skip".tr,
                      style: robotoBold.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 265,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(onBoardingController),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      onBoardingController
                          .onBoardingList![
                      onBoardingController.selectedIndex]
                          .title,
                      style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      onBoardingController
                          .onBoardingList![
                      onBoardingController.selectedIndex]
                          .description,
                      style: robotoRegular.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(

                      style: ElevatedButton.styleFrom(

                        backgroundColor:
                        Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 14),
                        shape: RoundedRectangleBorder(

                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (onBoardingController.selectedIndex !=
                            onBoardingController
                                .onBoardingList!.length -
                                1) {
                          _pageController.nextPage(
                            duration:
                            const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        } else {
                          _configureToRouteInitialPage();
                        }
                      },
                      child: Text(
                        onBoardingController.selectedIndex ==
                            onBoardingController
                                .onBoardingList!.length -
                                1
                            ? "continue".tr
                            : "get_started".tr,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        )
            : const Center(child: CircularProgressIndicator()),
      );
    });
  }

  List<Widget> _buildPageIndicator(OnBoardingController controller) {
    List<Widget> list = [];
    for (int i = 0; i < controller.onBoardingList!.length; i++) {
      list.add(i == controller.selectedIndex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedScale(
      scale: isActive ? 1.5 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isActive ? 1.0 : 0.4,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 8.0,
          width: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(Get.context!).primaryColor,
          ),
        ),
      ),
    );
  }


  void _configureToRouteInitialPage() async {
    Get.find<SplashController>().disableIntro();
    await Get.find<AuthController>().guestLogin();
    if (AddressHelper.getAddressFromSharedPref() != null) {
      Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true));
    } else {
      Get.find<SplashController>()
          .navigateToLocationScreen('splash', offNamed: true);
    }
  }
}
