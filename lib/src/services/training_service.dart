class TrainingService {
  final List<Map<String, dynamic>> _routines = [
    {
      'name': 'Fuerza Tren Superior',
      'desc': 'Pecho, espalda y hombros',
      'duration': 45,
      'exercises': 8,
      'level': 'Intermedio',
      'muscles': ['Pecho', 'Espalda', 'Hombros', 'Tríceps'],
      'category': 'Fuerza',
    },
    {
      'name': 'Fuerza Tren Inferior',
      'desc': 'Cuádriceps, isquios y glúteos',
      'duration': 40,
      'exercises': 6,
      'level': 'Intermedio',
      'muscles': ['Cuádriceps', 'Glúteos'],
      'category': 'Fuerza',
    },
    {
      'name': 'Full Body Funcional',
      'desc': 'Cuerpo completo funcional',
      'duration': 55,
      'exercises': 10,
      'level': 'Avanzado',
      'muscles': ['Cuerpo completo'],
      'category': 'Fuerza',
    },
    {
      'name': 'Cardio HIIT',
      'desc': 'Intervalos de alta intensidad',
      'duration': 30,
      'exercises': 8,
      'level': 'Principiante',
      'muscles': ['Cardio', 'Core'],
      'category': 'Cardio',
    },
    {
      'name': 'Movilidad y Flexibilidad',
      'desc': 'Mejora tu rango de movimiento',
      'duration': 25,
      'exercises': 10,
      'level': 'Principiante',
      'muscles': ['Cuerpo completo'],
      'category': 'Movilidad y Flexibilidad',
    },
  ];

  List<Map<String, dynamic>> getAllRoutines() => _routines;

  Map<String, dynamic> getTodayRoutine(String? objetivo) {
    switch (objetivo) {
      case 'Perder peso':
        return _routines.firstWhere((r) => r['category'] == 'Cardio');
      case 'Ganar masa muscular':
        return _routines.firstWhere((r) => r['category'] == 'Fuerza');
      case 'Mejorar la salud':
        return _routines.firstWhere(
          (r) => r['category'] == 'Movilidad y Flexibilidad',
          orElse: () => _routines.first,
        );
      default:
        return _routines.first;
    }
  }
}
