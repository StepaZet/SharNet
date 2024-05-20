import 'package:client/pages/profile/profile_menu.dart';
import 'package:flutter/material.dart';

import 'package:client/api/profile.dart';
import 'package:client/models/profile_info.dart';
import 'package:client/pages/auth/enter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontFamily: 'Inter', fontSize: 25)),
        centerTitle: true,
      ),
      body: FutureBuilder<PossibleErrorResult<ProfileInfo>>(
        future: getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user data found'));
          }

          if (snapshot.data!.resultStatus == ResultEnum.unauthorized) {
            return const EnterPage();
          }

          ProfileInfo userInfo = snapshot.data!.resultData!;
          return ProfileMenu(userInfo: userInfo);
        },
      ),
    );
  }
}
