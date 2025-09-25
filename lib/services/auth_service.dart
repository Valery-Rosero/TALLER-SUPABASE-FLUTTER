import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<User?> get currentUser async {
    return _client.auth.currentUser;
  }

  Future<bool> isLoggedIn() async {
    final user = await currentUser;
    return user != null;
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Stream<AuthState> get authStateChanges {
    return _client.auth.onAuthStateChange;
  }
}