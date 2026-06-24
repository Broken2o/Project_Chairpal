import os
import re

def replace_in_file(path, old, new):
    if not os.path.exists(path): return
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    content = content.replace(old, new)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

# 1. Update Place Entity
place_path = 'lib/features/home/domain/entities/place.dart'
replace_in_file(place_path, 'final bool isFavorite;', 'bool isFavorite;')
replace_in_file(place_path, 'const Place({', 'Place({')

place_model_path = 'lib/features/home/data/models/place_model.dart'
replace_in_file(place_model_path, 'final bool isFavorite;', 'bool isFavorite;')
replace_in_file(place_model_path, 'const PlaceModel({', 'PlaceModel({')

# 2. Place Details Screen
pds_path = 'lib/features/home/presentation/screens/place_details_screen.dart'
pds_imports = """import '../../domain/entities/place.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_state.dart';
import '../cubit/edit_delete_cubit/edit_delete_cubit.dart';
import '../cubit/edit_delete_cubit/edit_delete_state.dart';
import '../cubit/favorite_cubit/favorite_cubit.dart';
import '../cubit/favorite_cubit/favorite_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import 'add_place_screen.dart';"""
replace_in_file(pds_path, "import '../../domain/entities/place.dart';", pds_imports)

pds_state_old = """class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {"""

pds_state_new = """class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  int _currentPage = 0;

  bool _isOwner(BuildContext context) {
    final state = context.read<UserCubit>().state;
    if (state is UserLoaded) {
      return state.user.id == widget.place.owner?.id;
    }
    return false;
  }

  void _confirmDelete(BuildContext context) {
    final l10n = S.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteCategory ?? "Delete"),
        content: const Text("Are you sure you want to delete this place?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel ?? "Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<EditDeleteCubit>().deletePlace(int.parse(widget.place.id));
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _edit(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddPlaceScreen(
          floor: Place(id: widget.place.owner?.id ?? "0", name: "Floor", latitude: 0, longitude: 0, category: "Floor"),
          initialPlace: widget.place,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {"""
replace_in_file(pds_path, pds_state_old, pds_state_new)

pds_build_old = """    return hasImage
        ? _WithImageLayout(
            place: widget.place,
            distance: widget.distance,
            currentPage: _currentPage,
            onPageChanged: (i) => setState(() => _currentPage = i),
          )
        : _NoImageLayout(
            place: widget.place,
            distance: widget.distance,
          );"""

pds_build_new = """    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<EditDeleteCubit>()),
        BlocProvider(create: (_) => sl<FavoriteCubit>()),
      ],
      child: BlocListener<EditDeleteCubit, EditDeleteState>(
        listener: (context, state) {
          if (state is EditDeleteSuccess) {
            CustomSnackBar.showSuccess(
              context: context,
              message: "Deleted successfully",
            );
            Navigator.pop(context);
          } else if (state is EditDeleteError) {
            CustomSnackBar.showError(
              context: context,
              message: state.message,
            );
          }
        },
        child: hasImage
            ? _WithImageLayout(
                place: widget.place,
                distance: widget.distance,
                currentPage: _currentPage,
                onPageChanged: (i) => setState(() => _currentPage = i),
                isOwner: _isOwner(context),
                onEdit: () => _edit(context),
                onDelete: () => _confirmDelete(context),
              )
            : _NoImageLayout(
                place: widget.place,
                distance: widget.distance,
                isOwner: _isOwner(context),
                onEdit: () => _edit(context),
                onDelete: () => _confirmDelete(context),
              ),
      ),
    );"""
replace_in_file(pds_path, pds_build_old, pds_build_new)

pds_with_img_old = """class _WithImageLayout extends StatelessWidget {
  final Place place;
  final String distance;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const _WithImageLayout({
    required this.place,
    required this.distance,
    required this.currentPage,
    required this.onPageChanged,
  });"""
pds_with_img_new = """class _WithImageLayout extends StatelessWidget {
  final Place place;
  final String distance;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final bool isOwner;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _WithImageLayout({
    required this.place,
    required this.distance,
    required this.currentPage,
    required this.onPageChanged,
    required this.isOwner,
    required this.onEdit,
    required this.onDelete,
  });"""
replace_in_file(pds_path, pds_with_img_old, pds_with_img_new)

pds_fav_btn1 = """                  _GlassButton(
                    onTap: () {},
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),"""
pds_fav_btn1_new = """                  Row(
                    children: [
                      if (isOwner) ...[
                        _GlassButton(
                          onTap: onEdit,
                          child: const Icon(Icons.edit, color: Colors.white, size: 20),
                        ),
                        SizedBox(width: 8.w),
                        _GlassButton(
                          onTap: onDelete,
                          child: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                        ),
                        SizedBox(width: 8.w),
                      ],
                      BlocBuilder<FavoriteCubit, FavoriteState>(
                        builder: (context, state) {
                          return _GlassButton(
                            onTap: () {
                              context.read<FavoriteCubit>().toggleFavorite('place', int.parse(place.id));
                              place.isFavorite = !place.isFavorite;
                            },
                            child: Icon(
                              place.isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                              color: place.isFavorite ? Colors.redAccent : Colors.white,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ],
                  ),"""
replace_in_file(pds_path, pds_fav_btn1, pds_fav_btn1_new)

pds_no_img_old = """class _NoImageLayout extends StatelessWidget {
  final Place place;
  final String distance;

  const _NoImageLayout({required this.place, required this.distance});"""
pds_no_img_new = """class _NoImageLayout extends StatelessWidget {
  final Place place;
  final String distance;
  final bool isOwner;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _NoImageLayout({
    required this.place, 
    required this.distance,
    required this.isOwner,
    required this.onEdit,
    required this.onDelete,
  });"""
replace_in_file(pds_path, pds_no_img_old, pds_no_img_new)

pds_fav_btn2 = """              actions: [
                Container(
                  margin: EdgeInsets.only(right: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],"""
pds_fav_btn2_new = """              actions: [
                if (isOwner) ...[
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                    onPressed: onDelete,
                  ),
                ],
                BlocBuilder<FavoriteCubit, FavoriteState>(
                  builder: (context, state) {
                    return Container(
                      margin: EdgeInsets.only(right: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          place.isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                          color: place.isFavorite ? Colors.redAccent : Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          context.read<FavoriteCubit>().toggleFavorite('place', int.parse(place.id));
                          place.isFavorite = !place.isFavorite;
                        },
                      ),
                    );
                  },
                ),
              ],"""
replace_in_file(pds_path, pds_fav_btn2, pds_fav_btn2_new)

# Apply place cards fixes
old_fav = '''class _FavBtn extends StatelessWidget {
  const _FavBtn();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.favorite, // solid heart in screenshot
        size: 15,
        color: AppColors.primary,
      ),
    );
  }
}'''

new_fav = '''class _FavBtn extends StatelessWidget {
  final Place place;
  const _FavBtn({required this.place});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FavoriteCubit>(),
      child: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              context.read<FavoriteCubit>().toggleFavorite('place', int.parse(place.id));
              place.isFavorite = !place.isFavorite;
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                place.isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                size: 15,
                color: place.isFavorite ? Colors.redAccent : AppColors.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}'''

replace_in_file('lib/features/home/presentation/widgets/place_card.dart', old_fav, new_fav)
replace_in_file('lib/features/home/presentation/widgets/place_card_large.dart', old_fav, new_fav)

print("Applied UI features!")
