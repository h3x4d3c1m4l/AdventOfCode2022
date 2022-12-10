import 'dart:collection';

import 'package:aoc22/solvers/solver.dart';
import 'package:string_scanner/string_scanner.dart';

class Year2022Day05Solver extends Solver<String, String> {

  @override
  String get problemUrl => 'https://adventofcode.com/2022/day/5';

  @override
  String get solverCodeFilename => 'year_2022_day_05_solver.dart';

  static final RegExp numberRegExp = RegExp(r'\d+');
  
  @override
  String getSolution(String input) {
    List<String> lines = input.split('\n').where((line) => line.isNotEmpty).toList(growable: false);
    List<ListQueue<String>> crateStacks;
    List<_MoveCrateInstruction> instructions = _parseInstructions(lines);

    // part 1
    crateStacks = _getInitialStacksFromInput(lines);
    for (_MoveCrateInstruction instruction in instructions) {
      // process crate move
      for (int i = 0; i < instruction.numberOfCrates; i++) {
        String crate = crateStacks[instruction.sourceStack - 1].removeFirst();
        crateStacks[instruction.destinationStack - 1].addFirst(crate);
      }
    }
    String part1TopCrates = crateStacks.map((crateStack) => crateStack.first).join();

    // part 2
    crateStacks = _getInitialStacksFromInput(lines);
    for (_MoveCrateInstruction instruction in instructions) {
      // process crate move
      List<String> crates = [];
      for (int i = 0; i < instruction.numberOfCrates; i++) {
        String crate = crateStacks[instruction.sourceStack - 1].removeFirst();
        crates.add(crate);
      }
      for (int i = instruction.numberOfCrates - 1; i >= 0; i--) {
        crateStacks[instruction.destinationStack - 1].addFirst(crates[i]); 
      }
    }
    String part2TopCrates = crateStacks.map((crateStack) => crateStack.first).join();

    return 'Part 1 top crates: $part1TopCrates\nPart 2 top crates: $part2TopCrates';
  }

  List<_MoveCrateInstruction> _parseInstructions(List<String> inputLines) {
    List<_MoveCrateInstruction> instructions = [];

    for (String inputLine in inputLines) {
      if (!inputLine.startsWith('move')) {
        continue;
      }

      // parse line
      final scanner = StringScanner(inputLine);

      scanner.expect('move ');
      scanner.expect(numberRegExp);
      int nCrates = int.parse(scanner.lastMatch![0]!);

      scanner.expect(' from ');
      scanner.expect(numberRegExp);
      int fromCrateStack = int.parse(scanner.lastMatch![0]!);

      scanner.expect(' to ');
      scanner.expect(numberRegExp);
      int toCrateStack = int.parse(scanner.lastMatch![0]!);

      instructions.add(_MoveCrateInstruction(nCrates, fromCrateStack, toCrateStack));
    }

    return instructions;
  }

  List<ListQueue<String>> _getInitialStacksFromInput(List<String> inputLines) {
    // create empty list of crate stacks
    int nCrateStacks = (inputLines[0].length / 4).ceil();
    List<ListQueue<String>> crateStacks = List.filled(nCrateStacks, ListQueue<String>(), growable: false);

    // read initial crate stacks
    for (int i = 0; i < inputLines.length; i++) {
      String line = inputLines[i];

      if (!line.trim().startsWith('[')) {
        // we reached the end of the initial crate stack description
        return crateStacks; 
      }

      for (var j = 0; j < line.length; j += 4) {
        if (line[j] == '[') {
          crateStacks[j ~/ 4].addLast(line[j + 1]);
        }
      }
    }

    return crateStacks;
  }

}

class _MoveCrateInstruction {

  final int numberOfCrates;
  final int sourceStack;
  final int destinationStack;

  _MoveCrateInstruction(this.numberOfCrates, this.sourceStack, this.destinationStack);

}
