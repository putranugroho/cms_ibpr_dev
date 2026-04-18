import 'package:cms_ibpr/module/auth/login_notifier.dart';
import 'package:cms_ibpr/utils/button_custom.dart';
import 'package:cms_ibpr/utils/colors.dart';
import 'package:cms_ibpr/utils/images_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginNotifier(context: context),
      child: Consumer<LoginNotifier>(
        builder: (context, value, child) => SafeArea(
            child: Scaffold(
                body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                ImageAssets.bodyPattern,
                repeat: ImageRepeat.repeat,
              ),
            ),
            Positioned(
              top: 100,
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 800,
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow(offset: Offset(2, 2), color: Colors.grey[300] ?? Colors.transparent, blurRadius: 5)],
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                            color: colorPrimary, borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16))),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(
                              ImageAssets.logo,
                              color: Colors.white,
                              height: 80,
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Expanded(
                                child: Column(
                              children: [
                                Text(
                                  "CMS",
                                  style: TextStyle(
                                    fontFamily: "Arial Black",
                                    fontSize: 32,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Customer Management System",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "ver. 0.0.1",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withValues(alpha: 0.4),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "last update 18/4/26 01:55",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withValues(alpha: 0.4),
                                  ),
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: value.keyForm,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 32,
                              ),
                              Text(
                                "Username",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                controller: value.username,
                                validator: (e) {
                                  if (e!.isEmpty) {
                                    return "Wajib diisi";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    fillColor: Colors.grey[300],
                                    filled: true,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                "Password",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                controller: value.password,
                                obscureText: value.obscure,
                                validator: (e) {
                                  if (e!.isEmpty) {
                                    return "Wajib diisi";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    fillColor: Colors.grey[300],
                                    filled: true,
                                    suffixIcon: IconButton(
                                        onPressed: () => value.gantiobscure(),
                                        icon: value.obscure ? Icon(Icons.visibility_off) : Icon(Icons.visibility)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              ButtonPrimary(
                                onTap: () async {
                                  await value.cek();
                                },
                                name: "Masuk",
                              )
                            ],
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            )
          ],
        ))),
      ),
    );
  }
}
