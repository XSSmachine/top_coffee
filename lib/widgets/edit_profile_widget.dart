import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controllers/user_controller.dart';
import '../models/fetch_me_model.dart';
import '../models/response_model.dart';
import '../models/update_profile_model.dart';
import '../routes/route_helper.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';
import '../utils/string_resources.dart';

class CustomAlertDialog extends StatefulWidget {
  final FetchMeModel initialData;
  final UserController userController;

  const CustomAlertDialog({
    super.key,
    required this.initialData,
    required this.userController,
  });

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  Future<Uint8List?>? _profilePhotoFuture;

  @override
  void initState() {
    super.initState();
    _profilePhotoFuture = widget.userController.fetchProfilePhoto();
    _firstNameController =
        TextEditingController(text: widget.initialData.firstName);
    _lastNameController =
        TextEditingController(text: widget.initialData.lastName);
    setState(() {});
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  selectFile() async {
    XFile? file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: Dimensions.height10 * 180,
        maxWidth: Dimensions.width10 * 180);

    if (file != null) {
      setState(() {
        _imageFile = File(file.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      Get.snackbar(AppStrings.errorMsg, AppStrings.errorMsgEmptyName.tr);
      return;
    }

    UpdateProfileModel updatedData = UpdateProfileModel(
      name: _firstNameController.text,
      surname: _lastNameController.text,
    );

    ResponseModel response = await widget.userController
        .editUserProfile(updatedData, imageFile: _imageFile);

    if (response.isSuccess) {
      await widget.userController.getUserProfile();
      await widget.userController.fetchProfilePhoto();
      Get.back(result: true);
      Get.snackbar(
          AppStrings.successMsg.tr, AppStrings.successUpdateProfile.tr);
    } else {
      Get.snackbar(AppStrings.errorMsg.tr,
          ' ${AppStrings.errorMsgFailUpdateProfile.tr}+" "+${response.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppStrings.updateProfile.tr),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                await selectFile();
              },
              child: Container(
                width: Dimensions.width20 * 5,
                height: Dimensions.height20 * 5,
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : widget.initialData.profileUri != null
                        ? FutureBuilder<Uint8List?>(
                            future: _profilePhotoFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircleAvatar(
                                  radius: 80,
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return CircleAvatar(
                                  radius: Dimensions.radius20 * 4,
                                  child: Icon(Icons.error,
                                      size: Dimensions.iconSize24 * 4),
                                );
                              } else if (snapshot.hasData &&
                                  snapshot.data != null) {
                                return CircleAvatar(
                                  radius: Dimensions.radius20 * 4,
                                  backgroundImage: MemoryImage(snapshot.data!),
                                );
                              } else {
                                return CircleAvatar(
                                  radius: Dimensions.radius20 * 4,
                                  child: Icon(Icons.person,
                                      size: Dimensions.iconSize24 * 4),
                                );
                              }
                            },
                          )
                        : const Icon(Icons.add_a_photo),
              ),
            ),
            SizedBox(height: Dimensions.height10),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: AppStrings.firstName.tr),
            ),
            SizedBox(height: Dimensions.height10),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: AppStrings.lastName.tr),
            ),
            SizedBox(height: Dimensions.height15),
            Text(AppStrings.or.tr),
            SizedBox(height: Dimensions.height10),
            GestureDetector(
                onTap: () {
                  Get.toNamed(RouteHelper.changePassPage);
                },
                child: Text(
                  AppStrings.changeYourPass.tr,
                  style: TextStyle(color: AppColors.mainBlueDarkColor),
                ))
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.cancel.tr),
        ),
        TextButton(
          onPressed: _updateProfile,
          child: Text(AppStrings.update.tr),
        ),
      ],
    );
  }
}
