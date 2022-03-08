import 'dart:io';
import 'dart:ui' as ui;

import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/view_model/base_view_model.dart';
import 'package:sophia_hub/view_model/quote_view_model.dart';

class SharedQuoteViewModel extends BaseViewModel {
  Future<bool> saveToGallery(ui.Image quoteImage) async =>
      setAppState(() async {
        try {
          File file = await getImageFile(quoteImage);
          bool? isOk =
              await GallerySaver.saveImage(file.path, albumName: 'SophiaSpace');
          if (isOk != null && isOk) {
            return Result(data: 'Đã lưu');
          } else {
            return Result(err: Exception("Lỗi đã xảy ra"));
          }
        } on Exception catch (e) {
          return Result(err: e);
        }
      });

  Future<bool> shareImage(ui.Image quoteImage) async => setAppState(() async {
        try {
          File file = await getImageFile(quoteImage);
          await Share.shareFiles([file.path], text: 'Từ SophiaSpace');
          return Result(data: 'Đã lưu');
        } on Exception catch (e) {
          return Result(err: e);
        }
      });

  //error may occur here
  Future<File> getImageFile(ui.Image quoteImage) async {
    final byteData = await quoteImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final imageBytes = byteData?.buffer.asUint8List();

    if (imageBytes == null) {
      throw Exception("Lỗi đã xảy ra, vui lòng thử lại sau");
    }

    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/shared_quote_image.png').create();
    await file.writeAsBytes(imageBytes);

    return file;
  }
}
