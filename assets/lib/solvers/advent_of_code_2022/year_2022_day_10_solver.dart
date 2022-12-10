import 'dart:core';

import 'package:aoc22/solvers/solver.dart';
import 'package:tuple/tuple.dart';

class Year2022Day10Solver extends Solver<String, String> {

  @override
  String get problemUrl => 'https://adventofcode.com/2022/day/10';

  @override
  String get solverCodeFilename => 'year_2022_day_10_solver.dart';
  
  @override
  String getSolution(String input) {
    List<Tuple2<String, int?>> cpuInstructions = input
        .split('\n')
        .where((line) => line.isNotEmpty)
        .map((rawInstructionLine) => rawInstructionLine.split(' '))
        .map((rawInstruction) => Tuple2(rawInstruction[0], rawInstruction.length == 2 ? int.parse(rawInstruction[1]) : null))
        .toList(growable: false);
    
    // part 1
    int cycle = 0;
    int signalStrengthSum = 0;
    int xRegisterValue = 1;
    for (Tuple2<String, int?> instruction in cpuInstructions) {
      cycle++;
      signalStrengthSum += getSignalStrengthSumForCycle(cycle, xRegisterValue);
      
      if (instruction.item1 == 'addx') {
        cycle++;
        signalStrengthSum += getSignalStrengthSumForCycle(cycle, xRegisterValue);
        xRegisterValue += instruction.item2!;
      }

      if (cycle > 220) {
        break;
      }
    }

    // part 2
    cycle = 0;
    xRegisterValue = 1;
    List<String> pixelLines = List.filled(6, '........................................');
    updateCrtDisplay(pixelLines, cycle, xRegisterValue);
    for (Tuple2<String, int?> instruction in cpuInstructions) {
      cycle++;
      
      updateCrtDisplay(pixelLines, cycle, xRegisterValue);
      
      if (instruction.item1 == 'addx') {
        cycle++;
        xRegisterValue += instruction.item2!;
        updateCrtDisplay(pixelLines, cycle, xRegisterValue);
      }

      if (cycle >= 240) {
        break;
      }
    }

    return 'Signal strength sum: $signalStrengthSum\nCRT display:\n${pixelLines.join('\n')}';
  }

  int getSignalStrengthSumForCycle(int cycle, int xRegisterValue) {
    if (cycle >= 20 && (cycle - 20) % 40 == 0) {
      return cycle * xRegisterValue;
    }
    return 0;
  }
  
  void updateCrtDisplay(List<String> pixelLines, int cycle, int xRegisterValue) {
    int crtRow = cycle ~/ 40;
    int crtColumn = cycle % 40;

    if (crtColumn >= (xRegisterValue - 1) && crtColumn <= (xRegisterValue + 1)) {
      pixelLines[crtRow] = pixelLines[crtRow].replaceRange(crtColumn, crtColumn + 1, '#');
    }
  }

}
