import 'package:diario_viagens_front/components/form_field.dart';
import 'package:diario_viagens_front/pages/cadastro/cadastro_page.dart';
import 'package:diario_viagens_front/pages/viagem/add_viagem_page.dart';
import 'package:diario_viagens_front/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              suffixIcon: Icon(
                Icons.search,
                size: 35,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
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
                              child: Image.network(
                                'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8fA%3D%3D&w=1000&q=80',
                                width: 170,
                                height: double
                                    .infinity, // Defina a largura desejada aqui
                                fit: BoxFit
                                    .cover, // Ajusta a imagem ao tamanho do ClipRRect
                              ),
                            ),
                            const Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_city_rounded,
                                              size: 30,
                                            ),
                                            Text('Londres',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18)),
                                          ],
                                        ),
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 0, left: 10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 25,
                                          color: Color.fromARGB(
                                              255, 145, 145, 145),
                                        ),
                                        Text('Inglaterra',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 145, 145, 145),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8, left: 10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          size: 25,
                                          color: Color.fromARGB(
                                              255, 145, 145, 145),
                                        ),
                                        Text('29/02/2023',
                                            style: TextStyle(
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
}
