import 'dart:convert';
import 'dart:typed_data';

import 'package:client/api/profile.dart';
import 'package:client/components/styles.dart';
import 'package:client/models/profile_info.dart';
import 'package:client/pages/auth/reset_password.dart';
import 'package:client/pages/navigation_bar.dart';
import 'package:client/pages/profile/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

final birthDateProvider = StateProvider<DateTime?>((ref) => null);

final isLoadingDeletePhotoProvider = StateProvider<bool>((ref) => false);
final isLoadingUpdateProfileProvider = StateProvider<bool>((ref) => false);

class EditProfile extends StatelessWidget {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _birthDateController = TextEditingController();

  final ProfileInfo userInfo;

  EditProfile({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    _nameController.text = userInfo.name;
    _surnameController.text = userInfo.surname;
    _birthDateController.text = userInfo.birthDate?.toIso8601String().split('T')[0] ?? '';

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 150,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Consumer(builder: (context, ref, child) {
                        final photoUrl = ref.watch(photoUrlProvider);

                        if (photoUrl.isEmpty) {
                          return const Center(
                            child: SizedBox(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            photoUrl,
                            fit: BoxFit.scaleDown,
                            // Изображение будет заполнять всю высоту карточки
                            // height: baseSizeHeight * 0.2,
                          ),
                        );
                      }),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: SizedBox(
                          height: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Consumer(builder: (context, ref, child) {
                                final isLoadingUpdatePhoto = ref.watch(isLoadingUpdateProfileProvider);

                                if (isLoadingUpdatePhoto) {
                                  return const Center(
                                    child: SizedBox(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: accentButtonStyle,
                                    onPressed: () async {
                                      final picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                                      if (pickedFile != null) {
                                        final imageBytes = await pickedFile.readAsBytes();
                                        final img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));

                                        if (image == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text('An error occurred while loading the image'),
                                          ));
                                        }

                                        final base64String = base64Encode(img.encodePng(image!));

                                        // print(base64String

                                        ref.read(isLoadingUpdateProfileProvider.notifier).state = true;
                                        var result = await updatePhoto(base64String);
                                        ref.read(isLoadingUpdateProfileProvider.notifier).state = false;

                                        if (result.resultStatus == ResultEnum.unauthorized) {
                                          Navigator.popUntil(context, (route) => route.isFirst);
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              transitionDuration: Duration.zero,
                                              pageBuilder: (_, __, ___) => const MyHomePage(),
                                            ),
                                          );
                                        }

                                        var text = result.resultStatus != ResultEnum.ok
                                            ? 'An error occurred while updating the photo'
                                            : 'Photo updated successfully';

                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(text),
                                        ));

                                        if (result.resultStatus == ResultEnum.ok) {
                                          ref.read(photoUrlProvider.notifier).state = '';
                                          var newUserInfo = await getUserInfo();

                                          if (newUserInfo.resultStatus == ResultEnum.unauthorized) {
                                            Navigator.popUntil(context, (route) => route.isFirst);
                                            Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                transitionDuration: Duration.zero,
                                                pageBuilder: (_, __, ___) => const MyHomePage(),
                                              ),
                                            );
                                          }

                                          if (newUserInfo.resultStatus == ResultEnum.ok) {
                                            userInfo.photoUrl = newUserInfo.resultData!.photoUrl;
                                            ref.read(photoUrlProvider.notifier).state =
                                                newUserInfo.resultData!.photoUrl;
                                          }
                                        }
                                      }
                                    },
                                    child: const Text('Edit photo'),
                                  ),
                                );
                              }),
                              Consumer(builder: (context, ref, child) {
                                final isLoadingDeletePhoto = ref.watch(isLoadingDeletePhotoProvider);

                                if (isLoadingDeletePhoto) {
                                  return const Center(
                                    child: SizedBox(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: accentButtonStyle,
                                    onPressed: () async {
                                      ref.read(isLoadingDeletePhotoProvider.notifier).state = true;
                                      var result = await deletePhoto();
                                      ref.read(isLoadingDeletePhotoProvider.notifier).state = false;

                                      if (result.resultStatus == ResultEnum.unauthorized) {
                                        Navigator.popUntil(context, (route) => route.isFirst);
                                        Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: Duration.zero,
                                            pageBuilder: (_, __, ___) => const MyHomePage(),
                                          ),
                                        );
                                      }

                                      var text = result.resultStatus != ResultEnum.ok
                                          ? 'An error occurred while deleting the photo'
                                          : 'Photo deleted successfully';

                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(text),
                                      ));

                                      if (result.resultStatus == ResultEnum.ok) {
                                        ref.read(photoUrlProvider.notifier).state = '';
                                        var newUserInfo = await getUserInfo();
                                        if (newUserInfo.resultStatus == ResultEnum.unauthorized) {
                                          Navigator.popUntil(context, (route) => route.isFirst);
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              transitionDuration: Duration.zero,
                                              pageBuilder: (_, __, ___) => const MyHomePage(),
                                            ),
                                          );
                                        }
                                        if (newUserInfo.resultStatus == ResultEnum.ok) {
                                          userInfo.photoUrl = newUserInfo.resultData!.photoUrl;
                                          ref.read(photoUrlProvider.notifier).state = newUserInfo.resultData!.photoUrl;
                                        }
                                      }
                                    },
                                    child: const Text('Delete photo'),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Consumer(builder: (context, ref, child) {
                final name = ref.watch(nameProvider);

                _nameController.text = name;

                return TextField(
                  style: formTextStyle,
                  controller: _nameController,
                  decoration: formFieldStyleWithLabel('Name'),
                  keyboardType: TextInputType.emailAddress,
                );
              }),
              const SizedBox(height: 12),
              Consumer(builder: (context, ref, child) {
                final surname = ref.watch(surnameProvider);
                _surnameController.text = surname;

                return TextField(
                  style: formTextStyle,
                  controller: _surnameController,
                  decoration: formFieldStyleWithLabel('Surname'),
                  keyboardType: TextInputType.emailAddress,
                );
              }),
              const SizedBox(height: 12),
              Consumer(builder: (context, ref, child) {
                final birthDateProviderValue = ref.watch(birthDateProvider);

                if (birthDateProviderValue != null) {
                  _birthDateController.text = birthDateProviderValue.toIso8601String().split('T')[0] ?? '';
                }

                var decoration = formFieldStyleWithLabel('Birth date (YYYY-MM-DD)',
                    iconButton: IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );

                        if (date != null) {
                          ref.read(birthDateProvider.notifier).state = date;
                          _birthDateController.text = date.toIso8601String().split('T')[0];
                        }
                      },
                    ));

                return TextField(
                  style: formTextStyle,
                  controller: _birthDateController,
                  decoration: decoration,
                  keyboardType: TextInputType.emailAddress,
                );
              }),
              const SizedBox(height: 12),
              Consumer(builder: (context, ref, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: accentButtonStyle,
                    onPressed: () async {
                      final RegExp dateRegex = RegExp(
                        r'^\d{4}-\d{2}-\d{2}$',
                      );

                      if (!dateRegex.hasMatch(_birthDateController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Invalid date format (YYYY-MM-DD)'),
                        ));

                        return;
                      }

                      var result = await updateUserInfo(
                          _nameController.text, _surnameController.text, _birthDateController.text);

                      if (result.resultStatus == ResultEnum.unauthorized) {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration.zero,
                            pageBuilder: (_, __, ___) => const MyHomePage(),
                          ),
                        );
                      }

                      if (result.resultStatus != ResultEnum.ok) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('An error occurred while updating the profile'),
                        ));

                        return;
                      }

                      userInfo.name = _nameController.text;
                      userInfo.surname = _surnameController.text;
                      userInfo.birthDate = DateTime.parse(_birthDateController.text);

                      ref.read(nameProvider.notifier).state = _nameController.text;
                      ref.read(surnameProvider.notifier).state = _surnameController.text;

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Profile updated successfully'),
                      ));
                    },
                    child: const Text('Save changes'),
                  ),
                );
              }),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: accentButtonStyle,
                  onPressed: () async {
                    // var response = await sendPasswordResetEmail(userInfo.email);

                    Future.microtask(() async {
                      var response = await sendPasswordResetEmail(userInfo.email);
                      if (response.resultStatus != ResultEnum.ok) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('An error occurred while sending the email'),
                        ));
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Check your email for the code'),
                      ));
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPasswordPage(),
                      ),
                    );
                  },
                  child: const Text('Change password'),
                ),
              ),
            ],
          ),
        ));
  }
}
