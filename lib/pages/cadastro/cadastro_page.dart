import 'package:diario_viagens_front/components/base_container.dart';
import 'package:diario_viagens_front/components/common_view.dart';
import 'package:diario_viagens_front/components/form_field.dart';
import 'package:diario_viagens_front/services/auth_service.dart';
import 'package:diario_viagens_front/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final FocusNode _focusNodeName = FocusNode();

  final FocusNode _focusNodeUser = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();

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
            flex: 8,
            child: BaseContainer(
                child: ListView(
              children: _buildContext(theme),
            )),
          ),
        ],
      )
    ];
    if (_isLoading) {
      stacks.add(CircularProgressIndicator());
    }
    return Stack(children: stacks);
  }

  List<Widget> _buildContext(ThemeData theme) {
    return [
      SizedBox(
        height: 15,
      ),
      Center(
        child: Text('Cadastro',
            style: theme.textTheme.headline1!
                .copyWith(fontWeight: FontWeight.w500)),
      ),
      SizedBox(
        height: 20,
      ),
      AppFormField(
        maxLines: 1,
        label: 'Nome',
        hint: 'Informe seu nome',
        controller: _controllerName,
        currentFocus: _focusNodeName,
        nextFocus: _focusNodeUser,
      ),
      AppFormField(
        maxLines: 1,
        label: 'Sobrenome',
        hint: 'Informe seu sobrenome',
        controller: _controllerLastName,
        currentFocus: _focusNodeUser,
        nextFocus: _focusNodeEmail,
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
        controller: _controllerPassword,
        currentFocus: _focusNodePassword,
                obsecureText: _obscureText,

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
            child: Text('Cadastrar'),
            onPressed: () {
              _register();
            },
          ),
          SizedBox(
            height: 20,
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

  _register() async {
    if (_controllerEmail.text.isNotEmpty &&
        _controllerName.text.isNotEmpty &&
        _controllerLastName.text.isNotEmpty &&
        _controllerPassword.text.isNotEmpty) {
      String nomeCompleto ='${_controllerName.text} ' '${_controllerLastName.text}';
      try {
        await context.read<AuthService>().register(_controllerEmail.text, _controllerPassword.text, nomeCompleto);
        Navigator.pop(context);
      } on AuthException catch (e) {
        snackWarning(
            text: e.message,
            scaffoldMessengerKey: ScaffoldMessenger.of(context),
            duration: Duration(seconds: 4),
            cor: ThemeApp.orange);
            _controllerEmail.clear();
            _controllerPassword.clear();
            _focusNodeEmail.requestFocus();
      }
    } else {
      snackWarning(text: 'Preencha todos os campos para realizar o cadastro.', scaffoldMessengerKey: ScaffoldMessenger.of(context), cor: ThemeApp.orange, duration: Duration(seconds: 4));
    }
  }
}
