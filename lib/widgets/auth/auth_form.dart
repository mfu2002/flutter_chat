import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String username,
    String password,
    File? image,
    bool isLogin,
    BuildContext context,
  ) onSubmit;
  final isLoading;

  const AuthForm({Key? key, required this.onSubmit, this.isLoading})
      : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userUsername = '';
  var _userPassword = '';
  File? _userImage;

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (!_isLogin && _userImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image.'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      widget.onSubmit(_userEmail.trim(), _userUsername.trim(),
          _userPassword.trim(), _userImage, _isLogin, context);
    }
  }

  void _pickedImage(File image) => _userImage = image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) UserImagePicker(imagePickFn: _pickedImage),
                TextFormField(
                  key: const ValueKey('email'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@'))
                      return 'Please enter a valid email address.';
                    return null;
                  },
                  onSaved: (value) => _userEmail = value!,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email Address'),
                ),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('username'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 4) {
                        return 'Username must be at least four characters long';
                      }
                      return null;
                    },
                    onSaved: (value) => _userUsername = value!,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 7)
                      return 'Password must be at least seven characters long';
                    return null;
                  },
                  onSaved: (value) => _userPassword = value!,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 12,
                ),
                widget.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? 'Login' : 'Signup')),
                if (!widget.isLoading)
                  TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
