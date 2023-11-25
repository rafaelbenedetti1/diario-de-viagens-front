import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:diario_viagens_front/components/common_view.dart';
import 'package:diario_viagens_front/components/form_field.dart';
import 'package:diario_viagens_front/components/info_timeline.dart';
import 'package:diario_viagens_front/components/pick_svg.dart';
import 'package:diario_viagens_front/mobx/visitas_mobx.dart';
import 'package:diario_viagens_front/model/viagem.dart';
import 'package:diario_viagens_front/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;

class MinhasVisitas extends StatefulWidget {
  final List<Visita>? visitasViagem;

  MinhasVisitas({super.key, required this.visitasViagem});

  @override
  State<MinhasVisitas> createState() => _MinhasVisitasState();
}

class _MinhasVisitasState extends State<MinhasVisitas> {
  List<DateTime?> _dialogCalendarPickerValue = [];
  List<Visita> lista = [];
  final controllerNome = TextEditingController();
  final controllerData = TextEditingController();
  String img64 = '';
  final visitasMobx = GetIt.I.get<VisitasMobx>();

  @override
  void initState() {
    carregaVisitas();
    super.initState();
  }

  carregaVisitas() {
    visitasMobx.setVisitas([]);
    visitasMobx.adicionaVisita([]);
    if (widget.visitasViagem != null) {
      visitasMobx.adicionaVisita(widget.visitasViagem ?? []);
      widget.visitasViagem?.forEach((element) {
        visitasMobx.setVisitas(List.from(visitasMobx.visitasWidget.value)
          ..add(DeliveryProcess(element.nomeLocal, messages: [
            Text(
              element.data,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Image.memory(
                base64Decode(element.imagem),
                height: 150,
                width: 200,
                fit: BoxFit.cover, // D
                // Define o modo de ajuste para cobrir o espaço
              ),
            ),
          ])));
      });
      visitasMobx.setVisitas(List.from(visitasMobx.visitasWidget.value)
        ..add(const DeliveryProcess.complete()));
    } else {
      visitasMobx.setVisitas([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Minhas Visitas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Icon(
                    Icons.park_outlined,
                    color: Color.fromRGBO(245, 245, 245, 1),
                    size: 35,
                  ),
                ],
              )),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                fixedSize: const Size(230, 40)),
            onPressed: () async {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return ScaffoldMessenger(
                    child: StatefulBuilder(builder: (context, setState) {
                      return Scaffold(
                        backgroundColor: Colors.transparent,
                        body: AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Adicionar Visita"),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 30,
                                  ))
                            ],
                          ),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 400,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppFormField(
                                      controller: controllerNome,
                                      label: 'Local',
                                      suffixIcon: const Icon(
                                        FontAwesomeIcons.tag,
                                        size: 20,
                                      ),
                                    ),
                                    _buildCalendarDialogButton(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          String? newImg64 = await pickSvg(
                                              allowMultiple: false);
                                          setState(() {
                                            img64 = newImg64 ?? '';
                                          });
                                        },
                                        child: Material(
                                          elevation: 2,
                                          child: SizedBox(
                                            width: 400,
                                            height: 150,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                img64.isEmpty
                                                    ? const Column(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .image_outlined,
                                                            size: 40,
                                                          ),
                                                          Text('Anexar Imagem'),
                                                        ],
                                                      )
                                                    : Image.memory(
                                                        base64Decode(img64),
                                                        height: 150,
                                                        width: 400,
                                                        fit: BoxFit
                                                            .cover, // Define o modo de ajuste para cobrir o espaço
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 64),
                                        backgroundColor: theme.primaryColor,
                                      ),
                                      onPressed: () {
                                        if (controllerData.text.isNotEmpty &&
                                            controllerNome.text.isNotEmpty &&
                                            img64.isNotEmpty) {
                                          if (visitasMobx
                                              .visitasWidget.value.isNotEmpty) {
                                            visitasMobx.visitasWidget.value
                                                .removeLast();
                                          }

                                          setState(() {
                                            var visita = Visita(
                                                data: controllerData.text,
                                                imagem: img64,
                                                nomeLocal: controllerNome.text);

                                            lista.add(visita);
                                            visitasMobx.adicionaVisita([
                                              ...widget.visitasViagem ?? [],
                                              ...lista
                                            ]);
                                            visitasMobx.setVisitas(List.from(
                                                visitasMobx.visitasWidget.value)
                                              ..add(DeliveryProcess(
                                                  controllerNome.text,
                                                  messages: [
                                                    Text(
                                                      controllerData.text,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12.0),
                                                      child: Image.memory(
                                                        base64Decode(img64),
                                                        height: 150,
                                                        width: 200,
                                                        fit: BoxFit.cover, // D
                                                        // Define o modo de ajuste para cobrir o espaço
                                                      ),
                                                    ),
                                                  ])));
                                            visitasMobx.setVisitas(List.from(
                                                visitasMobx.visitasWidget.value)
                                              ..add(const DeliveryProcess
                                                  .complete()));
                                            controllerData.clear();
                                            controllerNome.clear();
                                            img64 = '';
                                            Navigator.pop(context);
                                          });
                                        } else {
                                          snackWarning(
                                              text:
                                                  'Informe o local, data e a imagem da visita.',
                                              scaffoldMessengerKey:
                                                  ScaffoldMessenger.of(context),
                                              cor: ThemeApp.orange);
                                        }
                                      },
                                      child: const Text('Adicionar'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Adicionar Visita'),
                SizedBox(width: 8),
                Icon(FontAwesomeIcons.locationDot),
              ],
            ),
          ),
          Observer(builder: (context) {
            return ValueListenableBuilder(
                valueListenable: visitasMobx.visitasWidget,
                builder: (context, value, _) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        color: Color.fromARGB(255, 133, 133, 133),
                        fontSize: 15,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5),
                        child: FixedTimeline.tileBuilder(
                          theme: TimelineThemeData(
                            nodePosition: 0,
                            color: const Color(0xff989898),
                            indicatorTheme: const IndicatorThemeData(
                              position: 0,
                              size: 20.0,
                            ),
                            connectorTheme: const ConnectorThemeData(
                              thickness: 2.5,
                            ),
                          ),
                          builder: TimelineTileBuilder.connected(
                            connectionDirection: ConnectionDirection.before,
                            itemCount: value.length,
                            contentsBuilder: (_, index) {
                              if (value[index].isCompleted) return null;

                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          value[index].tituloVisita,
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .copyWith(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red, size: 28),
                                            onPressed: () {
                                              setState(() {
                                                value.removeAt(index);
                                                visitasMobx.visitas
                                                    .removeAt(index);
                                                visitasMobx.setVisitas(value);
                                                visitasMobx.adicionaVisita(
                                                    visitasMobx.visitas);
                                              });
                                            })
                                      ],
                                    ),
                                    _InnerTimeline(
                                        messages: value[index].messages),
                                  ],
                                ),
                              );
                            },
                            indicatorBuilder: (_, index) {
                              if (value[index].isCompleted) {
                                return const DotIndicator(
                                  color: Color(0xff989898),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12.0,
                                  ),
                                );
                              } else {
                                return const OutlinedDotIndicator(
                                  borderWidth: 2.5,
                                );
                              }
                            },
                            connectorBuilder: (_, index, ___) =>
                                SolidLineConnector(
                              color: value[index].isCompleted
                                  ? const Color(0xff989898)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                  ;
                });
          }),
        ],
      ),
    );
  }

  _buildCalendarDialogButton() {
    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.normal);
    const weekendTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w600);
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.single,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: AppFormField(
            label: 'Data',
            suffixIcon: const Icon(
              Icons.calendar_month_outlined,
              size: 20,
            ),
            readOnly: true,
            enabled: false,
            controller: controllerData,
            onTap: () async {
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
                  controllerData.text = _getValueText(
                      config.calendarType, _dialogCalendarPickerValue);
                });
              }
            },
          ),
        ),
      ],
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
      final startDate = DateFormat('dd/MM/yyyy').format(values[0]!);

      valueText = startDate;
    } else {
      return 'null';
    }

    return valueText;
  }
}

class _InnerTimeline extends StatelessWidget {
  const _InnerTimeline({
    required this.messages,
  });

  final List<Widget> messages;

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == messages.length + 1;
    }

    return FixedTimeline.tileBuilder(
      theme: TimelineTheme.of(context).copyWith(
        nodePosition: 0,
        connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
              thickness: 1.0,
            ),
        indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
              size: 10.0,
              position: 0.5,
            ),
      ),
      builder: TimelineTileBuilder(
        indicatorBuilder: (_, index) =>
            !isEdgeIndex(index) ? Indicator.widget() : null,
        contentsBuilder: (_, index) {
          if (isEdgeIndex(index)) {
            return null;
          }

          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
                width: index == 2 ? 400 : 120,
                height: 160,
                child: messages[index - 1]),
          );
        },
        itemExtentBuilder: (_, index) => index == 2 ? 160.0 : 16.0,
        itemCount: messages.length + 2,
      ),
    );
  }
}
