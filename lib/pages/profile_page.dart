import 'package:flutter/material.dart';
import 'package:pr_8/components/profile_ui.dart';
import 'package:pr_8/models/item.dart';
import 'package:pr_8/pages/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _updateData(User updatedUser){
    setState(() {
      admin = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Профиль',
            style: TextStyle(
              color: Color.fromRGBO(76, 23, 0, 1.0),
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          ProfileUi(key: Key('${admin.name} ${admin.surname} ${admin.patronymic} ${admin.telNumber} ${admin.email}'), user: admin),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(user: admin),
                ),
              ).then((updatedUser) {
                if (updatedUser != null) {
                  _updateData(updatedUser);
                }
              });
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(350, 40),
                textStyle: const TextStyle(
                  fontSize: 14,
                )
            ),
            child: const Text('Редактировать профиль'),
          ),
        ],
      ),
    );
  }
}
