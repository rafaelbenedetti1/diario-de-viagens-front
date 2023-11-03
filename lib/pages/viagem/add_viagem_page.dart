import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:diario_viagens_front/components/form_field.dart';
import 'package:diario_viagens_front/components/info_timeline.dart';
import 'package:diario_viagens_front/components/pick_svg.dart';
import 'package:diario_viagens_front/pages/home/mesma.dart';
import 'package:diario_viagens_front/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddViagemPage extends StatefulWidget {
  const AddViagemPage({super.key});

  @override
  State<AddViagemPage> createState() => _AddViagemPageState();
}

String img64 = '';
List<DateTime?> _dialogCalendarPickerValue = [];

class _AddViagemPageState extends State<AddViagemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: ListView(children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () async {
                  img64.isEmpty ? await selecionaImagem() : null;
                },
                child: Container(
                  color: Color.fromARGB(255, 242, 242, 242),
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
                                      child: Icon(
                                        Icons.edit,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                      decoration: new BoxDecoration(
                                        color: Color.fromARGB(116, 0, 0, 0),
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
                                      child: Icon(
                                        Icons.delete,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                      decoration: new BoxDecoration(
                                        color: Color.fromARGB(116, 0, 0, 0),
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
                    color: Color.fromARGB(255, 255, 255, 255),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                label: 'Cidade',
                                suffixIcon: const Icon(
                                  FontAwesomeIcons.building,
                                  size: 20,
                                ),
                              )),
                            ],
                          ),
                          _botaoDataInicioFim(),
                          MinhasVisitas(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]));
  }

  Future<void> selecionaImagem() async {
    String newImg64 = await pickSvg();
    setState(() {
      img64 = newImg64;
    });
    print(img64);
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
      final startDate = DateFormat('dd/MM/yyyy').format(values[0]!);
      final endDate = values.length > 1
          ? DateFormat('dd/MM/yyyy').format(values[1]!)
          : 'null';

      valueText = '$startDate a $endDate';
    } else {
      return 'null';
    }

    return valueText;
  }
}
