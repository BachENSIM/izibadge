import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/dashboard_screen.dart';

class EditListUserForm extends StatefulWidget {
  //const EditListUserForm({Key? key}) : super(key: key);
  late final String documentId;
  EditListUserForm({
    required this.documentId,
  });
  @override
  _EditListUserFormState createState() => _EditListUserFormState();
}

class _EditListUserFormState extends State<EditListUserForm> {
  // The inital group value
  static final GlobalKey<FormState> _lstUserFormKey = GlobalKey();

  final TextEditingController _guestCtl = TextEditingController();
  TextEditingController? _editGuestCtl;
  //dropDown pour le group
  String? _dropdownGroup = DatabaseTest.lstGroupAdded[0];

  //dropDown pour le role
  static final List<String> _roleDropDown = ["Invité", "Scanneur"];
  String? _dropdownRole = _roleDropDown[0];

  late int taille = 1;
  //pour éviter appuyer plusieurs fois
  bool _isProcessing = false;

  //final TextEditingController _guestEditCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Form(
          key: _lstUserFormKey,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //ajouter d'une liste d'invitation (1 QRCode pour toute la durée)
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            TextFormField(
                              maxLines: 1,
                              keyboardType: TextInputType.emailAddress,
                              controller: _guestCtl,
                              validator: (value) => value!.isEmpty
                                  ? 'Email cannot be blank'
                                  : null,
                              decoration: const InputDecoration(
                                hintText: 'Ex: tom@gmail.com',
                                contentPadding: EdgeInsets.all(8),
                                isDense: true,
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //Pour le groupe
                                  Container(
                                    height: 50,
                                    //width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.all(5),
                                    child: DropdownButtonHideUnderline(
                                      child: GFDropdown(
                                        padding: const EdgeInsets.all(10),
                                        borderRadius: BorderRadius.circular(5),
                                       /* border: const BorderSide(
                                            color: CustomColors.textPrimary,
                                            width: 1),
                                        dropdownButtonColor:
                                            CustomColors.textSecondary,*/
                                        value: _dropdownGroup,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _dropdownGroup =
                                                newValue as String?;
                                          });
                                        },
                                        items: DatabaseTest.lstGroupAdded
                                            .map((value) => DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  //Pour le role
                                  Container(
                                    height: 50,
                                    //width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.all(5),
                                    child: DropdownButtonHideUnderline(
                                      child: GFDropdown(
                                        padding: const EdgeInsets.all(15),
                                        borderRadius: BorderRadius.circular(5),
                                       /* border: const BorderSide(
                                            color: CustomColors.textPrimary,
                                            width: 1),
                                        dropdownButtonColor:
                                            CustomColors.textSecondary,*/
                                        value: _dropdownRole,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _dropdownRole = newValue as String?;
                                            print(_dropdownRole);
                                          });
                                        },
                                        items: _roleDropDown
                                            .map((value) => DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    String mess = _guestCtl.text;
                                    if (_guestCtl.text.isEmpty) {
                                      mess = "example${taille++}@gmail.com";
                                    }
                                    DatabaseTest.lstUserAdded.add(mess);
                                    DatabaseTest.lstGroupAdded
                                        .add(_dropdownGroup!);
                                    DatabaseTest.lstRoleAdded
                                        .add(_dropdownRole!);
                                    _guestCtl.clear();
                                  });
                                },
                                child: Wrap(
                                  children: const <Widget>[Text('AJOUTER')],
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            //afficher la liste d'invitation afin de consulter avant de sauvegarder dans la BDD
                            ListView(shrinkWrap: true, children: <Widget>[
                              const SizedBox(height: 15),
                              Container(
                                height: 300.0,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: DatabaseTest.lstUserAdded.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        child: Column(children: <Widget>[
                                      GFListTile(
                                          onTap: () {
                                            setState(() {
                                              _editGuestCtl =
                                                  TextEditingController(
                                                      text: DatabaseTest
                                                          .lstUserAdded[index]);
                                              _modify(context, index);
                                            });
                                          },
                                          /*color: CustomColors.accentDark,*/
                                          titleText: "Email: " +
                                              DatabaseTest.lstUserAdded[index],
                                          subTitleText: "Groupe: " +
                                              DatabaseTest
                                                  .lstGroupAdded[index] +
                                              " - Role: " +
                                              DatabaseTest.lstRoleAdded[index],
                                          icon: IconButton(
                                            icon: Icon(Icons.cancel_outlined),
                                            onPressed: () {
                                              setState(() {
                                                DatabaseTest.lstUserAdded
                                                    .removeAt(index);
                                                DatabaseTest.lstGroupAdded
                                                    .removeAt(index);
                                                DatabaseTest.lstRoleAdded
                                                    .removeAt(index);
                                              });
                                            },
                                            /*color: CustomColors.textPrimary,*/
                                          )),
                                    ]));
                                  },
                                ),
                              )
                            ]),
                            const SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      )
                    ],
                  ))),
              _isProcessing
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          /*valueColor: AlwaysStoppedAnimation<Color>(
                            CustomColors.accentLight,
                          ),*/
                        ),
                      ),
                    )
                  : Container(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        style: ButtonStyle(
                         /* backgroundColor: MaterialStateProperty.all(
                            CustomColors.accentDark,
                          ),*/
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            _isProcessing = true;
                          });
                          /*await DatabaseTest.addItem(
                              title: DatabaseTest.nameSave.toString(),
                              description: DatabaseTest.descSave.toString(),
                              address: DatabaseTest.addrSave.toString(),
                              start: DateTime.parse(DateTime.now().toString()),
                              end: DateTime.parse(DateTime.now().toString()),
                              role: "Organisateur",
                            );
                            await DatabaseTest.addInviteList(
                                listEmail: _groupListUser,
                                listGroup: _groupDropdownGroup,
                                listRole: _groupDropdownRole
                            );*/

                          setState(() {
                            _isProcessing = false;
                          });
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DashboardScreen(),
                            ),
                          );
                        },
                        child: const Padding(
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 16.0),
                          child: Text(
                            'VALIDER',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                             /* color: CustomColors.textSecondary,*/
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    )
            ],
          ))),
    );
  }

  void _modify(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            /*title: const Text('Please Confirm'),*/
            content: const Text('Editez vos informations?'),
            shape: RoundedRectangleBorder(
                // side: BorderSide(color: CustomColors.textPrimary, width: 1),
                borderRadius: BorderRadius.circular(15)),
            actions: [
              Column(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 250,
                    child: TextFormField(
                      enabled: false,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      controller: _editGuestCtl,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        isDense: true,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Pour le groupe
                      Container(
                        height: 50,
                        //width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(5),
                        child: DropdownButtonHideUnderline(
                          child: GFDropdown(
                            padding: const EdgeInsets.all(15),
                            borderRadius: BorderRadius.circular(5),
                            /*border: const BorderSide(
                                color: CustomColors.textPrimary, width: 1),
                            dropdownButtonColor: CustomColors.textSecondary,*/
                            value: _dropdownGroup,
                            onChanged: (newValue) {
                              setState(() {
                                _dropdownGroup = newValue as String?;
                              });
                            },
                            items: DatabaseTest.lstGroupAdded
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      //Pour le role
                      Container(
                        height: 50,
                        //width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(5),
                        child: DropdownButtonHideUnderline(
                          child: GFDropdown(
                            padding: const EdgeInsets.all(15),
                            borderRadius: BorderRadius.circular(5),
                          /* border:
                           BorderSide(
                                color: CustomColors.textPrimary, width: 1),
                            dropdownButtonColor: CustomColors.textSecondary,*/
                            value: _dropdownRole,
                            onChanged: (newValue) {
                              setState(() {
                                _dropdownRole = newValue as String?;
                                print(_dropdownRole);
                              });
                            },
                            items: _roleDropDown
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            // Remove the box
                            setState(() {
                              DatabaseTest.lstUserAdded[index] =
                                  _editGuestCtl!.text;
                              DatabaseTest.lstGroupAdded[index] =
                                  _dropdownGroup!;
                              DatabaseTest.lstRoleAdded[index] = _dropdownRole!;
                            });

                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('Modifiez')),
                      TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('Annulez'))
                    ],
                  ),
                ],
              )
              // The "Yes" button
            ],
          );
        });
  }
}