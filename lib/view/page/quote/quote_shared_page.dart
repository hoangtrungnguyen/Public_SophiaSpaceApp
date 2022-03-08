import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/model/quote.dart';
import 'package:sophia_hub/view/page/home/quote_tab/quote_tab_image.dart';
import 'package:sophia_hub/view/page/home/quote_tab/quote_tab_page_view_single.dart';
import 'package:sophia_hub/view/page/quote/quote_hero_widget.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';
import 'package:sophia_hub/view_model/note/shared_quote_view_model.dart';
import 'package:sophia_hub/view_model/quote_view_model.dart';

class QuoteSharePage extends StatelessWidget {
  static Widget view(QuoteViewModel viewModel) {
    return ChangeNotifierProvider<SharedQuoteViewModel>(
        create: (BuildContext context) => SharedQuoteViewModel(),
        child: QuoteSharePage(
          quote: viewModel.curQuote!,
        ));
  }

  final Quote quote;

  QuoteSharePage({Key? key, required this.quote}) : super(key: key);

  final repaintKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0, -0.5),
            child: Container(
              decoration: ShapeDecoration(
                  color: primary.withOpacity(0.8),
                  shape: continuousRectangleBorder),
              height: size.height / 3 * 1.8,
              width: size.width / 10 * 8,
              child: RepaintBoundary(
                key: repaintKey,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    QuoteTabImage(quote: quote),
                    QuoteTabPageViewSingle(
                      quote: quote,
                    ),

                    Positioned(
                      bottom: 8,
                      right: 16,
                      child: Text("SophiaSpace",style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Colors.white.withOpacity(0.8)
                      ),)
                    )
                  ],
                ),
              ),
            ),
          ),
          Selector<SharedQuoteViewModel, bool>(
            selector: (_, viewModel) => viewModel.appConnectionState == ConnectionState.waiting ,
            builder: (context, value, child) =>Visibility(
              visible: value,
              child: child!
            ),
            child: Align(
              alignment: Alignment(0, -0.5),
              child: Container(
                decoration: ShapeDecoration(
                    color: Colors.grey.withOpacity(0.8),
                    shape: continuousRectangleBorder),
                height: size.height / 3 * 1.8,
                width: size.width / 10 * 8,
                child: AnimatedLoadingIcon(size: 60,),
              ),
            ),
          ),
          Positioned(
            right: 16,
            left: 16,
            bottom: 16 * 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Tooltip(
                  message: "Sao chép nội dung của trích dẫn",
                  child: TextButton(
                      onPressed: () async {
                        try {
                          await Clipboard.setData(ClipboardData(
                              text:
                                  "${quote.content} ${quote.author?.name ?? ''}" ??
                                      ''));
                          showMessage(context, "Đã sao chép nội dung");
                        } on Exception catch (e) {
                          showErrMessage(context, e);
                        }
                      },
                      child: Column(children: [
                        Icon(Icons.text_fields_rounded),
                        Text("Sao chép")
                      ])),
                ),
                Tooltip(
                  message: "Lưu ảnh vào thư viện của thiết bị",
                  child: TextButton(
                      onPressed: () async {
                        RenderRepaintBoundary boundary =
                            repaintKey.currentContext?.findRenderObject()
                                as RenderRepaintBoundary;
                        final quoteImage =
                            await boundary.toImage(pixelRatio: 2);
                        bool isOk = await context
                            .read<SharedQuoteViewModel>()
                            .saveToGallery(quoteImage);

                        if (isOk) {
                          showSuccessMessage(context, "Ảnh đã được lưu");
                        } else {
                          showErrMessage(context,
                              context.read<SharedQuoteViewModel>().error!);
                        }
                      },
                      child: Column(
                          children: [Icon(Icons.image), Text("Lưu ảnh")])),
                ),
                Tooltip(
                  message: "Lưu ảnh vào thư viện của thiết bị",
                  child: TextButton(
                      onPressed: () async {
                        RenderRepaintBoundary boundary =
                        repaintKey.currentContext?.findRenderObject()
                        as RenderRepaintBoundary;
                        final quoteImage =
                        await boundary.toImage(pixelRatio: 2);
                        bool isOk = await context
                            .read<SharedQuoteViewModel>()
                            .shareImage(quoteImage);

                        if (isOk) {

                        } else {
                          showErrMessage(context,
                              context.read<SharedQuoteViewModel>().error!);
                        }
                      },
                      child: Column(
                          children: [Icon(Icons.share_rounded), Text("Chia sẻ")])),
                )
              ],
            ),
          ),
          Positioned(
            right: 80,
            left: 80,
            bottom: 16,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                "Hủy",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );
  }
}
