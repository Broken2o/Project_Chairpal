import 'dart:io';

void main() {
  final file = File('lib/features/home/presentation/screens/place_details_screen.dart');
  var content = file.readAsStringSync();

  // 1. Imports
  final imports = '''
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_state.dart';
import '../cubit/edit_delete_cubit/edit_delete_cubit.dart';
import '../cubit/edit_delete_cubit/edit_delete_state.dart';
import '../cubit/favorite_cubit/favorite_cubit.dart';
import '../cubit/favorite_cubit/favorite_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import 'add_place_screen.dart';
import '../../../../l10n/l10n.dart';
''';
  content = content.replaceFirst(
      "import '../../../../core/theme/app_colors.dart';\nimport '../../../../core/theme/app_styles.dart';",
      imports);

  // 2. _PlaceDetailsScreenState
  final stateStart = '''
class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
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
        content: Text("Are you sure you want to delete this place?"),
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
            child: Text("Delete", style: TextStyle(color: Colors.red)),
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
          floor: Place(id: widget.place.parentId ?? "0", name: "Floor", latitude: 0, longitude: 0),
          initialPlace: widget.place,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.place.imagePaths != null &&
        widget.place.imagePaths!.isNotEmpty;

    return MultiBlocProvider(
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
    );
  }
''';

  final regex1 = RegExp(r'class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> \{[\s\S]*?\}\n');
  content = content.replaceFirst(regex1, stateStart + "}\n");

  // 3. _WithImageLayout constructor
  final withImageLayoutConst = '''
class _WithImageLayout extends StatelessWidget {
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
  });
''';
  final regex3 = RegExp(r'class _WithImageLayout extends StatelessWidget \{[\s\S]*?\}\);');
  content = content.replaceFirst(regex3, withImageLayoutConst);

  // 4. _WithImageLayout Top buttons
  final glassButtonFavorite = '''
                  _GlassButton(
                    onTap: () {},
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
''';
  final glassButtonFavoriteReplace = '''
                  Row(
                    children: [
                      if (isOwner) ...[
                        _GlassButton(
                          onTap: onEdit,
                          child: const Icon(Icons.edit, color: Colors.white, size: 20),
                        ),
                        SizedBox(width: 8),
                        _GlassButton(
                          onTap: onDelete,
                          child: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                        ),
                        SizedBox(width: 8),
                      ],
                      BlocBuilder<FavoriteCubit, FavoriteState>(
                        builder: (context, state) {
                          return _GlassButton(
                            onTap: () {
                              context.read<FavoriteCubit>().toggleFavorite('place', int.parse(place.id));
                              // We can trigger rebuild since we are wrapped in BlocBuilder, 
                              // but Place object might not update automatically unless we setState
                              // Since this is StatelessWidget, we just rely on the API. 
                              // For immediate visual feedback, local mutation can be used if we make it Stateful,
                              // but we'll let the user see it updated when they refresh or we can mutate it manually.
                              place.isFavorite = !(place.isFavorite ?? false);
                            },
                            child: Icon(
                              (place.isFavorite ?? false) ? Icons.favorite : Icons.favorite_border_rounded,
                              color: (place.isFavorite ?? false) ? Colors.redAccent : Colors.white,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
''';
  content = content.replaceFirst(glassButtonFavorite, glassButtonFavoriteReplace);


  // 5. _NoImageLayout constructor
  final noImageLayoutConst = '''
class _NoImageLayout extends StatelessWidget {
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
  });
''';
  final regex5 = RegExp(r'class _NoImageLayout extends StatelessWidget \{[\s\S]*?\}\);');
  content = content.replaceFirst(regex5, noImageLayoutConst);

  // 6. _NoImageLayout actions
  final noImageActions = '''
              actions: [
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
              ],
''';
  final noImageActionsReplace = '''
              actions: [
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
                          (place.isFavorite ?? false) ? Icons.favorite : Icons.favorite_border_rounded,
                          color: (place.isFavorite ?? false) ? Colors.redAccent : Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          context.read<FavoriteCubit>().toggleFavorite('place', int.parse(place.id));
                          place.isFavorite = !(place.isFavorite ?? false);
                        },
                      ),
                    );
                  },
                ),
              ],
''';
  content = content.replaceFirst(noImageActions, noImageActionsReplace);

  file.writeAsStringSync(content);
  print('done');
}
