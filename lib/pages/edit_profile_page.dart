import 'package:flutter/material.dart';
import 'package:pr_8/models/item.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});
  final User user;
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _patronymicController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telNumberController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _surnameController.text = widget.user.surname;
    _patronymicController.text = widget.user.patronymic;
    _emailController.text = widget.user.email;
    _telNumberController.text = widget.user.telNumber;
    _imageController.text = widget.user.image;
  }

  void _saveProfile(){
    Navigator.pop(context, User(
      _nameController.text,
      _surnameController.text,
      _patronymicController.text,
      _emailController.text,
      _telNumberController.text,
      _imageController.text
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль', style: TextStyle(
          color: Color.fromRGBO(76, 23, 0, 1.0),
          fontSize: 26,
          fontWeight: FontWeight.w600,
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'URL-фотографии'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Имя'),
            ),
            TextField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: 'Фамилия'),
            ),
            TextField(
              controller: _patronymicController,
              decoration: const InputDecoration(labelText: 'Отчество'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Электронная почта'),
            ),
            TextField(
              controller: _telNumberController,
              decoration: const InputDecoration(labelText: 'Телефон'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(350, 40),
                  textStyle: const TextStyle(
                    fontSize: 14,
                  )),
              child: const Text('Сохранить изменения'),
            ),
          ],
        ),
      ),
    );
  }
}
