import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/provider/account_state_manager.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';

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
    AccountStateManager auth = Provider.of<AccountStateManager>(context);

    return StreamBuilder<User?>(
        initialData: null,
        stream: auth.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Card(
              child: SizedBox(
                height: 150,
                width: 150,
                child: AnimatedLoadingIcon(),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              if (snapshot.data?.photoURL != null) {
                return CachedNetworkImage(
                  imageUrl: snapshot.data?.photoURL ?? "",
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) {
                    return Card(
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: ShapeDecoration(
                            shape: continuousRectangleBorder,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      ),
                    );
                  },
                  fadeOutDuration: Duration(milliseconds: 500),
                  useOldImageOnUrlChange: true,
                  errorWidget: (_, err, stackTrace) {
                    return Error();
                  },
                  placeholder: (context, url) {
                    return Card(
                        child: SizedBox(
                            height: 150,
                            width: 150,
                            child: AnimatedLoadingIcon()));
                  },
                );
              } else {
                if (_image != null) {
                  return Card(
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: continuousRectangleBorder,
                        image: DecorationImage(
                            image: FileImage(_image!), fit: BoxFit.cover),
                      ),
                      height: 150,
                      width: 150,
                    ),
                  );
                }
                return Semantics(
                  label: 'image_picker_example_from_gallery',
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: FloatingActionButton(
                      onPressed: () async {
                        XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (image == null) return;

                        setState(() {
                          _image = File(image.path);
                        });

                        bool isOk = await auth.updateAvatar(image.path, snapshot.data!.uid);
                      },
                      heroTag: 'image0',
                      tooltip: 'Pick Image from gallery',
                      child: const Icon(Icons.photo),
                    ),
                  ),
                );
              }
            } else {
              return Holder();
            }
          } else {
            return Error();
          }
        });
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
}

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
