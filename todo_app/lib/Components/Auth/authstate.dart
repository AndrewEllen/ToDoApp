import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants.dart';

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  late var username;
  final currentUser = supabase.auth.user();


  @override
  void onUnauthenticated() {
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Future<void> onAuthenticated(Session session) async {
    final currentUser = supabase.auth.user();
    await _getProfile(currentUser!.id);

    if (username.length > 0) {
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/home', (route) => false);
      }
    }
    else {
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/signup', (route) => false);
      }
    }
  }

  Future<void> _getProfile(String userId) async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    if (response.error != null && response.status != 406) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!.message)));
    }
    if (response.data?['username'] != null) {
      username = response.data?['username'] as String;
    }
    else {
      username = "";
    }
  }

  @override
  void onPasswordRecovery(Session session) {}

  @override
  void onErrorAuthenticating(String message) {
    print('Error authenticating $message');
  }
}