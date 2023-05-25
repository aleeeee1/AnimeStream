import 'package:flutter/material.dart';

import '../../helper/models/anime_model.dart';
import '../../services/internal_db.dart';
import 'anime_card.dart';
import '../../helper/classes/anime_obj.dart';
import 'package:get/get.dart';

class AnimeRow extends StatefulWidget {
  final Function function;
  final String name;
  final int type;
  const AnimeRow({
    super.key,
    required this.function,
    required this.name,
    required this.type,
  });

  @override
  State<AnimeRow> createState() => _AnimeRowState();
}

class _AnimeRowState extends State<AnimeRow> {
  late Function convert;
  late String name;

  @override
  void initState() {
    name = widget.name;
    switch (widget.type) {
      case 0:
        convert = latestToObj;
        break;
      case 1:
        convert = popularToObj;
        break;
      case 2:
        convert = searchToObj;
        break;
      case 3:
        convert = modelToObj;
        break;
    }

    super.initState();
  }

  Widget coolWidget({required child, required AnimeClass data}) {
    if (widget.type == 3) {
      return GestureDetector(
        onLongPress: () => Get.defaultDialog(
          title: "Rimuovi",
          middleText: "Vuoi rimuovere questo anime?",
          textConfirm: "Rimuovi",
          textCancel: "Annulla",
          onConfirm: () {
            Get.back();

            Get.find<ObjectBox>().store.box<AnimeModel>().remove(data.id);
            setState(() {
              widget.function();
            });
          },
        ),
        child: child,
      );
    } else {
      return SizedBox(
        child: child,
      );
    }
  }

  Future<List> getData() async {
    return await widget.function();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto",
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 250,
          child: FutureBuilder(
            future: getData(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data as List;
                return data.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "¯\\_(ツ)_/¯",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 40,
                              ),
                            ),
                            Text(
                              "Non hai ancora guardato niente",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 23,
                              ),
                            ),
                            Text(
                              "(o se hai guardato qualcosa, ricarica la pagina)",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                      )
                    : RawScrollbar(
                        thumbColor: Theme.of(context).colorScheme.secondary,
                        radius: const Radius.circular(360),
                        thickness: 3,
                        child: ListView.builder(
                          shrinkWrap: true,
                          addAutomaticKeepAlives: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return coolWidget(
                              child: AnimeCard(
                                anime: convert(data[index]),
                              ),
                              data: convert(data[index]),
                            );
                          },
                        ),
                      );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        "Qualcosa è andato storto :(",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 23,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.refresh),
                        label: const Text("Riprova"),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          ),
        ),
      ],
    );
  }
}
