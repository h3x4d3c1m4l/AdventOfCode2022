import 'package:aoc22/views/problem_solver_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

import 'solvers/_all_solvers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  static final NumberFormat _dayNumberFormat = NumberFormat('00');

  int topIndex = 0;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Coding Challenges Tool',
      home: NavigationView(
        appBar: const NavigationAppBar(
          title: Text('h3x4d3c1m4l\'s Coding Challenges Tool'),
          automaticallyImplyLeading: false,
        ),
        pane: NavigationPane(
          selected: topIndex,
          onChanged: (index) => setState(() => topIndex = index),
          displayMode: PaneDisplayMode.open,
          items: _getPaneItems(),
        ),
      ),
    );
  }

  List<NavigationPaneItem> _getPaneItems() {
    return [
      PaneItem(
        icon: const Icon(FluentIcons.home),
        title: const Text('Home'),
        body: const Center(
          child: Text("Welcome!"),
        ),
      ),
      _adventOfCode2021PaneItem,
      _adventOfCode2022PaneItem,
    ];
  }

  PaneItemExpander get _adventOfCode2021PaneItem {
    return PaneItemExpander(
      icon: const Icon(FluentIcons.code),
      title: const Text('Advent of Code 2021'),
      body: const Center(child: Text("Choose a day from the sub menu")),
      items: [
        _getAdventOfCodePaneItem(2021, 01, Year2021Day01Solver()),
      ],
    );
  }

  PaneItemExpander get _adventOfCode2022PaneItem {
    return PaneItemExpander(
      icon: const Icon(FluentIcons.code),
      title: const Text('Advent of Code 2022'),
      body: const Center(child: Text("Choose a day from the sub menu")),
      items: [
        _getAdventOfCodePaneItem(2022, 01, Year2022Day01Solver()),
        _getAdventOfCodePaneItem(2022, 02, Year2022Day02Solver()),
        _getAdventOfCodePaneItem(2022, 03, Year2022Day03Solver()),
      ],
    );
  }

  PaneItem _getAdventOfCodePaneItem(int year, int day, Solver solver) {
    String dayString = _dayNumberFormat.format(day);

    return PaneItem(
      icon: const Icon(FluentIcons.issue_solid),
      title: Text('Day $dayString'),
      body: ProblemSolverView(title: "AoC $year - Day $dayString", solver: solver),
    );
  }

}
