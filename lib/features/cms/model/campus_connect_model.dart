class CampusConnectModel {
  final bool status;
  final List<CampusContact> data;

  CampusConnectModel({required this.status, required this.data});

  factory CampusConnectModel.fromJson(Map<String, dynamic> json) {
    return CampusConnectModel(
      status: json['status'] ?? false,
      data:
          (json['data'] as List).map((e) => CampusContact.fromJson(e)).toList(),
    );
  }
}

class CampusContact {
  final String title;
  final String contactType;
  final String phoneNumber;
  final String emailId;
  final String servicesHandled;
  final String workingHoursStart;
  final String workingHoursEnd;
  final String workingDays;
  final int sortWeight;

  CampusContact({
    required this.title,
    required this.contactType,
    required this.phoneNumber,
    required this.emailId,
    required this.servicesHandled,
    required this.workingHoursStart,
    required this.workingHoursEnd,
    required this.workingDays,
    required this.sortWeight,
  });

  factory CampusContact.fromJson(Map<String, dynamic> json) {
    return CampusContact(
      title: json['title'] ?? '',
      contactType: json['contact_type'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      emailId: json['email_id'] ?? '',
      servicesHandled: json['services_handled'] ?? '',
      workingHoursStart: json['working_hours_start'] ?? '',
      workingHoursEnd: json['working_hours_end'] ?? '',
      workingDays: json['working_days'] ?? '',
      sortWeight: int.tryParse(
            json['sort_weight']?.toString() ?? "0",
          ) ??
          0,
    );
  }
}
