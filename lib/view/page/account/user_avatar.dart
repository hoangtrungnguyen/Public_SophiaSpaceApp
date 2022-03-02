import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';
import 'package:sophia_hub/view_model/account_view_model.dart';
import 'package:sophia_hub/view_model/account_view_model.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar({Key? key}) : super(key: key);

  @override
  _UserAvatarState createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  late ImagePicker _picker;
  File? _image;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    AccountViewModel auth =
        Provider.of<AccountViewModel>(context);


    return Material(
        elevation: 2,
        shape: continuousRectangleBorder,
        child: SizedBox(
          height: 150,
          width: 150,
          child: auth.appConnectionState == ConnectionState.waiting ?
          AnimatedLoadingIcon() :
          auth.getCurrentUser()?.photoURL == null ?
          Semantics(
            label: 'image_picker_example_from_gallery',
            child: FloatingActionButton(
              onPressed: () async {
                await _updateAvatar(auth, user: auth.getCurrentUser());
              },
              heroTag: 'image0',
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.photo),
            ),
          ) : CachedNetworkImage(
            imageUrl: auth.getCurrentUser()?.photoURL ?? "",
            fit: BoxFit.fill,
            imageBuilder: (context, imageProvider) {
              return GestureDetector(
                onTap: () async {
                  await _updateAvatar(auth, user: auth.getCurrentUser());
                },
                child: Container(
                  decoration: ShapeDecoration(
                    shape: continuousRectangleBorder,
                    image: DecorationImage(image: imageProvider,
                    fit: BoxFit.cover),
                  ),
                ),
              );
            },
            fadeOutDuration: Duration(milliseconds: 500),
            useOldImageOnUrlChange: true,
            errorWidget: (_, err, stackTrace) {
              return Error();
            },
            placeholder: (context, url) {
              return AnimatedLoadingIcon();
            },
          ),
        ));

    return Material(
      elevation: 2,
      shape: continuousRectangleBorder,
      child: SizedBox(
        height: 150,
        width: 150,
        child: StreamBuilder<User?>(
            initialData: null,
            stream: auth.userChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AnimatedLoadingIcon();
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData && snapshot.data?.photoURL != null) {
                  return CachedNetworkImage(
                    imageUrl: snapshot.data?.photoURL ?? "",
                    fit: BoxFit.fill,
                    imageBuilder: (context, imageProvider) {
                      return GestureDetector(
                        onTap: () async {
                          await _updateAvatar(auth, user: snapshot.data);
                        },
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: continuousRectangleBorder,
                            image: DecorationImage(image: imageProvider),
                          ),
                        ),
                      );
                    },
                    fadeOutDuration: Duration(milliseconds: 500),
                    useOldImageOnUrlChange: true,
                    errorWidget: (_, err, stackTrace) {
                      return Error();
                    },
                    placeholder: (context, url) {
                      return AnimatedLoadingIcon();
                    },
                  );
                } else {
                  return Semantics(
                    label: 'image_picker_example_from_gallery',
                    child: FloatingActionButton(
                      onPressed: () async {
                        await _updateAvatar(auth, user: snapshot.data);
                      },
                      heroTag: 'image0',
                      tooltip: 'Pick Image from gallery',
                      child: const Icon(Icons.photo),
                    ),
                  );
                }
              } else {
                return Error();
              }
            }),
      ),
    );
  }

  Future _updateAvatar(AccountViewModel auth, {User? user}) async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    bool isOk = await auth.updateAvatar(image.path, user!.uid);
    if (isOk) {
    } else {
      showErrMessage(context, auth.error!);
    }
  }
}
//
// Future<void> retrieveLostData() async {
//   final LostDataResponse response = await _picker.retrieveLostData();
//   if (response.isEmpty) {
//     return;
//   }
//
//   if (response.file != null) {
//       setState(() {
//         _imageFile = response.file;
//       });
//     }
//   } else {
//     _retrieveDataError = response.exception!.code;
//   }
// }

class Holder extends StatelessWidget {
  const Holder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: SizedBox(
            height: 150,
            width: 150,
            child: TextButton(
              onPressed: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_rounded),
                  Text(
                    "Ảnh đại diện",
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )));
  }
}

class Error extends StatelessWidget {
  const Error({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: SizedBox(height: 150, width: 150, child: Icon(Icons.error)));
  }
}
