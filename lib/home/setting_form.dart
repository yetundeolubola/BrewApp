import 'package:brew_app/constant/loading.dart';
import 'package:brew_app/models/user.dart';
import 'package:brew_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:brew_app/constant/constant.dart';
import 'package:provider/provider.dart';

class SettingForm extends StatefulWidget {
  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  //form value
  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: Database(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(children: <Widget>[
                Text(
                  'Update your brew Setting',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  initialValue: userData.name,
                  decoration: textInputDecorator,
                  validator: (val) =>
                      val.isEmpty ? "Please enter your name" : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(
                  height: 20.0,
                ),
                //Dropdown
                DropdownButtonFormField(
                    decoration: textInputDecorator,
                    value: _currentSugars ?? userData.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentSugars = val)),

                //Slider
                Slider(
                  value: (_currentStrength ?? userData.strength).toDouble(),
                  activeColor: Colors.brown[_currentStrength ?? 100],
                  inactiveColor: Colors.brown[_currentStrength ?? 100],
                  min: 100,
                  max: 900,
                  divisions: 8,
                  onChanged: (val) =>
                      setState(() => _currentStrength = val.round()),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                    color: Colors.brown[400],
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      print(_currentSugars);
                      if (_formKey.currentState.validate()) {
                        await Database(uid: user.uid).updataUserData(
                            _currentSugars ?? userData.sugars,
                            _currentName ?? userData.name,
                            _currentStrength ?? userData.strength);
                        Navigator.pop(context);
                      }
                    })
              ]),
            );
          } else {
            return Loading();
          }
        });
  }
}
