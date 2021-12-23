import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_recognition/provider.dart/menu_provider.dart';

import 'indevidual.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    Provider.of<MenuProvider>(context, listen: false).getMenu();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String name = "";

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Menu"),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            Positioned(
                              right: -40.0,
                              top: -40.0,
                              child: InkResponse(
                                onTap: () {
                                  name = "";
                                  Navigator.of(context).pop();
                                },
                                child: const CircleAvatar(
                                  child: Icon(Icons.close),
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TextFormField(
                                      onChanged: (data) {
                                        name = data;
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Name',
                                        hintText: 'Enter Name',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ElevatedButton(
                                      child: const Text(
                                        "Save",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        if (name != "" || name.isNotEmpty) {
                                          await Provider.of<MenuProvider>(
                                                  context,
                                                  listen: false)
                                              .add(name);

                                          // await Provider.of<MenuProvider>(
                                          //         context,
                                          //         listen: false)
                                          //     .getMenu();
                                        }
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child:

              // Consumer<MenuProvider>(builder: (context, value, child) {
              //   return FittedBox(
              //     child: DataTable(
              //       columnSpacing: MediaQuery.of(context).size.width / 2,
              //       showCheckboxColumn: false,
              //       columns: const <DataColumn>[
              //         DataColumn(
              //           label: Text(
              //             'Name',
              //             style: TextStyle(fontStyle: FontStyle.italic),
              //           ),
              //         ),
              //         DataColumn(
              //           label: Text(
              //             'Created At',
              //             style: TextStyle(fontStyle: FontStyle.italic),
              //           ),
              //         ),
              //       ],
              //       rows: [
              //         for (int i = 0; i < value.menuModel.length; i++) ...{
              //           DataRow(
              //             onSelectChanged: (v) {
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => IndividualScreen(
              //                             id: value.menuModel[i].id,
              //                             name: value.menuModel[i].name,
              //                           )));
              //             },
              //             cells: <DataCell>[
              //               DataCell(
              //                 GestureDetector(
              //                   onLongPress: () {
              //                     print('delete it');
              //                   },
              //                   child: Text(
              //                     value.menuModel[i].name.toString(),
              //                   ),
              //                 ),
              //               ),
              //               DataCell(Text(value.menuModel[i].createdAt.toString())),
              //             ],
              //           ),
              //         },
              //         // const DataRow(
              //         //   cells: <DataCell>[
              //         //     DataCell(Text('Sarah')),
              //         //     DataCell(Text('19')),
              //         //     DataCell(Text('Student')),
              //         //     DataCell(Text('Student')),
              //         //   ],
              //         // ),
              //       ],
              //     ),
              //   );
              // }),

              Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Expanded(
                      child: Text(
                        'Name',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Created At',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<MenuProvider>(
                builder: (context, value, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.menuModel.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onLongPress: () {
                        buttomshet(context, value.menuModel[index].id,
                            value.menuModel[index].name);
                      },
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IndividualScreen(
                                      id: value.menuModel[index].id,
                                      name: value.menuModel[index].name,
                                    )));
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                            //                   <--- right side
                            color: Colors.black,
                            width: 1.0,
                          ),
                        )),
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                value.menuModel[index].name.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                value.menuModel[index].createdAt.toString(),
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> buttomshet(BuildContext context, int? id, String? name) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          margin: const EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
          color: Colors.white12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Delete $name',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          border: Border.all(color: Colors.red)),
                      child: TextButton(
                        onPressed: () {
                          print('delete id $id');
                          Provider.of<MenuProvider>(context, listen: false)
                              .deleteMenu(id);
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          border: Border.all(color: Colors.green)),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
