import 'package:equatable/equatable.dart';
import 'package:googleiolapaz/core/ia/ia.dart';

enum Hand {
  none,
  left,
  rigth;

  static Hand getHand(String hand) {
    switch (hand) {
      case 'Right':
        return Hand.left;
      case 'Left':
        return Hand.rigth;
      default:
        return Hand.none;
    }
  }
}

enum Command {
  none(0),
  go(1),
  stop(2),
  left(3),
  rigth(4),
  sit(6),
  greet(7),
  tragedy(5);

  const Command(this.value);
  final int value;

  static Command getCommand(String gesture, Hand hand) {
    // Open_Palm
    // Pointing_Up
    // Thumb_Up
    // Thumb_Down
    // Victory
    // Closed_Fist
    // ILoveYou

    // print(hand);
    switch (gesture) {
      case 'Pointing_Up':
        return Command.go;
      case 'Open_Palm':
        return Command.stop;
      case 'Thumb_Up':
        if (hand == Hand.left) {
          return Command.left;
        }
        if (hand == Hand.rigth) {
          return Command.rigth;
        }
        break;
      case 'Thumb_Down':
        return Command.none;
      case 'Victory':
        return Command.greet;
      case 'Closed_Fist':
        return Command.sit;
      case 'ILoveYou':
        return Command.tragedy;
      default:
        return Command.none;
    }
    return Command.none;
  }
}

class IAEvent extends Equatable {
  const IAEvent(this.command, this.hand, this.landMarks);

  final Command command;
  final Hand hand;
  final List<Landmark> landMarks;

  @override
  List<Object> get props => [command, hand, landMarks];
}
