import 'package:aoc22/solvers/solver.dart';
import 'package:tuple/tuple.dart';

class Year2022Day04Solver extends Solver<String, String> {

  @override
  String get problemUrl => 'https://adventofcode.com/2022/day/4';

  @override
  String get solverCodeFilename => 'year_2022_day_04_solver.dart';
  
  @override
  String getSolution(String input) {
    List<Tuple2<String, String>> rawAssignmentPairs = input
        .split('\n')
        .where((rawAssignmentPair) => rawAssignmentPair.isNotEmpty)
        .map((rawAssignmentPair) => Tuple2<String, String>.fromList(rawAssignmentPair.split(',')))
        .toList();

    // part 1
    int nAssignmentPairsFullOverlap = 0;
    for (Tuple2<String, String> rawAssignmentpair in rawAssignmentPairs) {
      List<int> assignment1 =
          rawAssignmentpair.item1.split('-').map((rawAssignment) => int.parse(rawAssignment)).toList();
      List<int> assignment2 =
          rawAssignmentpair.item2.split('-').map((rawAssignment) => int.parse(rawAssignment)).toList();

      if ((assignment1[0] >= assignment2[0] && assignment1[1] <= assignment2[1]) ||
          (assignment2[0] >= assignment1[0] && assignment2[1] <= assignment1[1])) {
        nAssignmentPairsFullOverlap++;
      }
    }

    // part 2
    int nAssignmentPairsPartialOverlap = 0;
    for (Tuple2<String, String> rawAssignmentPair in rawAssignmentPairs) {
      List<int> assignment1 =
          rawAssignmentPair.item1.split('-').map((rawAssignment) => int.parse(rawAssignment)).toList();
      List<int> assignment2 =
          rawAssignmentPair.item2.split('-').map((rawAssignment) => int.parse(rawAssignment)).toList();

      if ((assignment1[0] >= assignment2[0] && assignment1[0] <= assignment2[1]) ||
          (assignment1[1] >= assignment2[0] && assignment1[1] <= assignment2[1]) ||
          (assignment2[0] >= assignment1[0] && assignment2[0] <= assignment1[1]) ||
          (assignment2[1] >= assignment1[0] && assignment2[1] <= assignment1[1])) {
        nAssignmentPairsPartialOverlap++;
      }
    }

    return 'Assignment pairs with full overlap: $nAssignmentPairsFullOverlap\nAssignment pairs with partial overlap: $nAssignmentPairsPartialOverlap';
  }

}
