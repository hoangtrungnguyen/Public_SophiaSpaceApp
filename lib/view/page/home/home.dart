import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/view/page/task/create_task_page.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: double.infinity,
      child: Stack(
//        physics: \(),
        children: [
          Container(
            height: size.width / 2,
            color: Colors.blue[100],
          ),
          Positioned.fill(
            top: 100,
            left: 20,
            right: 20,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: size.width / 3 * 2,
                  child: Card(
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Nhật ký"),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ListTask(),
                ),
                SizedBox(
                  height: size.width / 3 * 2,
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Quote động lực"),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ListTask extends StatefulWidget {

  const ListTask({Key? key}) : super(key: key);

  @override
  _ListTaskState createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nhiệm vụ ngày",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: 10,
            ),
            // Consumer<TaskProvider>(
            //   builder: (ctx, data, child) {
            //     return Container();
            //   },
            // ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: ListTile(
                tileColor: Colors.black.withOpacity(0.2),
                onTap: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed(CreateTaskPage.nameRoute);
                },
                title: Text("Thêm nhiệm vụ"),
                trailing: Icon(Icons.add),
              ),
            )
          ],
        ),
      ),
    );
  }
}
