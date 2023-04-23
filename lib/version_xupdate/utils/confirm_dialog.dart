import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

confirmDialog({
  Widget? topIcon,
  bool showClose = false,
  double? radius,
  String? title,
  Widget? content,
  String? left,
  String? right,
  double? width,
  double? height,
  GestureTapCallback? onLeft,
  GestureTapCallback? onRight,
  bool barrierDismissible: false,
  TextStyle? contentStyle,
  EdgeInsets? bodyPadding,
  WillPopCallback? onWillPop,
  bool shrink: false,
  Color? rightColor,
  Widget? rightWidget,
  String? name,
}) {
  final dialogHeight = shrink ? null : height ?? 500.w;

  final contentBody = Padding(
    padding: bodyPadding ??
        EdgeInsets.symmetric(
          horizontal: 32.w,
          vertical: 48.w,
        ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        topIcon ?? SizedBox(),
        SizedBox(
          height: topIcon != null ? 28.w : 0.w,
        ),
        title != null
            ? Text(
                '$title',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w600,
                ),
              )
            : SizedBox(),
        SizedBox(height: title != null ? 24.w : 0.0),
        content ?? SizedBox(),
      ],
    ),
  );

  Widget dialogWidget = Center(
    child: Material(
      color: Colors.transparent,
      child: Container(
        width: width ?? 578.w,
        height: dialogHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius??8),
        ),
        child:Stack(
            children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            shrink ? contentBody : Expanded(child: contentBody),
            Container(
              height: 112.w,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color.fromRGBO(208, 211, 217, 1)),
                ),
              ),
              child: Row(
                children: [
                  left == null
                      ? SizedBox()
                      : Expanded(
                          child: InkWell(
                            onTap: onLeft,
                            child: Text(
                              '$left',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32.sp,
                                color: Color.fromRGBO(98, 99, 102, 1),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                  (left == null || right == null)
                      ? SizedBox()
                      : VerticalDivider(
                          color: Color.fromRGBO(208, 211, 217, 1),
                          width: 1.0,
                          thickness: 1.0,
                        ),
                  right == null
                      ? SizedBox()
                      : Expanded(
                          child: InkWell(
                            onTap: onRight,
                            child: rightWidget ??
                                Text(
                                  '$right',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.w600,
                                    color: rightColor ?? Colors.black,
                                  ),
                                ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
          Positioned(
              right: 0.w,
              top: 0.w,
              child: showClose
                  ? GestureDetector(
                onTap: () {
                  Get.back();
                },
                child:
                Container(
                    padding: EdgeInsets.all(24.w),
                    child:  Container(
                      width: 32.w,
                      height: 32.w,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(160,161,166,1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24.w,
                      ),
                    )),
              )
                  : SizedBox()),])
      ),
    ),
  );

  Get.dialog(
    onWillPop != null
        ? WillPopScope(
            onWillPop: onWillPop,
            child: dialogWidget,
          )
        : dialogWidget,
    barrierDismissible: barrierDismissible,
    name: name,
  );
}
