import 'dart:convert';

import 'package:diario_viagens_front/clients/viagem_client.dart';
import 'package:diario_viagens_front/components/card_base.dart';
import 'package:diario_viagens_front/components/common_view.dart';
import 'package:diario_viagens_front/components/form_field.dart';
import 'package:diario_viagens_front/model/viagem.dart';
import 'package:diario_viagens_front/pages/viagem/visualizar/visualizar_viagem.page.dart';
import 'package:diario_viagens_front/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Viagem> viagens = [];
  bool isLoading = false;

  @override
  void initState() {
    _initVariables();
    super.initState();
  }

  _initVariables() async {
    _buscarViagens();
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
    SizedBox(height: 10),
                Expanded(
                  child: CardBase(
                    backgroundColor: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: viagensWidget(),
                  ),
                )          ],
        ),
      ),
    );
  }

  viagensWidget() {
    List<Widget> stack = [];

    if (viagens.isNotEmpty) {
      stack.add(Expanded(
        child: ListView.builder(
          itemCount: viagens.length,
          itemBuilder: (context, index) {
            return Slidable(
              key: UniqueKey(),
              endActionPane: ActionPane(
                  extentRatio: 0.3,
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) async {
                        var retorno = await _excluirViagem(
                            _auth.currentUser!.displayName!,
                            viagens[index].id!);

                        if (retorno) {
                          setState(() {
                            viagens.removeAt(index);
                          });
                          snackWarning(
                              text: 'Viagem Excluída com sucesso!',
                              scaffoldMessengerKey:
                                  ScaffoldMessenger.of(context),
                              cor: ThemeApp.green);
                        }
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Excluir',
                    ),
                  ]),
              child: GestureDetector(
                onTap: () async {
                  var refresh = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              VisualizarViagemPage(viagem: viagens[index])));
                  if (refresh ?? false) {
                    _buscarViagens();
                  }
                },
                child: Padding(
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
                                        color:
                                            Color.fromARGB(255, 145, 145, 145),
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
                                        color:
                                            Color.fromARGB(255, 145, 145, 145),
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
                ),
              ),
            );
          },
        ),
      ));
    } else {
      stack.add(Center(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/travel.svg",
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                "Você ainda não possui viagens registradas.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )
            ],
          ),
        ),
      ));
    }

    if (isLoading) {
      stack.add(CircularProgressIndicator(
        color: theme.primaryColor,
      ));
    }

    return Stack(
      children: stack,
    );
  }

  verificaIcone(double avaliacao) {
    switch (avaliacao) {
      case 1:
        return const Icon(
          Icons.sentiment_very_dissatisfied_outlined,
          color: Colors.red,
          size: 30,
        );
      case 2:
        return const Icon(
          Icons.sentiment_dissatisfied_outlined,
          color: Colors.redAccent,
          size: 30,
        );
      case 3:
        return const Icon(
          Icons.sentiment_neutral,
          color: Colors.amber,
          size: 30,
        );
      case 4:
        return const Icon(
          Icons.sentiment_satisfied_alt,
          color: Colors.lightGreen,
          size: 30,
        );
      case 5:
        return const Icon(
          Icons.sentiment_very_satisfied,
          color: Colors.green,
          size: 30,
        );
    }
  }

  _buscarViagens() async {
    setState(() {
      isLoading = true;
    });
    try {
      return await ViagemClient()
          .buscarViagens(_auth.currentUser!.displayName!)
          .then((value) {
        setState(() {
          viagens = value.viagens;
        });
      });
    } catch (e) {
      snackWarning(
        text: "Erro no servidor ao processar requisição",
        cor: ThemeApp.orange,
        scaffoldMessengerKey: ScaffoldMessenger.of(context),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> _excluirViagem(String usuarioId, String viagemId) async {
    try {
      return await ViagemClient().excluirViagem(usuarioId, viagemId);
    } catch (e) {
      snackWarning(
        text: "Erro ao excluir Viagem",
        cor: ThemeApp.orange,
        scaffoldMessengerKey: ScaffoldMessenger.of(context),
      );
      return false;
    }
  }
}
