import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/view_model/account_view_model.dart';

class NoteTabStatistic extends StatefulWidget {
  const NoteTabStatistic({Key? key}) : super(key: key);

  @override
  _NoteTabStatisticState createState() => _NoteTabStatisticState();
}

class _NoteTabStatisticState extends State<NoteTabStatistic> {
  @override
  Widget build(BuildContext context) {
    AccountViewModel accountViewModel = Provider.of<AccountViewModel>(context);
    return Container(
      child: Stack(
        children: [
          Align(
            child: Text(
              "Nhật ký của ${accountViewModel.getCurrentUser()?.displayName}",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.apply(color: Colors.grey.withOpacity(0.8)),
              textAlign: TextAlign.center,
            ),
            alignment: Alignment.topCenter,
          ),
        ],
      ),
    );
  }
}

