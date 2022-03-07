import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/model/quote.dart';
import 'package:sophia_hub/view/page/home/quote_tab/quote_tab_image.dart';
import 'package:sophia_hub/view/page/home/quote_tab/quote_tab_page_view_single.dart';
import 'package:sophia_hub/view/page/quote/quote_hero_widget.dart';
import 'package:sophia_hub/view_model/quote_view_model.dart';

class QuoteSharePage extends StatelessWidget {
  static Widget view(QuoteViewModel viewModel) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: QuoteSharePage(
        quote: viewModel.curQuote!,
      ),
    );
  }

  final Quote quote;

  const QuoteSharePage({Key? key, required this.quote}) : super(key: key);

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
              height: size.height /3 * 1.8,
              width: size.width / 10 * 8,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  QuoteTabImage(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: QuoteTabPageViewSingle(
                      quote: quote,
                    ),
                  )
                ],
              ),
            ),
          ),

          Positioned(
            right: 16,
            left: 16,
            bottom: 16 * 8,
            child: Row(children: [
                Tooltip(
                   message: "Sao chép nội dung của trích dẫn",
                  child: TextButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: quote.content ?? ''));
                        showMessage(context, "Đã sao chép");


                  }, child: Column(children: [
                    Icon(Icons.text_fields_rounded),
                    Text("Sao chép")
                  ])

                  ),
                )
            ],),
          ),
            Positioned(
            right: 80,
    left: 80,
    bottom: 16 ,
              child: TextButton(
                onPressed: (){
                  Navigator.pop(context,false);
                },
              child:Text("Hủy",style: Theme.of(context).textTheme.headline5?.copyWith(
                color: Colors.grey
              ),),),
            )
        ],
      ),
    );
  }
}
