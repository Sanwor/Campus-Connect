List<String> classDays = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
];

var sunday = [
  {"time": "06:30 - 07:20", "subject": "Cloud Computing"},
  {"time": "07:20 - 08:10", "subject": "Advanced Java Programming"},
  {"time": "08:10 - 09:00", "subject": "Software Project Management"},
  {"time": "09:00 - 09:50", "subject": "E-Commerce"}
];
var monday = [
  {"time": "06:30 - 07:20", "subject": "Cloud Computing"},
  {"time": "07:20 - 08:10", "subject": "Advanced Java Programming"},
  {"time": "08:10 - 09:00", "subject": "Software Project Management"},
  {"time": "09:00 - 09:50", "subject": "E-Commerce"}
];
var tuesday = [
  {"time": "06:30 - 07:20", "subject": "Cloud Computing"},
  {"time": "07:20 - 08:10", "subject": "Advanced Java Programming"},
  {"time": "08:10 - 09:00", "subject": "Software Project Management"},
  {"time": "09:00 - 09:50", "subject": "E-Commerce"}
];
var wednesday = [
  {"time": "06:30 - 07:20", "subject": "Cloud Computing"},
  {"time": "07:20 - 08:10", "subject": "Advanced Java Programming"},
  {"time": "08:10 - 09:00", "subject": "Software Project Management"},
  {"time": "09:00 - 09:50", "subject": "E-Commerce"}
];
var thursday = [
  {"time": "06:30 - 07:20", "subject": "Cloud Computing"},
  {"time": "07:20 - 08:10", "subject": "Advanced Java Programming"},
  {"time": "08:10 - 09:00", "subject": "Software Project Management"},
  {"time": "09:00 - 09:50", "subject": "E-Commerce"}
];
var friday = [
  {"time": "06:30 - 07:20", "subject": "Cloud Computing"},
  {"time": "07:20 - 08:10", "subject": "Advanced Java Programming"},
  {"time": "08:10 - 09:00", "subject": "Software Project Management"},
  {"time": "09:00 - 09:50", "subject": "E-Commerce"}
];

final Map<String, List<Map<String, String>>> schedule = {
  "Sunday": sunday,
  "Monday": monday,
  "Tuesday": tuesday,
  "Wednesday": wednesday,
  "Thursday": thursday,
  "Friday": friday,
};

String getTodayName() {
  final today = DateTime.now().weekday;
  const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  return days[today - 1];
}

final List<Map<String, String>> notices = [
  {
    "title": "BIT VII Semester-2079 Exam Center Notice",
    "date": "2025-07-19",
  },
  {
    "title": "BIT VI Semester-2079 Result Notice",
    "date": "2025-07-12",
  },
  {
    "title": "BIT V Semester-2079 Result Notice",
    "date": "2025-07-12",
  },
  {
    "title": "BIT I Semester-2079 Result Notice",
    "date": "2025-07-12",
  },
  {
    "title": "BIT II Semester-2079 Result Notice",
    "date": "2025-07-12",
  },
  {
    "title": "BIT III Semester-2079 Result Notice",
    "date": "2025-07-12",
  },
  {
    "title": "BIT IV Semester-2079 Result Notice",
    "date": "2025-07-12",
  },
  // Add more notices as needed...
];
