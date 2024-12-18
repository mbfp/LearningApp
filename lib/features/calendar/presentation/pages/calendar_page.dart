import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/responsive_layout.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_colors.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_text.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_appbar.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_card.dart';
import 'package:learning_app/features/calendar/presentation/bloc/cubit/calendar_cubit.dart';
import 'package:learning_app/features/calendar/presentation/widgets/month_tile.dart';
import 'package:learning_app/features/calendar/presentation/widgets/streak_saver_tile.dart';
import 'package:learning_app/features/calendar/presentation/widgets/streak_tile.dart';
import 'package:learning_app/features/calendar/presentation/widgets/tomorrow_tile.dart';
import 'package:learning_app/features/home/presentation/widgets/week_row.dart';
import 'package:learning_app/generated/l10n.dart';
import 'package:learning_app/injection_container.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CalendarCubit>(),
      child: const ResponsiveLayout(
        mobile: CalendarViewMobile(),
      ),
    );
  }
}

class CalendarViewMobile extends StatelessWidget {
  const CalendarViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIAppBar(
        title: S.of(context).calendar,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: UIConstants.pageHorizontalPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: StreakTile(),
                  ),
                  SizedBox(width: UIConstants.itemPadding),
                  Expanded(
                    flex: 3,
                    child: StreakSaverTile(),
                  ),
                ],
              ),
              SizedBox(height: UIConstants.itemPadding),
              TomorrowTile(),
              SizedBox(height: UIConstants.itemPadding),
              MonthTile(),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
