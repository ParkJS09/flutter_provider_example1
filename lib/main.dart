import 'dart:async';

import 'package:flutter/material.dart';


final authRepository = AuthRepository();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RootPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인 페이지'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('로그인'),
          onPressed: (){
            authRepository.setAuthStatus(AuthState.Authenticated);
          },
        ),
      )
    );
  }
}


class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메인 페이지'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('로그아웃'),
          onPressed: (){
            authRepository.setAuthStatus(AuthState.UnAuthenticated);
          },
        ),
      )
    );
  }
}

//로그인 여부를 파악 후 로그인 페이지로 이동할 지 메인 페이지로 이동할 지 정해주는 페이지
class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: authRepository.authStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.data == AuthState.UnAuthenticated){
          return LoginPage();
        }else{
          return MainPage();
        }
      },
    );
  }
}

enum AuthState {
  Authenticated, UnAuthenticated
}

class AuthRepository {
  AuthState auth = AuthState.UnAuthenticated;
  final _streamController = StreamController<AuthState>()..add(AuthState.UnAuthenticated);
  get authStream => _streamController.stream;
  setAuthStatus(AuthState state){
    _streamController.add(state); 
  }
}