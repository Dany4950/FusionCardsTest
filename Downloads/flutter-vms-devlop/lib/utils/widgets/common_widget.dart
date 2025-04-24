import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../common/colors.dart';
import '../../common/fonts.dart';

Widget getText(
  String text, {
  Color? fontColor,
  int? maxLine,
  double? fontSize,
  String fontFamily = AppFonts.inter,
  TextOverflow? overflow = TextOverflow.ellipsis,
  TextDecoration decoration = TextDecoration.none,
  FontWeight fontWeight = FontWeight.normal,
  TextAlign textAlign = TextAlign.start,
  double? txtHeight,
  bool horFactor = false,
  TextStyle? style,
}) {
  Widget textWidget() {
    return Text(
      text,
      overflow: overflow,
      style: style ??
          TextStyle(
            decoration: decoration,
            fontSize: fontSize,
            fontStyle: FontStyle.normal,
            color: fontColor ?? Colors.black,
            fontFamily: fontFamily,
            height: txtHeight,
            fontWeight: fontWeight,
          ),
      maxLines: maxLine,
      softWrap: true,
      textAlign: textAlign,
      // textScaler:
      // TextScaler.linear(FetchPixels.getTextScale(horFactor: horFactor)),
    );
  }

  return textWidget();
}

Widget getAssetImage(String image,
    {double? width,
    double? height,
    Color? color,
    BoxFit boxFit = BoxFit.fill}) {
  return Image.asset(
    image,
    color: color,
    width: width,
    height: height,
    fit: boxFit,
    // scale: FetchPixels.getScale(),
  );
}

Widget divider = Divider(
  height: 0,
  thickness: 0.53,
  color: AppColors.black.withOpacity(0.08),
);

Widget getNetworkImage(BuildContext context, String image,
    {double? width,
    double? height,
    Color? color,
    BoxFit boxFit = BoxFit.contain,
    Map<String, String>? header,
    bool loadingProgress = false}) {
  return CachedNetworkImage(
    imageUrl: image,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: boxFit,
        ),
      ),
    ),
    placeholder: (context, url) => loadingProgress
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            color: Colors.grey,
            width: width,
            height: height,
          ),
    errorWidget: (context, url, error) => Container(
      color: Colors.grey,
      width: width,
      height: height,
      child: Center(
          child: Icon(
        Icons.error,
        color: Colors.white,
      )),
    ),
    color: color,
    width: width,
    height: height,
    fit: boxFit,
    httpHeaders: header,
    // scale: FetchPixels.getScale(),
  );
}
