import 'dart:io';
import 'package:histomictk/global.dart' as globals;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:histomictk/models/authentication.dart';
import 'package:http/http.dart';
import 'package:histomictk/service/provider/appdata.dart';

import 'dsa.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  final login_name = TextEditingController();
  final email = TextEditingController();
  final fname = TextEditingController();
  final lname = TextEditingController();
  final pwd1 = TextEditingController();
  final pwd2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void registerDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Sign Up',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              content: SizedBox(
                height: 600,
                width: 600,
                child: ListView(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      color: Colors.greenAccent,
                    ),
                    const Text(
                      'Name',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white),
                    ),
                    TextField(
                      controller: login_name,
                      decoration: InputDecoration(
                        hintText: 'Choose login name',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              width: 3, color: Colors.greenAccent),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Email',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ),
                    TextField(
                      controller: email,
                      decoration: InputDecoration(
                        hintText: 'Enter email address',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              width: 3, color: Colors.greenAccent),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'First name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ),
                    TextField(
                      controller: fname,
                      decoration: InputDecoration(
                        hintText: 'Enter first name',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              width: 3, color: Colors.greenAccent),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Lastname',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ),
                    TextField(
                      controller: lname,
                      decoration: InputDecoration(
                        hintText: 'Enter Last name',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              width: 3, color: Colors.greenAccent),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ),
                    TextField(
                      controller: pwd1,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Choose a password',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              width: 3, color: Colors.greenAccent),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ),
                    TextField(
                      controller: pwd2,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Retype password',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              width: 3, color: Colors.greenAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey),
                  onPressed: () {
                    // var data = {
                    //   "login": login_name.text,
                    //   "email": email.text,
                    //   "firstName": fname.text,
                    //   "lastName": lname.text,
                    //   "password": pwd1.text,
                    // };
                    // var json = jsonEncode(data);
                    // register(json);

                    // final map = <String, dynamic>{};
                    // map['login'] = login_name.text;
                    // map['email'] = email.text;
                    // map['firstName'] = fname.text;
                    // map['lastName'] = lname.text;
                    // map['password'] = pwd1.text;
                    // register(map);


                    register();

                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Digital Slide Archive',
          style: TextStyle(
              color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: Center(
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          shrinkWrap: true,
          children: [
            //Text('Login'),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 300, vertical: 10),
              child: TextField(
                controller: _loginController,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Login or Email',
                  border: OutlineInputBorder(),
                  // hintText: 'Enter login',
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 300, vertical: 20),
              child: TextField(
                controller: _passwordController,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      var basicAuth = basicAuthentication(
                          _loginController.text, _passwordController.text);
                      login(basicAuth);
                    },
                    child: const Text('Login')),
                ElevatedButton(
                    onPressed: () => registerDialog(),
                    child: const Text('Register')),
              ],
            ),
            const Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 50),
              child: Text('2024 \u00a9 Chatchon Meechai'),
            )),
            //Divider(),
          ],
        ),
      ),
    );
  }

  String basicAuthentication(String login, String pwd) {
    var basicAuth =
        'Basic ${base64.encode(utf8.encode('${_loginController.text}:${_passwordController.text}'))}';
    print(basicAuth);
    return basicAuth;
  }

  Future<void> login(String basicAuth) async {
    Response response = await get(
        Uri.parse('https://${globals.ip}/user/authentication'),
        headers: <String, String>{
          'authorization': basicAuth,
          HttpHeaders.contentTypeHeader: 'application/json',
        });
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      print('Corect');
      var auth = Authentication.fromJson(json.decode(response.body));
      print(globals.token);
      globals.token = auth.authToken.token;
      var id = auth.user.id;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const DSA()));
    } else {
      print('Wrong');
    }
  }

  Future<void> register() async {
    print('new user');
    //print(user);
    // var result = await post(Uri.parse('https://${globals.ip}/user'),
    //     body: jsonEncode(user),
    //     headers: {'Content-Type': 'application/json; charset=UTF-8'});
    // print(result.body);
    // print(result.statusCode.toString());
    Map<String, String> headers= <String,String>{
      'accept': 'application/json',
      'Content-Type': 'multipart/form-data'
    };
    Map<String, String> requestBody = <String, String>{
      "login": login_name.text,
      "email": email.text,
      "firstName": fname.text,
      "lastName": lname.text,
      "password": pwd1.text,
    };
    var uri = Uri.parse('https://${globals.ip}/user');
    var request = MultipartRequest('POST', uri)
      ..headers.addAll(headers) //if u have headers, basic auth, token bearer... Else remove line
      ..fields.addAll(requestBody);
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    print(jsonDecode(respStr));
  }



}

// void setUserid(String userid){
//   context.read<AppData>().
// }