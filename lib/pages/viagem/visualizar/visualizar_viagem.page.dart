import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:diario_viagens_front/clients/viagem_client.dart';
import 'package:diario_viagens_front/components/common_view.dart';
import 'package:diario_viagens_front/components/form_field.dart';
import 'package:diario_viagens_front/components/minhas_visitas.dart';
import 'package:diario_viagens_front/components/pick_svg.dart';
import 'package:diario_viagens_front/mobx/visitas_mobx.dart';
import 'package:diario_viagens_front/model/viagem.dart';
import 'package:diario_viagens_front/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VisualizarViagemPage extends StatefulWidget {
   String usuario = '';
   Viagem? viagem;
   VisualizarViagemPage({super.key, required this.viagem});

  @override
  State<VisualizarViagemPage> createState() => _VisualizarViagemPageState();
}

class _VisualizarViagemPageState extends State<VisualizarViagemPage> {

  String img64 = '';
  List<DateTime?> _dialogCalendarPickerValue = [];
  List<String> imagensSelecionadas = [];
  TextEditingController controllerPais = TextEditingController();
  TextEditingController controllerEstado = TextEditingController();
  TextEditingController controllerCidade = TextEditingController();
  final visitasMobx = GetIt.I.get<VisitasMobx>();
  String dataInicio = '';
  String dataFim = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double? avaliacao;

  @override
  void initState() {
    _preencheViagem();
    super.initState();
  }

  _preencheViagem() async {
    controllerPais.text = widget.viagem?.localizacao?.pais ?? '';
    controllerEstado.text = widget.viagem?.localizacao?.estado ?? '';
    controllerCidade.text = widget.viagem?.localizacao?.cidade ?? '';
    img64 = widget.viagem?.imagemCapa ?? '';
    dataFim = widget.viagem?.dataFim ?? '';
    dataInicio = widget.viagem?.dataInicio ?? '';
    widget.viagem?.imagens.forEach((element) {
      imagensSelecionadas.add(element);
    });
    final formato = DateFormat('dd/MM/yyyy', 'pt_BR');
    _dialogCalendarPickerValue.add((formato.parse(widget.viagem?.dataInicio ?? '')));
    _dialogCalendarPickerValue.add(formato.parse(widget.viagem?.dataFim ?? ''));
    avaliacao = widget.viagem?.avaliacao;
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromARGB(214, 4, 69, 101),
            child: Icon(Icons.save_outlined, size: 30),
            onPressed: () {
            _gravar(visitasMobx.visitas);
          }),
          appBar: AppBar(
            toolbarHeight: 55,
                    leading: BackButton(
          onPressed: () {
            Navigator.pop(context, true);

          }
        ),
            backgroundColor: theme.primaryColor,
            centerTitle: true,
            title: Image.asset(
              'assets/images/logo.png',
              height: 80,
              width: 80,
            ),
          ),
          body: ListView(children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () async {
                    img64.isEmpty ? await selecionaImagem() : null;
                  },
                  child: Container(
                    color: const Color.fromARGB(255, 242, 242, 242),
                    height: 155,
                    width: double.infinity,
                    child: img64.isEmpty
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_search,
                                size: 40,
                              ),
                              Text(
                                'Adicionar foto de capa',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          )
                        : Stack(
                            children: [
                              Image.memory(
                                base64Decode(img64),
                                height: 155,
                                width: double.infinity,
                                fit: BoxFit
                                    .cover, // Define o modo de ajuste para cobrir o espaço
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        selecionaImagem();
                                      },
                                      icon: Container(
                                        height: 35,
                                        width: 35,
                                        child: const Icon(
                                          Icons.edit,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                        decoration: new BoxDecoration(
                                          color: const Color.fromARGB(
                                              116, 0, 0, 0),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          img64 = '';
                                        });
                                      },
                                      icon: Container(
                                        height: 35,
                                        width: 35,
                                        child: const Icon(
                                          Icons.delete,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                        decoration: new BoxDecoration(
                                          color: const Color.fromARGB(
                                              116, 0, 0, 0),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 140.0),
                  child: Expanded(
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25))),
                      margin: EdgeInsets.zero,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Para onde você foi?',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Icon(
                                    MdiIcons.airplaneTakeoff,
                                    color: theme.primaryColor,
                                    size: 35,
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: AppFormField(
                                    label: 'País',
                                    controller: controllerPais,
                                    suffixIcon: const Icon(
                                      FontAwesomeIcons.earthAmericas,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: AppFormField(
                                    label: 'Estado',
                                    controller: controllerEstado,
                                    suffixIcon: const Icon(
                                      FontAwesomeIcons.globe,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: AppFormField(
                                  controller: controllerCidade,
                                  label: 'Cidade',
                                  suffixIcon: const Icon(
                                    FontAwesomeIcons.building,
                                    size: 20,
                                  ),
                                )),
                              ],
                            ),
                            _botaoDataInicioFim(),
                            const Divider(height: 2),
                            MinhasVisitas(visitasViagem: widget.viagem!.visitas.isEmpty ? null : widget.viagem!.visitas),
                            const Divider(height: 2),
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Minhas Imagens',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: theme.primaryColor,
                                      size: 35,
                                    ),
                                  ],
                                )),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primaryColor,
                                  fixedSize: const Size(230, 40)),
                              onPressed: () async {
                                List<String>? newImg64 =
                                    await pickSvg(allowMultiple: true);
                                setState(() {
                                  imagensSelecionadas.addAll(newImg64 ?? []);
                                });
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Adicionar Imagens'),
                                  SizedBox(width: 8),
                                  Icon(Icons.add_a_photo_outlined),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.count(
                                  shrinkWrap: true,
                                  // horizontal, this produces 2 rows.
                                  crossAxisCount: 2,
                                  children: imagensSelecionadas
                                      .map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Container(
                                            height: 170,
                                            width: 170,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: const Color.fromARGB(
                                                    255, 226, 226, 226)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Stack(
                                                  children: [
                                                    Image.memory(
                                                      base64Decode(e),
                                                      height: 170,
                                                      width: double.infinity,
                                                      fit: BoxFit
                                                          .cover, // Define o modo de ajuste para cobrir o espaço
                                                    ),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                imagensSelecionadas
                                                                    .removeWhere(
                                                                        (element) =>
                                                                            element ==
                                                                            e);
                                                              });
                                                            },
                                                            icon: Container(
                                                              height: 35,
                                                              width: 35,
                                                              child: const Icon(
                                                                Icons.delete,
                                                                size: 25,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              decoration:
                                                                  new BoxDecoration(
                                                                color: const Color
                                                                    .fromARGB(
                                                                    116,
                                                                    0,
                                                                    0,
                                                                    0),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList()),
                            ),
                            const Divider(height: 2),
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Avaliação da Viagem',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Icon(
                                      Icons.star_border,
                                      color: theme.primaryColor,
                                      size: 35,
                                    ),
                                  ],
                                )),
                            RatingBar.builder(
                              initialRating: avaliacao ?? 3,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                switch (index) {
                                  case 0:
                                    return const Icon(
                                      Icons
                                          .sentiment_very_dissatisfied_outlined,
                                      color: Colors.red,
                                    );
                                  case 1:
                                    return const Icon(
                                      Icons.sentiment_dissatisfied_outlined,
                                      color: Colors.redAccent,
                                    );
                                  case 2:
                                    return const Icon(
                                      Icons.sentiment_neutral,
                                      color: Colors.amber,
                                    );
                                  case 3:
                                    return const Icon(
                                      Icons.sentiment_satisfied_alt,
                                      color: Colors.lightGreen,
                                    );
                                  case 4:
                                    return const Icon(
                                      Icons.sentiment_very_satisfied,
                                      color: Colors.green,
                                    );
                                }
                                return Container();
                              },
                              onRatingUpdate: (rating) {
                                print(rating);
                                setState(() {
                                  avaliacao = rating;
                                });
                              },
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]));
    });
  }

  Future<void> selecionaImagem() async {
    String? newImg64 = await pickSvg(allowMultiple: false);
    setState(() {
      img64 = newImg64 ?? '';
    });
  }

  _botaoDataInicioFim() {
    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.normal);
    final weekendTextStyle =
        const TextStyle(color: Colors.black, fontWeight: FontWeight.w600);
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: theme.primaryColor,
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                fixedSize: const Size(230, 40)),
            onPressed: () async {
              final values = await showCalendarDatePicker2Dialog(
                context: context,
                config: config,
                dialogSize: const Size(325, 400),
                borderRadius: BorderRadius.circular(15),
                value: _dialogCalendarPickerValue,
                dialogBackgroundColor: Colors.white,
              );
              if (values != null) {
                setState(() {
                  _dialogCalendarPickerValue = values;
                });
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(FontAwesomeIcons.calendarDays),
                const SizedBox(width: 5),
                Text(_dialogCalendarPickerValue.isEmpty
                    ? 'Data Início e Fim'
                    : _dialogCalendarPickerValue != null &&
                            _dialogCalendarPickerValue.length >= 2
                        ? _getValueText(
                            config.calendarType, _dialogCalendarPickerValue)
                        : ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (values.isNotEmpty) {
      dataInicio = DateFormat('dd/MM/yyyy').format(values[0]!);
      dataFim = values.length > 1
          ? DateFormat('dd/MM/yyyy').format(values[1]!)
          : 'null';

      valueText = '$dataInicio a $dataFim';
    } else {
      return 'null';
    }

    return valueText;
  }

  _gravar(List<Visita> visitas) async {
    var viagem = Viagem(
      id: widget.viagem?.id,
        visitas: visitas,
        imagemCapa: img64,
        dataInicio: dataInicio,
        dataFim: dataFim,
        imagens: imagensSelecionadas,
        localizacao: Localizacao(
            cidade: controllerCidade.text,
            estado: controllerEstado.text,
            pais: controllerPais.text),
        avaliacao: avaliacao);
    try {
      var resultado = await ViagemClient()
          .inserirViagem(_auth.currentUser!.displayName!, viagem);
      snackWarning(
          text: "Viagem atualizada com sucesso!",
          cor: ThemeApp.green,
          scaffoldMessengerKey: ScaffoldMessenger.of(context),
            );      // BlocProvider.getBloc<ReloadBloc>().update();
    } catch (e) {
      snackWarning(
          text: "Erro no servidor ao processar requisição",
          cor: ThemeApp.orange,
          scaffoldMessengerKey: ScaffoldMessenger.of(context),
);    }
  }
}