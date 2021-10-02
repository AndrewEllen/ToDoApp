import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants.dart';

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  late var userIDcheck;
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
    await _checkProfile(currentUser!.id);

    if (userIDcheck.length > 0) {
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/home', (route) => false);
      }
    }
    else {
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/consent', (route) => false);
      }
    }
  }

  Future<void> _checkProfile(String userId) async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('userid', userId)
        .single()
        .execute();
    if (response.error != null && response.status != 406) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!.message)));
    }
    if (response.data?['userid'] != null) {
      userIDcheck = response.data?['userid'] as String;
    }
    else {
      userIDcheck = "";
    }
  }

  @override
  void onPasswordRecovery(Session session) {}

  @override
  void onErrorAuthenticating(String message) {
    print('Error authenticating $message');
  }
}