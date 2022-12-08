import 'package:aoc22/solvers/solver.dart';
import 'package:tuple/tuple.dart';

class Year2021Day02Solver extends Solver<String, String> {

  @override
  String get problemUrl => 'https://adventofcode.com/2021/day/2';

  @override
  String get solverCodeFilename => 'year_2021_day_02_solver.dart';
  
  @override
  String getSolution(String input) {
    List<Tuple2<String, int>> instructions = input
      .split('\n')
      .where((rawMeasurement) => rawMeasurement.isNotEmpty)
      .map((rawInstruction) => rawInstruction.split(' '))
      .map((splittedInstruction) => Tuple2(splittedInstruction[0], int.parse(splittedInstruction[1])))
      .toList();

    // part 1
    int horizontalPosition = 0, depth = 0;
    for (Tuple2<String, int> instruction in instructions) {
      switch (instruction.item1) {
        
        case 'forward':
          horizontalPosition += instruction.item2;
          break;
        case 'down':
          depth += instruction.item2;
          break;
        case 'up':
          depth -= instruction.item2;
          break;

      }
    }
    int horizontalPositionTimesDepth = horizontalPosition * depth;

    // part 2
    int aim = 0;
    horizontalPosition = 0;
    depth = 0;
    for (Tuple2<String, int> instruction in instructions) {
      switch (instruction.item1) {
        
        case 'forward':
          horizontalPosition += instruction.item2;
          depth += aim * instruction.item2;
          break;
        case 'down':
          aim += instruction.item2;
          break;
        case 'up':
          aim -= instruction.item2;
          break;

      }
    }
    int horizontalPositionTimesDepthPart2 = horizontalPosition * depth;

    return 'Horizontal position times final depth (part 1): $horizontalPositionTimesDepth\nHorizontal position times final depth (part 2): $horizontalPositionTimesDepthPart2';
  }

}
