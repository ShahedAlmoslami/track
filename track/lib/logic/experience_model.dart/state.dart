
import 'package:flutter/widgets.dart';
import 'package:track/data/models/experience_model.dart';

class ExperienceState{}
class ExperienceInitialState extends ExperienceState{}
class ExperienceLoadingState extends ExperienceState{}


class ExperienceSuccessState extends ExperienceState{
    final List<ExperienceModel> experiences;

  ExperienceSuccessState(this.experiences);
}
class ExperienceErrorState extends ExperienceState{
  final String message;
  ExperienceErrorState(this.message);
}