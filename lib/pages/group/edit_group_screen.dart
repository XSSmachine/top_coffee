import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_coffee/models/group/group_member.dart';
import 'dart:io';
import '../../controllers/user_controller.dart';
import '../../models/response_model.dart';
import '../../models/update_group_model.dart';
import '../../utils/dimensions.dart';
import '../../utils/string_resources.dart';

class GroupScreen extends StatefulWidget {
  final String groupId;

  GroupScreen({required this.groupId});

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  File? _imageFile;
  Future<String?>? _profilePhotoFuture;
  String groupName = 'Group Name';
  String groupDescription = 'Group Description goes here.';
  bool isEditing = false;
  bool hasUnsavedChanges = false;

  UserController userController = Get.find<UserController>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = groupName;
    descriptionController.text = groupDescription;

    Future.microtask(() async {
      await _fetchGroupDetails();
      await _fetchGroupMembers();
      await userController.getUserProfile();
      if (mounted) setState(() {});
    });
  }

  bool get isPresident {
    GroupMember? currentMember = userController.groupMembers.firstWhereOrNull(
        (member) => member.userProfileId == userController.user!.userProfileId);
    return currentMember?.roles.contains('PRESIDENT') ?? false;
  }

  bool get isAdmin {
    GroupMember? currentMember = userController.groupMembers.firstWhereOrNull(
        (member) => member.userProfileId == userController.user!.userProfileId);
    return currentMember?.roles.contains('ADMIN') ?? false;
  }

  bool isCurrentUser(GroupMember user) {
    return user.userProfileId == userController.user!.userProfileId;
  }

  Future<void> _fetchGroupDetails() async {
    await userController.getGroupData();
    setState(() {
      groupName = userController.group.value!.name;
      groupDescription = userController.group.value!.description;
      nameController.text = groupName;
      descriptionController.text = groupDescription;
    });
  }

  Future<void> _fetchGroupMembers() async {
    await userController.fetchGroupMembers();
    setState(() {}); // Trigger a rebuild to reflect the new data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Group'),
        actions: [
          if (hasUnsavedChanges)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveChanges,
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildWideLayout();
          } else {
            return _buildNarrowLayout();
          }
        },
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _buildGroupInfo(),
        ),
        Expanded(
          flex: 2,
          child: _buildUserList(),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        _buildGroupInfo(),
        Expanded(child: _buildUserList()),
      ],
    );
  }

  Widget _buildGroupInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onTap: isPresident ? _selectFile : null,
            child: Container(
              width: Dimensions.width20 * 5,
              height: Dimensions.height20 * 5,
              child: _imageFile != null
                  ? ClipOval(
                      child: Image.file(_imageFile!, fit: BoxFit.cover),
                    )
                  : userController.group.value?.photoUrl != null
                      ? ClipOval(
                          child: Image.network(
                            userController.group.value!.photoUrl!,
                            fit: BoxFit.cover,
                            width: Dimensions.width20 * 5,
                            height: Dimensions.height20 * 5,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return CircleAvatar(
                                radius: Dimensions.radius20 * 4,
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return CircleAvatar(
                                radius: Dimensions.radius20 * 4,
                                child: Icon(Icons.error,
                                    size: Dimensions.iconSize24 * 4),
                              );
                            },
                          ),
                        )
                      : CircleAvatar(
                          radius: Dimensions.radius20 * 4,
                          child: Icon(Icons.group,
                              size: Dimensions.iconSize24 * 4),
                        ),
            ),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: isPresident ? () => _startEditing('name') : null,
            child: isEditing
                ? TextField(
                    controller: nameController,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                    onChanged: (_) => _markAsUnsaved(),
                  )
                : Text(
                    groupName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: isPresident ? () => _startEditing('description') : null,
            child: isEditing
                ? TextField(
                    controller: descriptionController,
                    maxLines: null,
                    textAlign: TextAlign.center,
                    onChanged: (_) => _markAsUnsaved(),
                  )
                : Text(
                    groupDescription,
                    textAlign: TextAlign.center,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return Obx(() => ListView.builder(
          itemCount: userController.groupMembers.length,
          itemBuilder: (context, index) {
            final member = userController.groupMembers[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: member.photoUrl != null
                    ? NetworkImage(member.photoUrl!)
                    : null,
                child: member.photoUrl == null
                    ? Text(member.firstName[0] + member.lastName[0])
                    : null,
              ),
              title: Text('${member.firstName} ${member.lastName}'),
              subtitle: Text(member.roles.join(', ')),
              onTap: () => _showUserActionDialog(member),
            );
          },
        ));
  }

  void _selectFile() async {
    if (!isPresident) return;
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1800,
      maxWidth: 1800,
    );

    if (file != null) {
      setState(() {
        _imageFile = File(file.path);
        _markAsUnsaved();
      });
    }
  }

  void _startEditing(String field) {
    if (!isPresident) return;
    setState(() {
      isEditing = true;
      if (field == 'name') {
        nameController.text = groupName;
      } else if (field == 'description') {
        descriptionController.text = groupDescription;
      }
    });
  }

  void _markAsUnsaved() {
    if (!isPresident) return;
    setState(() {
      hasUnsavedChanges = true;
    });
  }

  Future<void> _saveChanges() async {
    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar(AppStrings.errorMsg, AppStrings.errorMsgEmptyName.tr);
      return;
    }

    UpdateGroupModel updatedData = UpdateGroupModel(
      name: nameController.text,
      desc: descriptionController.text,
    );
    print("NAME" + updatedData.name + ' DESC ' + updatedData.desc);
    ResponseModel response =
        await userController.editGroup(updatedData, imageFile: _imageFile);

    if (response.isSuccess) {
      await userController.getGroupData();
      Get.snackbar(
          AppStrings.successMsg.tr, AppStrings.successUpdateProfile.tr);
    } else if (response.message.contains("401")) {
      Get.snackbar(
          AppStrings.errorMsg.tr, ' ${AppStrings.errorMsgFailUnauthorized.tr}');
    } else {
      Get.snackbar(AppStrings.errorMsg.tr,
          ' ${AppStrings.errorMsgFailUpdateProfile.tr}+" "+${response.message}');
    }

    setState(() {
      groupName = nameController.text;
      groupDescription = descriptionController.text;
      isEditing = false;
      hasUnsavedChanges = false;
    });

    if (_imageFile != null) {
      await _uploadGroupImage();
    }
  }

  Future<void> _uploadGroupImage() async {
    // TODO: Implement API call to upload group image
    print('Uploading group image...');
  }

  void _showUserActionDialog(GroupMember user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${user.firstName} ${user.lastName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPresident && !isCurrentUser(user))
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit Role'),
                  onTap: () {
                    Navigator.pop(context);
                    _showEditRoleDialog(user);
                  },
                ),
              if ((isPresident || isAdmin) &&
                      !user.roles.contains('PRESIDENT') ||
                  isCurrentUser(user))
                ListTile(
                  leading: Icon(Icons.person_remove),
                  title:
                      Text(isCurrentUser(user) ? 'Leave Group' : 'Kick User'),
                  onTap: () {
                    Navigator.pop(context);
                    _kickUser(user);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showEditRoleDialog(GroupMember user) {
    if (!isPresident) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only the president can edit roles')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Promote ${user.firstName} to Admin?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _updateUserRole(user, "ADMIN");
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUserRole(GroupMember user, String newRole) async {
    if (!isPresident) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only the president can update roles')),
      );
      return;
    }

    print('Updating role for ${user.firstName} to $newRole');
    await userController.promoteUserFromGroup(user.userProfileId, newRole);

    setState(() {
      if (!user.roles.contains(newRole)) {
        user.roles.add(newRole);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User role updated successfully')),
    );
  }

// Method to kick a user from the group
  Future<void> _kickUser(GroupMember user) async {
    if (!isPresident && !isAdmin && !isCurrentUser(user)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You do not have permission to kick this user')),
      );
      return;
    }

    if (user.roles.contains('PRESIDENT') && !isCurrentUser(user)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('The president cannot be kicked from the group')),
      );
      return;
    }

    String actionText = isCurrentUser(user) ? 'leave' : 'kick';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Action'),
          content: Text(
              'Are you sure you want to $actionText ${isCurrentUser(user) ? 'the group' : user.firstName}?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                Navigator.pop(context);
                print('${actionText.capitalize} user: ${user.firstName}');
                await userController.kickUserFromGroup(user.userProfileId);

                setState(() {
                  userController.groupMembers.remove(user);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          '${user.firstName} ${actionText == 'leave' ? 'left' : 'removed from'} the group')),
                );

                if (isCurrentUser(user)) {
                  // Navigate back to the previous screen or to a group selection screen
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
