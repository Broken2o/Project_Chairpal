import 'dart:io';

void main() {
  final files = [
    'lib/features/home/presentation/widgets/place_card.dart',
    'lib/features/home/presentation/widgets/place_card_large.dart'
  ];

  final favImports = '''
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favorite_cubit/favorite_cubit.dart';
import '../cubit/favorite_cubit/favorite_state.dart';
import '../../../../core/di/injection_container.dart';
''';

  final favBtnOld = '''
class _FavBtn extends StatelessWidget {
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
}
''';

  final favBtnNew = '''
class _FavBtn extends StatelessWidget {
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
              place.isFavorite = !(place.isFavorite ?? false);
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
                (place.isFavorite ?? false) ? Icons.favorite : Icons.favorite_border_rounded,
                size: 15,
                color: (place.isFavorite ?? false) ? Colors.redAccent : AppColors.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}
''';

  for (final path in files) {
    final f = File(path);
    if (!f.existsSync()) continue;
    
    var content = f.readAsStringSync();
    
    // Add imports
    if (!content.contains('favorite_cubit.dart')) {
      content = content.replaceFirst(
        "import '../../domain/entities/place.dart';",
        "import '../../domain/entities/place.dart';\n" + favImports,
      );
    }
    
    // Replace const _FavBtn() with _FavBtn(place: place)
    content = content.replaceAll('child: const _FavBtn(),', 'child: _FavBtn(place: place),');
    content = content.replaceAll('child: _FavBtn(),', 'child: _FavBtn(place: place),');
    
    // Replace _FavBtn implementation
    content = content.replaceFirst(favBtnOld, favBtnNew);
    
    f.writeAsStringSync(content);
    print('Updated \$path');
  }
}
