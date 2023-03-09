import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipes_jovis_ai/core/helpers.dart';
import 'package:recipes_jovis_ai/core/interfaces/page_definition.dart';
import 'package:recipes_jovis_ai/features/recipe_repository.dart';

final recipeListsProvider = Provider.autoDispose((ref) =>
    Modular.get<RecipeRepository>()
        .getRecipesInCategory(Modular.args.params['id']));

final categoryNameProvider = Provider.autoDispose((ref) =>
    Modular.get<RecipeRepository>().getCategoryName(Modular.args.params['id']));

class RecipeListPage extends ConsumerWidget implements IPage {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var recipes = ref.watch(recipeListsProvider).toList();
    return WillPopScope(
        onWillPop: () async {
          Modular.to.navigate(PageConstant.categories);
          return false;
        },
        child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                border: const Border(bottom: BorderSide.none),
                padding: const EdgeInsetsDirectional.all(0),
                leading: GestureDetector(
                  child: Container(
                    width: 55,
                    color: CupertinoTheme.of(context).barBackgroundColor,
                    child: const Icon(
                      CupertinoIcons.back,
                      size: 25,
                    ),
                  ),
                  onTap: () => Modular.to.navigate(PageConstant.categories),
                )),
            child: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ref.read(categoryNameProvider).toString(),
                          style:
                              const TextStyle(fontSize: AppDefault.xxFontSize),
                        ),
                        Container(
                          height: 30,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: recipes.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    CupertinoListTile(
                                        onTap: () => Modular.to.navigate(
                                            PageConstant.recipe.replaceFirst(
                                                ":category_id",
                                                Modular.args.params['id']),
                                            arguments: recipes[index]),
                                        padding: const EdgeInsets.only(
                                            left: 0, top: 10.0, bottom: 28),
                                        title: Text(
                                          recipes[index].title,
                                          style: const TextStyle(
                                              fontSize: AppDefault.xFontSize),
                                        )),
                                  ],
                                );
                              }),
                        )
                      ],
                    )))));
  }

  @override
  String route() {
    return PageConstant.recipes;
  }
}