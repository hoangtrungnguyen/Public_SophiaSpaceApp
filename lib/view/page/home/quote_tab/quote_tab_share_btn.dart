import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';

class QuoteTabShareButton extends StatelessWidget {
  final BaseCacheManager baseCacheManager = DefaultCacheManager();
  final GlobalKey stackKey;

  QuoteTabShareButton({Key? key, required this.stackKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: TextButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets?>(EdgeInsets.zero),
              backgroundColor: MaterialStateProperty.all<Color?>(
                Colors.white.withOpacity(0.3),
              ),
              shape: MaterialStateProperty.all<OutlinedBorder?>(
                  continuousRectangleBorder as OutlinedBorder)),
          onPressed: () async {
            final RenderRepaintBoundary? boundary = stackKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
            final image = await boundary?.toImage();
            final byteData = await image?.toByteData(format: ImageByteFormat.png);
            final imageBytes = byteData?.buffer.asUint8List();
            final tempDir = await getTemporaryDirectory();
            if(imageBytes == null){
              showErrMessage(context,Exception("Lỗi đã xảy ra, vui lòng thử lại sau"));
              return;
            }
            File file = await File('${tempDir.path}/shared_quote_image.png').create();
            file.writeAsBytesSync(imageBytes);
            Share.shareFiles(['${file.path}'], text: 'Quote from Sophia Space app');
          },
          child: Icon(
            Icons.share,
            color: Colors.white,
            size: 20,
          )),
    );
  }
}
