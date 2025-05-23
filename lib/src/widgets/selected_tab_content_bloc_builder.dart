import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_portfolio/src/core/locale/lang_keys.dart';
import 'package:personal_portfolio/src/core/utils/app_constants.dart';
import 'package:personal_portfolio/src/widgets/about_tab_content.dart';
import 'package:personal_portfolio/src/core/themes/app_colors.dart';
import 'package:personal_portfolio/src/widgets/portfolio_tab_content.dart';
import 'package:personal_portfolio/src/widgets/skills_tab_content.dart';

import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';

class SelectedTabContentBlocBuilder extends StatelessWidget {
  const SelectedTabContentBlocBuilder({
    super.key,
    this.aboutTabMargin,
    this.skillsTabMargin,
    this.portfolioGridPadding,
  });

  final EdgeInsetsGeometry? aboutTabMargin;
  final EdgeInsetsGeometry? skillsTabMargin;
  final EdgeInsetsGeometry? portfolioGridPadding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (_, current) => current is UpdateSelectedTab,
      builder: (context, state) {
        final selectedTab = context.watch<AppCubit>().selectedTab;
        switch (AppConstants.headerTitlesKeys[selectedTab]) {
          case LangKeys.about:
            return AboutTabContent(margin: aboutTabMargin);

          case LangKeys.skills:
            return SkillsTabContent(margin: skillsTabMargin);

          case LangKeys.portfolio:
            return PortfolioTabContent(gridPadding: portfolioGridPadding);

          default:
            return const Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor,
                ),
              ),
            );
        }
      },
    );
  }
}
