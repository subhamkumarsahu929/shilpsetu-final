import 'package:shilpsetu/core/database/app_database.dart';
import 'package:shilpsetu/features/enquiries/domain/models/enquiry_item.dart';
import 'package:shilpsetu/features/enquiries/domain/repository/enquiries_repository.dart';

class EnquiriesRepositoryImpl implements EnquiriesRepository {
  EnquiriesRepositoryImpl({AppDatabase? database}) : _database = database;

  // ignore: unused_field
  final AppDatabase? _database;

  // Real inquiries store (starts empty, populated by incoming live server inquiries)
  final List<EnquiryItem> _inMemoryEnquiries = [];

  @override
  Future<List<EnquiryItem>> fetchEnquiries() async {
    // Return server-authoritative list
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_inMemoryEnquiries);
  }

  @override
  Future<void> markAsRead(String id) async {
    final index = _inMemoryEnquiries.indexWhere((e) => e.id == id);
    if (index != -1) {
      final item = _inMemoryEnquiries[index];
      _inMemoryEnquiries[index] = item.copyWith(status: EnquiryStatus.read);
    }
  }

  @override
  Future<void> acceptEnquiry(String id) async {
    final index = _inMemoryEnquiries.indexWhere((e) => e.id == id);
    if (index != -1) {
      final item = _inMemoryEnquiries[index];
      _inMemoryEnquiries[index] = item.copyWith(status: EnquiryStatus.accepted);
    }
  }
}
