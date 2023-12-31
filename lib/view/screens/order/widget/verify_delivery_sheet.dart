import 'package:sixam_mart_delivery/controller/auth_controller.dart';
import 'package:sixam_mart_delivery/controller/order_controller.dart';
import 'package:sixam_mart_delivery/data/model/response/order_model.dart';
import 'package:sixam_mart_delivery/helper/route_helper.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:sixam_mart_delivery/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyDeliverySheet extends StatefulWidget {
  final OrderModel currentOrderModel;
  final bool? verify;
  final bool? cod;
  final double? orderAmount;
  final bool isSenderPay;
  final bool? isParcel;
  const VerifyDeliverySheet({Key? key, required this.currentOrderModel, required this.verify, required this.orderAmount, required this.cod, this.isSenderPay = false, this.isParcel = false}) : super(key: key);

  @override
  State<VerifyDeliverySheet> createState() => _VerifyDeliverySheetState();
}

class _VerifyDeliverySheetState extends State<VerifyDeliverySheet> {
  @override
  void initState() {
    super.initState();
    Get.find<OrderController>().setOtp('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: GetBuilder<OrderController>(builder: (orderController) {
        return Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Container(
              height: 5, width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                color: Theme.of(context).disabledColor.withOpacity(0.5),
              ),
            ),

            widget.verify! ? Column(children: [
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('otp_verification'.tr, style: robotoBold, textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('enter_otp_number'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor), textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              SizedBox(
                width: 200,
                child: PinCodeTextField(
                  length: 4,
                  appContext: context,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.slide,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    fieldHeight: 30,
                    fieldWidth: 30,
                    borderWidth: 2,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    selectedColor: Theme.of(context).primaryColor,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Theme.of(context).cardColor,
                    inactiveColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    activeColor: Theme.of(context).primaryColor.withOpacity(0.7),
                    activeFillColor: Theme.of(context).cardColor,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onChanged: (String text) => orderController.setOtp(text),
                  beforeTextPaste: (text) => true,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text('collect_otp_from_customer'.tr, style: robotoRegular, textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.paddingSizeLarge),

            ]) : const SizedBox(),

           !orderController.isLoading ? CustomButton(
              buttonText: widget.verify! ? 'submit'.tr : 'ok'.tr,
              radius: Dimensions.radiusDefault,
              margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              onPressed: (widget.verify! && orderController.otp.length != 4) ? null : () {

                 if(widget.cod!){
                  Get.find<OrderController>().updateOrderStatus(widget.currentOrderModel, widget.isSenderPay ? 'picked_up' : 'delivered', parcel: widget.isParcel).then((success) {
                    if(success) {
                      Get.find<AuthController>().getProfile();
                      Get.find<OrderController>().getCurrentOrders();
                    }
                  });
                } else{
                  Get.find<OrderController>().updateOrderStatus(widget.currentOrderModel, widget.isSenderPay ? 'picked_up' : 'delivered', parcel: widget.isParcel).then((success) {
                    if(success) {
                      Get.find<AuthController>().getProfile();
                      Get.find<OrderController>().getCurrentOrders();
                      if(!widget.isSenderPay) {
                        Get.offAllNamed(RouteHelper.getInitialRoute());
                      }
                    }
                  });
                }

              },
            ) : const Center(child: CircularProgressIndicator()),

            widget.verify! ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                'did_not_receive_user_notification'.tr,
                style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
              ),

              orderController.hideNotificationButton ? const SizedBox() : InkWell(
                onTap: () => orderController.sendDeliveredNotification(widget.currentOrderModel.id),
                child: Text(
                  'resend_it'.tr,
                  style: robotoMedium.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                ),
              )
            ]) : const SizedBox(),
            const SizedBox(height: Dimensions.paddingSizeLarge),
          ]),
        );
      }),
    );
  }
}
