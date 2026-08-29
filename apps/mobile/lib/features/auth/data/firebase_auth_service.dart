import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shilpsetu/features/auth/domain/models/artisan_user.dart';

/// Firebase Authentication & Cloud Firestore Service for Shilpsetu.
///
/// Handles:
/// - Storing artisan Name & Phone Number in Cloud Firestore collection ('artisans')
/// - Looking up existing artisan records on login
/// - Synchronizing profile updates to Firebase Cloud
/// - Signing out from Firebase Auth
class FirebaseAuthService {
  FirebaseAuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  bool get _isFirebaseReady => Firebase.apps.isNotEmpty;

  FirebaseFirestore? get firestore {
    if (_firestore != null) return _firestore;
    if (_isFirebaseReady) {
      try {
        return FirebaseFirestore.instance;
      } catch (e) {
        debugPrint('⚠️ Firestore get error: $e');
        return null;
      }
    }
    return null;
  }

  FirebaseAuth? get auth {
    if (_auth != null) return _auth;
    if (_isFirebaseReady) {
      try {
        return FirebaseAuth.instance;
      } catch (e) {
        debugPrint('⚠️ FirebaseAuth get error: $e');
        return null;
      }
    }
    return null;
  }

  /// Registers a new artisan in Cloud Firestore ('artisans' collection).
  Future<ArtisanUser> register({
    required String name,
    required String phoneNumber,
    String? craftType,
    String? location,
  }) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');
    final docId = 'artisan_$cleanPhone';

    final user = ArtisanUser(
      id: docId,
      name: name.trim(),
      phoneNumber: cleanPhone,
      craftType: craftType ?? 'हस्तशिल्प',
      location: location ?? 'भारत',
    );

    // Save to Cloud Firestore
    try {
      final db = firestore;
      if (db != null) {
        debugPrint('🔥 Writing artisan to Firestore: docId=$cleanPhone, name=${user.name}');
        await db.collection('artisans').doc(cleanPhone).set(
          {
            'id': user.id,
            'name': user.name,
            'phoneNumber': user.phoneNumber,
            'craftType': user.craftType,
            'location': user.location,
            'createdAt': FieldValue.serverTimestamp(),
            'lastLogin': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
        debugPrint('✅ SUCCESS: Artisan saved in Firestore /artisans/$cleanPhone');
      } else {
        debugPrint('⚠️ Firestore instance is null. Make sure Firebase is initialized.');
      }
    } catch (e) {
      debugPrint('❌ Firestore write error: $e');
    }

    return user;
  }

  /// Logs in an existing artisan by fetching their details from Cloud Firestore.
  Future<ArtisanUser> login({
    required String phoneNumber,
    String? existingName,
  }) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');
    final docId = 'artisan_$cleanPhone';

    var retrievedName = existingName ?? '';
    var craftType = 'हस्तशिल्प';
    var location = 'भारत';

    // Retrieve artisan profile from Cloud Firestore
    try {
      final db = firestore;
      if (db != null) {
        debugPrint('🔥 Fetching artisan from Firestore: /artisans/$cleanPhone');
        final doc = await db.collection('artisans').doc(cleanPhone).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          if (data['name'] is String && (data['name'] as String).isNotEmpty) {
            retrievedName = data['name'] as String;
          }
          if (data['craftType'] is String) {
            craftType = data['craftType'] as String;
          }
          if (data['location'] is String) {
            location = data['location'] as String;
          }

          debugPrint('✅ Found artisan in Firestore: name=$retrievedName');

          // Update last login timestamp
          await db.collection('artisans').doc(cleanPhone).update({
            'lastLogin': FieldValue.serverTimestamp(),
          });
        } else {
          debugPrint('ℹ️ Artisan not in Firestore yet. Creating initial record...');
          await db.collection('artisans').doc(cleanPhone).set(
            {
              'id': docId,
              'name': retrievedName.isNotEmpty ? retrievedName : 'कारीगर',
              'phoneNumber': cleanPhone,
              'craftType': craftType,
              'location': location,
              'createdAt': FieldValue.serverTimestamp(),
              'lastLogin': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );
          debugPrint('✅ Created initial artisan in Firestore /artisans/$cleanPhone');
        }
      }
    } catch (e) {
      debugPrint('❌ Firestore login error: $e');
    }

    return ArtisanUser(
      id: docId,
      name: retrievedName.isNotEmpty ? retrievedName : 'कारीगर',
      phoneNumber: cleanPhone,
      craftType: craftType,
      location: location,
    );
  }

  /// Updates artisan profile details in Cloud Firestore.
  Future<void> updateProfile(ArtisanUser user) async {
    try {
      final db = firestore;
      if (db != null) {
        await db.collection('artisans').doc(user.phoneNumber).set(
          {
            'id': user.id,
            'name': user.name,
            'phoneNumber': user.phoneNumber,
            'craftType': user.craftType,
            'location': user.location,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
        debugPrint('✅ Updated profile in Firestore /artisans/${user.phoneNumber}');
      }
    } catch (e) {
      debugPrint('❌ Firestore updateProfile error: $e');
    }
  }

  /// Signs out from Firebase.
  Future<void> logout() async {
    try {
      await auth?.signOut();
      debugPrint('✅ Firebase auth signed out');
    } catch (e) {
      debugPrint('❌ Firebase auth signout error: $e');
    }
  }
}

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});
