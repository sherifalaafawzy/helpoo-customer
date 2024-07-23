part of 'corporate_client_cubit.dart';

enum CorporateClientStatus { auth, unAuth, loading }

@immutable
class CorporateClientState {
  final CorporateClientStatus status;
  final String? error;
  final String? phoneNumber;
  final String? userName;

  CorporateClientState({
    this.status = CorporateClientStatus.loading,
    this.error,
    this.phoneNumber,
    this.userName,
  });

  CorporateClientState copyWith({
    CorporateClientStatus? status,
    String? error,
    String? phoneNumber,
    String? userName,
  }) {
    return CorporateClientState(
      status: status ?? this.status,
      error: error ?? this.error,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userName: userName ?? this.userName,
    );
  }
}
