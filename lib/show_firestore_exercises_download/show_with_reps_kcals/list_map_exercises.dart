final Map<String, Map<String, Map<String, List<Map<String, dynamic>>>>> exerciseData = {
  'beginner': {
    'underweight': {
      'back': [
        {'name': 'seated lower back stretch', 'baseSetsSecs': 1, 'baseSecs': 15, 'baseCalories': 5},
        {'name': 'spine stretch', 'baseSetsReps': 1, 'baseReps': 12, 'baseCalories': 8},
      ],
      'chest': [
        {'name': 'push-up (wall)', 'baseSetsReps': 2, 'baseReps': 10, 'baseCalories': 15},
      ],
      'cardio': [
        {'name': 'high knee against wall', 'baseSetsSecs': 3, 'baseSecs': 30, 'baseCalories': 20},
      ],
    },
    'normal': {
      'back': [
        {'name': 'standing lateral stretch', 'baseSetsSecs': 1, 'baseSecs': 15, 'baseCalories': 5},
        {'name': 'kneeling lat stretch', 'baseSetsSecs': 1, 'baseSecs': 20, 'baseCalories': 8},
      ],
      'chest': [
        {'name': 'kneeling push-up (male)', 'baseSetsReps': 3, 'baseReps': 12, 'baseCalories': 25},
        {'name': 'dynamic chest stretch (male)', 'baseSetsSecs': 2, 'baseSecs': 15, 'baseCalories': 10},
      ],
      'cardio': [
        {'name': 'run', 'baseSecs': 600, 'baseCalories': 100},
      ],
    },
    'overweight': {
      'back': [
        {'name': 'side lying floor stretch', 'baseSetsSecs': 2, 'baseSecs': 20, 'baseCalories': 10},
        {'name': 'standing pelvic tilt', 'baseSetsSecs': 2, 'baseSecs': 15, 'baseCalories': 8},
      ],
      'chest': [
        {'name': 'isometric chest squeeze', 'baseSetsSecs': 3, 'baseSecs': 10, 'baseCalories': 12},
      ],
      'cardio': [
        {'name': 'high knee against wall', 'baseSetsSecs': 3, 'baseSecs': 30, 'baseCalories': 20},
      ],
    },
    'obese': {
      'back': [
        {'name': 'lower back curl', 'baseSetsReps': 2, 'baseReps': 12, 'baseCalories': 15},
      ],
      'chest': [
        {'name': 'push-up (wall)', 'baseSetsReps': 2, 'baseReps': 10, 'baseCalories': 15},
      ],
      'cardio': [
        {'name': 'march in place', 'baseSetsSecs': 3, 'baseSecs': 60, 'baseCalories': 30},
      ],
    },
    'extreme_obese': {
      'back': [
        {'name': 'sphinx', 'baseSetsSecs': 2, 'baseSecs': 20, 'baseCalories': 10},
      ],
      'chest': [
        {'name': 'isometric chest squeeze', 'baseSetsSecs': 3, 'baseSecs': 10, 'baseCalories': 12},
      ],
      'cardio': [
        {'name': 'step touch', 'baseSetsSecs': 3, 'baseSecs': 60, 'baseCalories': 30},
      ],
    },
  },
  'intermediate': {
    'underweight': {
      'back': [
        {'name': 'upward facing dog', 'baseSetsSecs': 2, 'baseSecs': 20, 'baseCalories': 12},
      ],
      'chest': [
        {'name': 'incline push-up', 'baseSetsReps': 3, 'baseReps': 12, 'baseCalories': 25},
      ],
      'cardio': [
        {'name': 'mountain climber', 'baseSetsSecs': 3, 'baseSecs': 30, 'baseCalories': 35},
      ],
    },
    'normal': {
      'back': [
        {'name': 'two toe touch (male)', 'baseSetsReps': 2, 'baseReps': 15, 'baseCalories': 15},
      ],
      'chest': [
        {'name': 'decline push-up', 'baseSetsReps': 3, 'baseReps': 15, 'baseCalories': 30},
      ],
      'cardio': [
        {'name': 'burpee', 'baseSetsReps': 3, 'baseReps': 12, 'baseCalories': 50},
      ],
    },
    'overweight': {
      'back': [
        {'name': 'lower back curl', 'baseSetsReps': 2, 'baseReps': 12, 'baseCalories': 15},
      ],
      'chest': [
        {'name': 'shoulder tap push-up', 'baseSetsReps': 3, 'baseReps': 10, 'baseCalories': 28},
      ],
      'cardio': [
        {'name': 'push to run', 'baseSecs': 300, 'baseCalories': 80},
      ],
    },
    'obese': {
      'back': [
        {'name': 'upper back stretch', 'baseSetsSecs': 2, 'baseSecs': 20, 'baseCalories': 10},
      ],
      'chest': [
        {'name': 'wide hand push up', 'baseSetsReps': 2, 'baseReps': 12, 'baseCalories': 20},
      ],
      'cardio': [
        {'name': 'low impact jumping jack', 'baseSetsSecs': 3, 'baseSecs': 60, 'baseCalories': 40},
      ],
    },
    'extreme_obese': {
      'back': [
        {'name': 'sphinx', 'baseSetsSecs': 2, 'baseSecs': 20, 'baseCalories': 10},
      ],
      'chest': [
        {'name': 'clock push-up', 'baseSetsReps': 2, 'baseReps': 10, 'baseCalories': 18},
      ],
      'cardio': [
        {'name': 'march in place', 'baseSetsSecs': 3, 'baseSecs': 60, 'baseCalories': 30},
      ],
    },
  },
  'advanced': {
    'underweight': {
      'back': [
        {'name': 'one arm against wall', 'baseSetsSecs': 2, 'baseSecs': 20, 'baseCalories': 12},
      ],
      'chest': [
        {'name': 'archer push up', 'baseSetsReps': 4, 'baseReps': 15, 'baseCalories': 40},
      ],
      'cardio': [
        {'name': 'star jump (male)', 'baseSetsReps': 3, 'baseReps': 20, 'baseCalories': 50},
      ],
    },
    'normal': {
      'back': [
        {'name': 'one arm against wall', 'baseSetsSecs': 2, 'baseSecs': 20, 'baseCalories': 12},
      ],
      'chest': [
        {'name': 'push and pull bodyweight', 'baseSetsReps': 3, 'baseReps': 15, 'baseCalories': 35},
      ],
      'cardio': [
        {'name': 'semi squat jump (male)', 'baseSetsReps': 4, 'baseReps': 12, 'baseCalories': 45},
      ],
    },
    'overweight': {
      'back': [
        {'name': 'one arm against wall', 'baseSetsSecs': 2, 'baseSecs': 20, 'baseCalories': 12},
      ],
      'chest': [
        {'name': 'isometric wipers', 'baseSetsReps': 3, 'baseReps': 12, 'baseCalories': 28},
      ],
      'cardio': [
        {'name': 'high knees', 'baseSetsSecs': 4, 'baseSecs': 30, 'baseCalories': 35},
      ],
    },
    'obese': {
      'back': [],
      'chest': [
        {'name': 'push-up', 'baseSetsReps': 3, 'baseReps': 15, 'baseCalories': 30},
      ],
      'cardio': [
        {'name': 'march in place', 'baseSetsSecs': 3, 'baseSecs': 60, 'baseCalories': 30},
      ],
    },
    'extreme_obese': {
      'back': [],
      'chest': [],
      'cardio': [
        {'name': 'march in place', 'baseSetsSecs': 3, 'baseSecs': 60, 'baseCalories': 30},
      ],
    },
  },
};