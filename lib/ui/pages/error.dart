import 'package:baka_animestream/settings/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "(◎-◎；)?",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 40,
              ),
            ),
            Text(
              "Questa pagina non esiste!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            OutlinedButton.icon(
              onPressed: () => Get.offAndToNamed(
                RouteGenerator.mainPage,
              ),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Torna indietro"),
            ),
          ],
        ),
      ),
    );
  }
}
