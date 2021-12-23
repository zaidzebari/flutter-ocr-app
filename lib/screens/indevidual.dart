import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_recognition/provider.dart/text_recognition_provider.dart';
import 'package:text_recognition/screens/category.dart';

class IndividualScreen extends StatefulWidget {
  const IndividualScreen({Key? key, this.id, this.name}) : super(key: key);
  final int? id;
  final String? name;

  @override
  _IndividualScreenState createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen> {
  @override
  void initState() {
    Provider.of<TextRecognitionState>(context, listen: false)
        .getSubCategory(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name!),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<TextRecognitionState>(context, listen: false)
                  .export();
            },
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SubCategoryScreen(
                    menuId: widget.id,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Consumer<TextRecognitionState>(builder: (context, value, child) {
          return FittedBox(
            child: DataTable(
              showCheckboxColumn: false,
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'PIN',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'SERIAL',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Price',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Created On',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: <DataRow>[
                for (int i = 0; i < value.subCategoryModel.length; i++) ...{
                  DataRow(
                    onSelectChanged: (va) {
                      deleteSubCategory(context, value.subCategoryModel[i].id,
                          value.subCategoryModel[i].pin);
                    },
                    cells: <DataCell>[
                      DataCell(Text(value.subCategoryModel[i].pin.toString())),
                      DataCell(
                          Text(value.subCategoryModel[i].serial.toString())),
                      DataCell(
                          Text(value.subCategoryModel[i].price.toString())),
                      DataCell(
                          Text(value.subCategoryModel[i].createdOn.toString())),
                    ],
                  ),
                },
                // const DataRow(
                //   cells: <DataCell>[
                //     DataCell(Text('Sarah')),
                //     DataCell(Text('19')),
                //     DataCell(Text('Student')),
                //     DataCell(Text('Student')),
                //   ],
                // ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<void> deleteSubCategory(BuildContext context, int? id, String? name) {
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
                          Provider.of<TextRecognitionState>(context,
                                  listen: false)
                              .deleteSubCategory(id);
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
