import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../controllers/user_controller.dart';
import '../models/fetch_me_model.dart';
import '../models/response_model.dart';
import '../models/update_profile_model.dart';

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
    _firstNameController = TextEditingController(text: widget.initialData.name);
    _lastNameController =
        TextEditingController(text: widget.initialData.surname);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  selectFile() async {
    XFile? file = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 1800, maxWidth: 1800);

    if (file != null) {
      setState(() {
        _imageFile = File(file.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      Get.snackbar('Error', 'First name and last name cannot be empty');
      return;
    }

    UpdateProfileModel updatedData = UpdateProfileModel(
      name: _firstNameController.text,
      surname: _lastNameController.text,
      // Add other fields as necessary
    );

    ResponseModel response = await widget.userController
        .editUserProfile(updatedData, imageFile: _imageFile);

    if (response.isSuccess) {
      Get.back(result: true);
      widget.userController.fetchProfilePhoto();
      Get.snackbar('Success', 'Profile updated successfully');
    } else {
      Get.snackbar('Error', 'Failed to update profile: ${response.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await selectFile();
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
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
                                return const CircleAvatar(
                                  radius: 80,
                                  child: Icon(Icons.error, size: 80),
                                );
                              } else if (snapshot.hasData &&
                                  snapshot.data != null) {
                                return CircleAvatar(
                                  radius: 80,
                                  backgroundImage: MemoryImage(snapshot.data!),
                                );
                              } else {
                                return const CircleAvatar(
                                  radius: 80,
                                  child: Icon(Icons.person, size: 80),
                                );
                              }
                            },
                          )
                        : const Icon(Icons.add_a_photo),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _updateProfile,
          child: const Text('Update'),
        ),
      ],
    );
  }
}
