import 'package:diario_viagens_front/components/form_field.dart';
import 'package:diario_viagens_front/theme/theme.dart';
import 'package:flutter/material.dart';

class AddViagemPage extends StatefulWidget {
  const AddViagemPage({super.key});

  @override
  State<AddViagemPage> createState() => _AddViagemPageState();
}

class _AddViagemPageState extends State<AddViagemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        toolbarHeight: 55,
        backgroundColor: theme.primaryColor,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.png',
          height: 80,
          width: 80,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
             Text('Adicionar Viagens', style: theme.textTheme.titleLarge,),
            AppFormField(
              label: 'Buscar Viagens',
              hint: 'Cidade/País',
              suffixIcon: Icon(Icons.search, size: 35,),
            )]),
    ));
  }
}