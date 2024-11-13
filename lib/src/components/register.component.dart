import 'package:flutter/material.dart';
import 'package:powertani/components/auth.dart';
import 'package:powertani/src/components/code_verification.component.dart';
import 'package:powertani/src/shared/data/countries.dart';
import 'package:powertani/src/shared/widgets/verticalSpacing.widget.dart';
import 'package:powertani/src/shared/widgets/wave.widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wave/config.dart';

class RegisterComponent extends StatefulWidget {
  const RegisterComponent({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RegisterComponent> createState() => _RegisterComponentState();
}

class _RegisterComponentState extends State<RegisterComponent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController countryFlagController =
      TextEditingController(text: 'US');
  String selectValue = 'US';
  Config animationConfig = CustomConfig(
    gradients: [
      [
        const Color.fromARGB(255, 61, 143, 75),
        const Color.fromARGB(255, 120, 179, 130)
      ],
      [
        const Color.fromARGB(255, 115, 218, 31),
        const Color.fromARGB(255, 121, 143, 61)
      ],
      [
        const Color.fromARGB(255, 22, 125, 185),
        const Color.fromARGB(255, 139, 198, 247)
      ],
      [
        const Color.fromARGB(255, 61, 143, 75),
        const Color.fromARGB(255, 177, 216, 184)
      ]
    ],
    durations: [35000, 19440, 10800, 6000],
    heightPercentages: [0.20, 0.23, 0.25, 0.30],
    gradientBegin: Alignment.bottomLeft,
    gradientEnd: Alignment.topRight,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            waveBackInfo(),
            form(),
            verticalSpacing(10),
            verticalSpacing(10),
            verticalSpacing(10),
            sendCodeButton(),
            verticalSpacing(10),
            BackButton(),
          ],
        ),
      ),
    );
  }

  Widget waveBackInfo() {
    return Stack(
      children: [
        waveAnimation(
          backgroundColor: Colors.purpleAccent,
          height: MediaQuery.of(context).size.height / 3,
          context: context,
          config: animationConfig,
        ),
      ],
    );
  }

  Widget backButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        children: [horizontalSpacing(30), const Icon(Icons.arrow_back_ios_new)],
      ),
    );
  }

  Widget fillInformationBelow() {
    return Column(
      children: [
        Row(
          children: const [
            SizedBox(
              width: 20,
            ),
            Text(
              'Daftar',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          fillInformationBelow(),
          verticalSpacing(15),
          usernameInput(),
          verticalSpacing(15),
          emailInput(),
          verticalSpacing(15),
          passwordInput(),
          verticalSpacing(15),
          confirmPasswordInput(),
        ],
      ),
    );
  }

  Widget usernameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AuthTextField(
        hintText: "Username",
        controller: emailController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Username harus diisi!";
          }
          return null;
        },
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AuthTextField(
        icon: Icons.email,
        hintText: "Email",
        controller: usernameController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Email harus diisi!";
          }
          return null;
        },
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AuthTextField(
        icon: Icons.lock,
        obscureText: true,
        hintText: "Password",
        controller: passwordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Password harus diisi";
          }
          return null;
        },
      ),
    );
  }

  Widget confirmPasswordInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AuthTextField(
        icon: Icons.lock,
        obscureText: true,
        hintText: "Konfirmasi Password",
        controller: confirmPasswordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Password harus diisi";
          }
          return null;
        },
      ),
    );
  }

  Widget sendCodeButton() {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: AuthButton(
            width: MediaQuery.of(context).size.width,
            borderRadius: BorderRadius.circular(5),
            onPressed: () => {},
            text: "Daftar"),
      ),
      onTap: () {},
    );
  }

  Widget BackButton() {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: AuthButton(
            width: MediaQuery.of(context).size.width,
            onPressed: () => {
                  Navigator.pop(context),
                },
            bgColor: Colors.white,
            txtColor: const Color.fromARGB(255, 61, 143, 75),
            borderWidth: 2,
            borderRadius: BorderRadius.circular(5),
            borderColor: const Color.fromARGB(255, 61, 143, 75),
            text: "Kembali"),
      ),
      onTap: () {},
    );
  }
}
