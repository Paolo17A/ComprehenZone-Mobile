import 'package:comprehenzone_mobile/providers/loading_provider.dart';
import 'package:comprehenzone_mobile/utils/string_util.dart';
import 'package:comprehenzone_mobile/widgets/custom_miscellaneous_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: stackedLoadingContainer(
            context,
            ref.read(loadingProvider).isLoading,
            Stack(
              children: [
                SingleChildScrollView(
                    child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 2),
                                blurRadius: 4,
                                spreadRadius: 1)
                          ],
                          image: DecorationImage(
                              image: AssetImage(ImagePaths.schoolBG),
                              fit: BoxFit.cover)),
                    ),
                    loginFieldsContainer(context, ref,
                        emailController: emailController,
                        passwordController: passwordController)
                  ],
                ))
              ],
            )),
      ),
    );
  }
}
