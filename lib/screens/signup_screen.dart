import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
        ),
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.isLoading)
            return Center(child: CircularProgressIndicator());
          return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: "Nome Completo"),
                    validator: (text) {
                      if (text.isEmpty) return "Nome Inválido";
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "E-Mail"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text.isEmpty || !text.contains('@'))
                        return "E-Mail Inválido";
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                      controller: _passController,
                      decoration: InputDecoration(hintText: "Senha"),
                      obscureText: true,
                      validator: (text) {
                        if (text.isEmpty || text.length < 6)
                          return "Senha Inválida";
                      }),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(hintText: "Endereço"),
                      validator: (text) {
                        if (text.isEmpty) return "Endereço Inválido";
                      }),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                      height: 50.0,
                      child: RaisedButton(
                        child: Text("Criar Conta",
                            style: TextStyle(fontSize: 18.0)),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Map<String, dynamic> userData = {
                              "name": _nameController.text,
                              "email": _emailController.text,
                              "address": _addressController.text
                            };
                            model.signUp(
                                userData: userData,
                                pass: _passController.text,
                                onSuccess: onSuccess,
                                onFailed: onFailed);
                          }
                        },
                      ))
                ],
              ));
        }));
  }

  void onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Usuário criado com sucesso"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2)));

    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void onFailed() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Falha ao criar o usuário"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2)));

    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }
}
