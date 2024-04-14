import 'dart:math';

import 'package:flutter/material.dart';

import '../../api/profile.dart';
import '../../models/profile_info.dart';
import '../enter_pages/main_enter_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<PossibleErrorResult<ProfileInfo>> _profileInfoFuture;

  @override
  void initState() {
    super.initState();
    _profileInfoFuture = getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    double baseSizeHeight = MediaQuery.of(context).size.height;
    double baseFontSize = baseSizeHeight * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontFamily: 'Inter', fontSize: 25)),
        centerTitle: true,
      ),
      body: FutureBuilder<PossibleErrorResult<ProfileInfo>>(
        future: _profileInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No user data found'));
          }

          if (snapshot.data!.resultStatus == ResultEnum.unauthorized) {
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => EnterPage()),
            //   );
            // });


            return Center(child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error),
                    Text('Unauthorized')
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EnterPage()),
                    );
                  },
                  child: Text('Login'),
                )
              ],
            ));
          }


          ProfileInfo userInfo = snapshot.data!.resultData!;
          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
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
                            Text(userInfo.name,
                                style: TextStyle(
                                    fontFamily: 'inter',
                                    fontSize: baseFontSize * 0.7)
                            ),
                            SizedBox(height: baseFontSize * 0.1),
                            Text(userInfo.email,
                                style: TextStyle(
                                    fontFamily: 'inter',
                                    fontSize: baseFontSize * 0.55,
                                    color: Colors.grey,
                                )
                            ),
                            // Расстояние между элементами
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                title: Text('Edit profile',
                    style: TextStyle(
                        fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
                leading: Icon(Icons.edit),
                onTap: () {
                  // Реализуйте логику для редактирования профиля
                },
              ),
              ListTile(
                title: Text('Favourites',
                    style: TextStyle(
                        fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
                leading: Icon(Icons.favorite),
                onTap: () {},
              ),
              ListTile(
                title: Text('Notifications',
                    style: TextStyle(
                        fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
                leading: Icon(Icons.notifications),
                onTap: () {},
              ),
              ListTile(
                title: Text('Payments',
                    style: TextStyle(
                        fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
                leading: Icon(Icons.payment),
                onTap: () {},
              ),
              ListTile(
                title: Text('Donate',
                    style: TextStyle(
                        fontFamily: 'inter', fontSize: baseFontSize * 0.7)),
                leading: Icon(Icons.card_giftcard),
                onTap: () {},
              ),
            ],
          );
        },
      ),
    );
  }
}
