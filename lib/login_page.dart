import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final formKey = new GlobalKey<FormState>();

class LoginPage extends StatefulWidget{
        
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum  FormType{
  login,
  register
}
  class _LoginPageState extends State<LoginPage>{

    String _email;
    String _password;
    FormType  _formType = FormType.login; //initally set to login,user taps register modify form type
    bool validateAndSave(){
         final form = formKey.currentState;
         if(form.validate()){
           form.save();
           print('Form is Valid. Email: $_email,Password: $_password');
         }
         else{
           print('Form is invalid. Email: $_email,Password: $_password');
         }
         return false;
    }
    void validateandSubmit() async {
      if (validateAndSave()){
         try{
           if(_formType == FormType.login){
            AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);

            FirebaseUser user = result.user;    
            print('Signed in ${user.uid}');
           }
           else{
            AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
            FirebaseUser user = result.user;    

              print('Registered  User: ${user.uid}');

           }   
         }
         catch(e){
           print('Error');
         }      
      }
    }
    void moveToRegister(){
      formKey.currentState.reset();
      setState(() {
        _formType  = FormType.register; //ui reload register
      });
      
    }

    void moveToLogin(){
      formKey.currentState.reset();

      setState(() {
      _formType = FormType.login; 
      });
    }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter Login Demo'),
        ),
        body: new Container(
          padding: EdgeInsets.all(20.0),
          child:  new Form(   
            key: formKey, 
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs() + buildSubmitButtons(),// refactoring code for functionality of buttons 
                                                              //whether it's login or register enum has two cases for the same see above enum.      
            ),
          )
          ),
    );
  }
  List<Widget> buildInputs(){
return [
  new TextFormField(
    decoration: new InputDecoration(labelText: 'Email'),
    validator: (value) => value.isEmpty ? 'Email can\'t be empty': null,
    onSaved: (value)=> _email = value,
    ),
  new TextFormField(
    decoration: new InputDecoration(labelText:'Password'),
    obscureText: true,
    validator: (value) => value.isEmpty ? 'Password can\'t be empty': null,
    onSaved: (value)=> _password = value,
      ),
    ]; 
}
  List<Widget>  buildSubmitButtons(){
    if (_formType == FormType.login){
  return[
  new RaisedButton(
      child: new Text('Login',style: new TextStyle(fontSize: 20.0)),
      onPressed: validateandSubmit, 
      ),
  new FlatButton(
        child: new Text('Create an account',style: new TextStyle(fontSize: 20.0,color: Colors.grey)),
      onPressed: moveToRegister,
      ),
       ];
    }
    else{
    return[
      new RaisedButton(
      child: new Text('Create an account',style: new TextStyle(fontSize: 20.0)),
      onPressed: validateandSubmit, 
        ),
  new FlatButton(
        child: new Text('Have an account? Login',style: new TextStyle(fontSize: 20.0,color: Colors.grey)),
      onPressed: moveToLogin,
        )
      ];
    }
  }

}


