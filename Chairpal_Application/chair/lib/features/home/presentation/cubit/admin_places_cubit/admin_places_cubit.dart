import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/network/api_result.dart';
import '../../../domain/usecases/get_organizations_usecase.dart';
import '../../../domain/entities/place.dart';
import 'admin_places_state.dart';

class AdminPlacesCubit extends Cubit<AdminPlacesState> {
  final GetOrganizationsUseCase _getOrganizationsUseCase;

  AdminPlacesCubit({required GetOrganizationsUseCase getOrganizationsUseCase})
      : _getOrganizationsUseCase = getOrganizationsUseCase,
        super(AdminPlacesInitial());

  Future<void> fetchOrganizations({String? search, String? include, int? categoryId}) async {
    emit(AdminPlacesLoading());
    final result = await _getOrganizationsUseCase(
      search: search,
      include: include ?? 'categories,places', // Default includes
      categoryId: categoryId,
    );

    if (isClosed) return;
    if (result is ApiSuccess<List<Place>>) {
      emit(AdminPlacesLoaded(result.data));
    } else if (result is ApiError<List<Place>>) {
      emit(AdminPlacesError(result.failure.message));
    }
  }
}
