import 'dart:core';

import 'package:aoc22/solvers/solver.dart';
import 'package:tuple/tuple.dart';

class Day09Solver extends Solver<String, String> {

  @override
  String get problemUrl => 'https://adventofcode.com/2022/day/9';

  @override
  String get solverCodeFilename => 'day_09_solver.dart';
  
  @override
  String getSolution(String input) {
    List<Tuple2<String, int>> movementInstructions = input
        .split('\n')
        .where((line) => line.isNotEmpty)
        .map((rawInstructionLine) => rawInstructionLine.split(' '))
        .map((rawInstruction) => Tuple2(rawInstruction[0], int.parse(rawInstruction[1])))
        .toList(growable: false);
    
    // part 1
    int positionsVisitedByTail = getAmountOfPositionsVisitedByTail(movementInstructions, 2);

    // part 2
    int positionsVisitedByTail10Knots = getAmountOfPositionsVisitedByTail(movementInstructions, 10);

    return 'Positions visited part 1: $positionsVisitedByTail\nPositions visited part 2: $positionsVisitedByTail10Knots';
  }

  int getAmountOfPositionsVisitedByTail(List<Tuple2<String, int>> movementInstructions, int numberOfKnots) {
    Set<Tuple2<int, int>> positionsVisitedByTail = {};
    List<Tuple2<int, int>> knots = List.filled(numberOfKnots, const Tuple2(0, 0));
    for (Tuple2<String, int> instruction in movementInstructions) {
      for (int i = 0; i < instruction.item2; i++) {
        // move head
        switch (instruction.item1) {
          case 'L':
            knots[0] = knots[0].withItem1(knots[0].item1 - 1);
            break;
          case 'R':
            knots[0] = knots[0].withItem1(knots[0].item1 + 1);
            break;
          case 'U':
            knots[0] = knots[0].withItem2(knots[0].item2 + 1);
            break;
          case 'D':
            knots[0] = knots[0].withItem2(knots[0].item2 - 1);
            break;
        }

        // let tail follow
        for (int i = 1; i < knots.length; i++) {
          int deltaX = knots[i - 1].item1 - knots[i].item1;
          int deltaY = knots[i - 1].item2 - knots[i].item2;
          if (deltaX.abs() == 2 && deltaY == 0) {
            knots[i] = knots[i].withItem1(knots[i].item1 + deltaX ~/ 2);
          } else if (deltaX == 0 && deltaY.abs() == 2) {
            knots[i] = knots[i].withItem2(knots[i].item2 + deltaY ~/ 2);
          } else if (deltaX.abs() == 2 && deltaY.abs() == 1) {
            knots[i] = Tuple2<int, int>(knots[i].item1 + deltaX ~/ 2, knots[i].item2 + deltaY);
          } else if (deltaX.abs() == 1 && deltaY.abs() == 2) {
            knots[i] = Tuple2<int, int>(knots[i].item1 + deltaX, knots[i].item2 + deltaY ~/ 2);
          } else if (deltaX.abs() == 2 && deltaY.abs() == 2) {
            knots[i] = Tuple2<int, int>(knots[i].item1 + deltaX ~/ 2, knots[i].item2 + deltaY ~/ 2);
          }
        }

        positionsVisitedByTail.add(knots.last);
      }
    }

    return positionsVisitedByTail.length;
  }

}
