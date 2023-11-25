import 'dart:convert';

import 'package:diario_viagens_front/clients/viagem_client.dart';
import 'package:diario_viagens_front/components/card_base.dart';
import 'package:diario_viagens_front/components/common_view.dart';
import 'package:diario_viagens_front/components/form_field.dart';
import 'package:diario_viagens_front/model/viagem.dart';
import 'package:diario_viagens_front/pages/auth/login/login_page.dart';
import 'package:diario_viagens_front/pages/viagem/visualizar/visualizar_viagem.page.dart';
import 'package:diario_viagens_front/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Viagem> viagens = [];
  List<Viagem> listaFiltrada = [];

  bool isLoading = false;
  bool notFound = false;
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
        leading: IconButton(
            onPressed: () async {
              await _auth.signOut();
              print(_auth.currentUser);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginPage()));
            },
            icon: const Icon(
              Icons.logout,
              size: 30,
            )),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Minhas Viagens',
                  style: TextStyle(fontSize: 20),
                ),
                Icon(
                  MdiIcons.airplane,
                  color: theme.primaryColor,
                  size: 50,
                )
              ],
            ),
            const SizedBox(height: 12),
            AppFormField(
              label: 'Buscar Viagens',
              hint: 'Cidade',
              suffixIcon: const Icon(
                Icons.search,
                size: 35,
              ),
              onChanged: (text) {
                _filtraLista(text);
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: CardBase(
                backgroundColor: Colors.white,
                width: MediaQuery.of(context).size.width * 0.95,
                child: viagensWidget(),
              ),
            )
          ],
        ),
      ),
    );
  }

  viagensWidget() {
    List<Widget> stack = [];

    if (viagens.isNotEmpty) {
      var lista = listaFiltrada.isNotEmpty ? listaFiltrada : viagens;

      if (listaFiltrada.isNotEmpty) {
        stack.add(buildListView(lista));
      } else if (notFound) {
        stack.add(const Center(
            child: Text('Nenhum item encontrado com o filtro atual')));
      } else {
        // Mostra a lista original, pois nenhum filtro está ativo
        stack.add(buildListView(lista));
      }
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
              const SizedBox(height: 20),
              const Text(
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

  Widget buildListView(List<Viagem> lista) {
    return Expanded(
        child: ListView.builder(
      addAutomaticKeepAlives: true,
      itemCount: lista.length,
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
                        _auth.currentUser!.displayName!, lista[index].id!);

                    if (retorno) {
                      setState(() {
                        lista.removeAt(index);
                      });
                      snackWarning(
                          text: 'Viagem Excluída com sucesso!',
                          scaffoldMessengerKey: ScaffoldMessenger.of(context),
                          cor: ThemeApp.green);
                    }
                  },
                  backgroundColor: const Color(0xFFFE4A49),
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
                            VisualizarViagemPage(viagem: lista[index])));
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
                            base64Decode(lista[index].imagemCapa),
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
                                        Text(lista[index].localizacao!.cidade,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                      ],
                                    ),
                                    verificaIcone(lista[index].avaliacao!)
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 0, left: 10),
                                child: Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.earthAmericas,
                                      size: 25,
                                      color: Color.fromARGB(255, 145, 145, 145),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(lista[index].localizacao!.pais,
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
                                      color: Color.fromARGB(255, 145, 145, 145),
                                    ),
                                    Text(lista[index].dataInicio!,
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
              )),
        );
      },
    ));
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

  void _filtraLista(String text) {
    List<Viagem> listaAux = [];
    listaAux = viagens
        .where((element) => element.localizacao!.cidade
            .toUpperCase()
            .contains(text.toUpperCase()))
        .toList();

    setState(() {
      if (listaAux.isNotEmpty) {
        notFound = false;
        listaFiltrada = listaAux;
      } else {
        notFound = true;
        listaFiltrada = listaAux;
      }
    });
  }
}
