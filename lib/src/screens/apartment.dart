import 'package:d2shop_admin/src/components/confirm_dialog.dart';
import 'package:d2shop_admin/src/models/apartment_model.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:d2shop_admin/src/widgets/custom_button.dart';
import 'package:d2shop_admin/src/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Apartment extends StatefulWidget {
  @override
  _ApartmentState createState() => _ApartmentState();
}

class _ApartmentState extends State<Apartment> {
  final TextEditingController _tec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: _tec,
                  decoration: Utils.inputDecoration(
                    "Enter Apartment",
                    icon: FaIcon(FontAwesomeIcons.city),
                  ),
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton(
                      onTap: () {
                        if (_tec.text.isNotEmpty) {
                          FirestoreServices()
                              .addNewApartment(
                                  ApartmentModel(value: _tec.text.trim()))
                              .then((value) {
                            Utils.showMessage(
                                "${_tec.text} has been added to the list.");
                            setState(() {
                              _tec.text = '';
                            });
                          });
                        } else {
                          Utils.showMessage("Please type something.");
                          return;
                        }
                      },
                      text: 'Add Apartment'),
                )
              ],
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: StreamProvider<List<ApartmentModel>>.value(
              value: FirestoreServices().getApartments,
              builder: (context, child) {
                List<ApartmentModel> dataList =
                    Provider.of<List<ApartmentModel>>(context);

                if (dataList == null) return Utils.loading();
                if (dataList.length == 0) return Utils.noDataWidget(context);
                return ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) => CustomCard(
                    title: dataList[index].value,
                    trailing: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.times,
                        color: Colors.red,
                      ),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          title:
                              "Are you sure to delete ${dataList[index].value} from the list?",
                          confirmBtnCallback: () => FirestoreServices()
                              .deleteApartment(
                            dataList[index],
                          )
                              .then(
                            (value) {
                              Utils.showMessage(
                                  "${dataList[index].value} has been removed successfully.");
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
