import 'package:client/api/profile.dart';
import 'package:client/models/profile_info.dart';
import 'package:client/pages/auth/reset_password.dart';
import 'package:client/pages/profile/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final birthDateProvider = StateProvider<DateTime?>((ref) => null);

class EditProfile extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _birthDateController = TextEditingController();

  final ProfileInfo userInfo;

  EditProfile({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseSizeHeight * 0.03;

    _nameController.text = userInfo.name ?? '';
    _surnameController.text = userInfo.surname ?? '';
    _birthDateController.text = userInfo.birthDate?.toIso8601String().split('T')[0] ?? '';

    // var birthDateProviderValue = ref.watch(birthDateProvider);
    //
    // if (userInfo.birthDate != null) {
    //   _birthDateController.text = userInfo.birthDate!.toIso8601String().split('T')[0];
    // }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: ListView(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.network(
                      userInfo.photoUrl,
                      fit: BoxFit.scaleDown,
                      // Изображение будет заполнять всю высоту карточки
                      height: baseSizeHeight * 0.2,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ListTile(
                            title: Text('Edit photo',
                                style:
                                TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
                            // leading: const Icon(Icons.photo),
                            onTap: () {
                              // Реализуйте логику для редактирования профиля
                            },
                          ),
                          ListTile(
                            title: Text('Delete photo',
                                style: TextStyle(
                                    fontFamily: 'inter',
                                    fontSize: baseFontSize * 0.7)),
                            // leading: const Icon(Icons.delete),
                            onTap: () {
                              // Реализуйте логику для редактирования профиля
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // TextFormField(
                    //   controller: _nameController,
                    //   decoration: const InputDecoration(
                    //     labelText: 'Name',
                    //   ),
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter your name';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    TextFormField(
                      controller: _surnameController,
                      decoration: const InputDecoration(
                        labelText: 'Surname',
                      ),
                    ),
                    Consumer(builder: (context, ref, child) {
                      final birthDateProviderValue = ref.watch(birthDateProvider);

                      if (birthDateProviderValue != null) {
                        _birthDateController.text =
                            birthDateProviderValue.toIso8601String().split('T')[0] ??
                                '';
                      }

                      return TextFormField(
                        controller: _birthDateController,
                        decoration: InputDecoration(
                          labelText: 'Birth date (YYYY-MM-DD)',
                          suffixIcon: IconButton(
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
                                _birthDateController.text =
                                date.toIso8601String().split('T')[0];
                              }
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }

                          final RegExp dateRegex = RegExp(
                            r'^\d{4}-\d{2}-\d{2}$',
                          );

                          if (!dateRegex.hasMatch(value)) {
                            return 'Invalid date format (YYYY-MM-DD)';
                          }

                          // Дополнительная проверка на корректность даты можно добавить по необходимости

                          return null; // возвращаем null если дата прошла верификацию успешно
                        },
                      );
                    }),
                    Consumer(builder: (context, ref, child) {
                      return ListTile(
                        title: Text('Save changes',
                            style:
                            TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
                        // leading: const Icon(Icons.photo),
                        onTap: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          var result = await updateUserInfo(
                              _nameController.text,
                              _surnameController.text,
                              _birthDateController.text
                          );

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
                      );
                    }),
                    ListTile(
                      title: Text('Change password',
                          style:
                          TextStyle(fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
                      // leading: const Icon(Icons.photo),
                      onTap: () async {
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
