import 'package:flutter/material.dart';
import 'package:pr_8/models/item.dart';

class ProfileUi extends StatefulWidget {
  const ProfileUi({super.key, required this.user});
  final User user;

  @override
  State<ProfileUi> createState() => _ProfileUiState();
}

class _ProfileUiState extends State<ProfileUi> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(user.image),
                            fit: BoxFit.cover
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: const Color.fromRGBO(76, 23, 0, 1.0),
                            width: 2
                        )
                    ),
                  ),
                  SizedBox(
                    width: 170,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.surname,
                            style:  const TextStyle(
                              fontSize: 18.0,
                              color: Color.fromRGBO(76, 23, 0, 1.0),
                            ),
                        textAlign: TextAlign.left,
                        ),
                        Text(user.name,
                            style:  const TextStyle(
                              fontSize: 18.0,
                              color: Color.fromRGBO(76, 23, 0, 1.0),
                            )),
                        Text(user.patronymic,
                            style:  const TextStyle(
                              fontSize: 18.0,
                              color: Color.fromRGBO(76, 23, 0, 1.0),
                            )),


                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text('Контакты', style: TextStyle(
                color: Color.fromRGBO(76, 23, 0, 1.0),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
                textAlign: TextAlign.left,),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user.telNumber,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(76, 23, 0, 1.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(76, 23, 0, 1.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


