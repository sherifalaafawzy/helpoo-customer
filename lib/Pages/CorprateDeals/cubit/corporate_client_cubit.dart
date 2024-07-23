import 'package:bloc/bloc.dart';
import 'package:helpooappclient/Pages/CorprateDeals/corporate_repo.dart';
import 'package:helpooappclient/Pages/splash/splash_repository.dart';
import 'package:meta/meta.dart';

part 'corporate_client_state.dart';

class CorporateClientCubit extends Cubit<CorporateClientState> {
  CorporateClientCubit(
      {required this.corporateRepo, required this.splashRepository})
      : super(CorporateClientState());

  final CorporateRepo corporateRepo;
  final SplashRepository splashRepository;

  void getAuthStatus() async {
    emit(state.copyWith(status: CorporateClientStatus.loading));
    final response = await splashRepository.getToken();
    if (response != null) {
      final userData = await corporateRepo.getUserData();
      emit(state.copyWith(
        status: CorporateClientStatus.auth,
        userName: userData.userName,
        phoneNumber: userData.phoneNumber,
      ));
    } else {
      emit(state.copyWith(status: CorporateClientStatus.unAuth));
    }
  }
}
