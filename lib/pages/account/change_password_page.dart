import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:team_coffee/controllers/user_controller.dart';

import '../../base/show_custom_snackbar.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/string_resources.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  UserController userController = Get.find<UserController>();
  bool _isSubmitEnabled = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _updateSubmitButtonState() {
    setState(() {
      _isSubmitEnabled = _oldPasswordController.text.isNotEmpty &&
          _newPasswordController.text.isNotEmpty;
    });
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppStrings.confirmPassChange.tr),
          content: Text(AppStrings.confirmQuestionPassChange.tr),
          actions: <Widget>[
            TextButton(
              child: Text(AppStrings.cancel.tr),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppStrings.confirm.tr),
              onPressed: () {
                Navigator.of(context).pop();
                _changePassword();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword() async {
    userController
        .changePassword(
            _oldPasswordController.text, _newPasswordController.text)
        .then((status) {
      if (status.isSuccess) {
        showCustomSnackBar(status.message,
            isError: false,
            title: AppStrings.successMsg.tr,
            color: AppColors.mainBlueMediumColor);
        Get.toNamed(RouteHelper.getInitial());
      } else if (status.message ==
          'The old password you entered is incorrect') {
        showCustomSnackBar(status.message);
      } else {
        showCustomSnackBar(status.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.changeYourPass.tr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _oldPasswordController,
                  decoration: InputDecoration(labelText: AppStrings.oldPass.tr),
                  obscureText: true,
                  onChanged: (value) {
                    _updateSubmitButtonState();
                  },
                ),
                SizedBox(height: Dimensions.height15),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(labelText: AppStrings.newPass.tr),
                  obscureText: true,
                  onChanged: (value) {
                    _updateSubmitButtonState();
                  },
                ),
                SizedBox(height: Dimensions.height20),
                ElevatedButton(
                  child: Text(AppStrings.submit.tr),
                  onPressed: _isSubmitEnabled ? _showConfirmationDialog : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
