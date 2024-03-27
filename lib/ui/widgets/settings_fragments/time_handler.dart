import 'package:animestream/services/internal_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TimeHandler extends StatefulWidget {
  const TimeHandler({super.key});

  @override
  State<TimeHandler> createState() => _TimeHandlerState();
}

class _TimeHandlerState extends State<TimeHandler> {
  TextEditingController waitController = TextEditingController();
  InternalAPI internalAPI = Get.find<InternalAPI>();

  @override
  void initState() {
    waitController.text = internalAPI.getWaitTime().toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              17,
              0,
              12,
              0,
            ),
            child: TextField(
              controller: waitController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: "Tempo di caricamento (s)",
                hintText: "Tempo che dai per caricare",
                // border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        // Spacer(),
        Padding(
          padding: const EdgeInsets.only(
            right: 17,
          ),
          child: ElevatedButton(
            onPressed: () {
              internalAPI.setWaitTime(
                int.tryParse(waitController.text) ?? 0,
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: const Text("Salva"),
          ),
        ),
      ],
    );
  }
}
