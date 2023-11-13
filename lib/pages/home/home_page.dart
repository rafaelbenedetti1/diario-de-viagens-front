import 'dart:convert';

import 'package:diario_viagens_front/clients/viagem_client.dart';
import 'package:diario_viagens_front/components/common_view.dart';
import 'package:diario_viagens_front/components/form_field.dart';
import 'package:diario_viagens_front/model/viagem.dart';
import 'package:diario_viagens_front/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Viagem> viagens = [];

  @override
  void initState() {
    _initVariables();
    super.initState();
  }

  _initVariables() async {
    var retorno = await _buscarViagens();

    setState(() {
      viagens.addAll(retorno.viagens);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
            Text(
              'Minhas Viagens',
              style: theme.textTheme.titleLarge,
            ),
            AppFormField(
              label: 'Buscar Viagens',
              hint: 'Cidade/País',
              suffixIcon: const Icon(
                Icons.search,
                size: 35,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: viagens.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: const Color.fromARGB(255, 243, 243, 243),
                      elevation: 2,
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 243, 243),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.memory(
                                base64Decode(viagens[index].imagemCapa),
                                width: 170,
                                height: double
                                    .infinity, // Defina a largura desejada aqui
                                fit: BoxFit
                                    .cover, // Ajusta a imagem ao tamanho do ClipRRect
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_city_rounded,
                                              size: 30,
                                            ),
                                            Text(
                                                viagens[index]
                                                    .localizacao!
                                                    .cidade,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18)),
                                          ],
                                        ),
                                        verificaIcone(viagens[index].avaliacao!)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 0, left: 10),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 25,
                                          color: Color.fromARGB(
                                              255, 145, 145, 145),
                                        ),
                                        Text(viagens[index].localizacao!.pais,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 145, 145, 145),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 8, left: 10),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          size: 25,
                                          color: Color.fromARGB(
                                              255, 145, 145, 145),
                                        ),
                                        Text(viagens[index].dataInicio!,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 145, 145, 145),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  verificaIcone(double avaliacao) {
    switch (avaliacao) {
      case 1:
        return const Icon(
          Icons.sentiment_very_dissatisfied_outlined,
          color: Colors.red,
        );
      case 2:
        return const Icon(
          Icons.sentiment_dissatisfied_outlined,
          color: Colors.redAccent,
        );
      case 3:
        return const Icon(
          Icons.sentiment_neutral,
          color: Colors.amber,
        );
      case 4:
        return const Icon(
          Icons.sentiment_satisfied_alt,
          color: Colors.lightGreen,
        );
      case 5:
        return const Icon(
          Icons.sentiment_very_satisfied,
          color: Colors.green,
        );
    }
  }

  _buscarViagens() async {
    try {
      return await ViagemClient()
          .buscarViagens(_auth.currentUser!.displayName!);
    } catch (e) {
      snackWarning(
          text: "Erro no servidor ao processar requisição",
          cor: ThemeApp.orange,
          scaffoldMessengerKey: ScaffoldMessenger.of(context),
        );
    }
  }
}
