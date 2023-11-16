import 'package:diario_viagens_front/components/base_container.dart';
import 'package:diario_viagens_front/components/common_view.dart';
import 'package:diario_viagens_front/components/form_field.dart';
import 'package:diario_viagens_front/pages/auth/cadastro/cadastro_page.dart';
import 'package:diario_viagens_front/services/auth_service.dart';
import 'package:diario_viagens_front/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: _body(),
    );
  }

  Widget _body() {
    ThemeData theme = Theme.of(context);
    List<Widget> stacks = [
      Column(
        children: [
          Expanded(
            flex: 3,
            child: _buildLogo(),
          ),
          Expanded(
            flex: 5,
            child: BaseContainer(
                child: ListView(
              children: _buildContext(theme),
            )),
          ),
        ],
      )
    ];
    return Stack(children: stacks);
  }

  List<Widget> _buildContext(ThemeData theme) {
    return [
      SizedBox(
        height: 15,
      ),
      Center(
        child: Text('Login',
            style: theme.textTheme.headline1!
                .copyWith(fontWeight: FontWeight.w500)),
      ),
      SizedBox(
        height: 40,
      ),
      AppFormField(
        maxLines: 1,
        label: 'Email',
        hint: 'Informe seu email',
        controller: _controllerEmail,
        currentFocus: _focusNodeEmail,
        nextFocus: _focusNodePassword,
      ),
      AppFormField(
        maxLines: 1,
        label: 'Senha',
        hint: 'Informe sua senha',
        obsecureText: _obscureText,
        controller: _controllerPassword,
        currentFocus: _focusNodePassword,
        onFiledSubmited: () {},
        suffixIcon: GestureDetector(
          onTap: _togglePasswordType,
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
      ),
      SizedBox(
        height: 40,
      ),
      Column(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(210, 55),
                backgroundColor: theme.primaryColor,
              ),
              child: Text('Login'),
              onPressed: () {
                _login();
              }),
          SizedBox(
            height: 20,
          ),
          TextButton(
            child: Text('Ainda não possui uma conta? Cadastre-se Agora.'),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => CadastroPage()));
            },
          ),
        ],
      ),
    ];
  }

  void _togglePasswordType() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _buildLogo() {
    return Container(
      child: Image.asset(
        'assets/images/logo.png',
        height: 400,
        width: 400,
      ),
      width: 400,
      height: 400,
    );
  }

  _login() async {
    try {
      await context
          .read<AuthService>()
          .login(_controllerEmail.text, _controllerPassword.text);
    } on AuthException catch (e) {
      snackWarning(
          text: e.message,
          scaffoldMessengerKey: ScaffoldMessenger.of(context),
          cor: ThemeApp.orange);
      _controllerEmail.clear();
      _controllerPassword.clear();
      _focusNodeEmail.requestFocus();
    }
  }
}
