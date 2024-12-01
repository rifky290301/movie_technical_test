import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../main.dart';
import '../../../../core/helper/helper.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../shared/domain/entities/language_enum.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 48,
          backgroundImage: AssetImage('$assets/images/photo.png'),
        ),
        ListTile(
          textColor: Colors.white,
          title: const Text('Dark Mode'),
          trailing: StatefulBuilder(builder: (context, setState) {
            bool isDark = Helper.isDarkTheme;
            return CupertinoSwitch(
              value: isDark,
              onChanged: (value) {
                Helper.setDarkTheme(context, value);
                setState(() => isDark = value);
              },
            );
          }),
        ),
        ListTile(
          textColor: Colors.white,
          title: const Text('English'),
          trailing: StatefulBuilder(builder: (context, setState) {
            bool isEnglish = Helper.getLang == LanguageEnum.en;
            return CupertinoSwitch(
              value: isEnglish,
              onChanged: (value) {
                if (value) {
                  App.setLocale(context, LanguageEnum.en);
                } else {
                  App.setLocale(context, LanguageEnum.id);
                }
                setState(() => isEnglish = value);
              },
            );
          }),
        ),
      ],
    );
  }
}
