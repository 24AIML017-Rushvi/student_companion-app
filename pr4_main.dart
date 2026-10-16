
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentApp());
}

class StudentApp extends StatefulWidget {
  const StudentApp({super.key});

  @override
  State<StudentApp> createState() => _StudentAppState();
}

class _StudentAppState extends State<StudentApp> {
  // Application state: theme shared by the entire app.
  bool isDarkMode = false;

  void changeTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Student Companion',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F7FC),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: SettingsScreen(
        isDarkMode: isDarkMode,
        onThemeChanged: changeTheme,
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Ephemeral state: profile editing fields.
  final TextEditingController nameController =
      TextEditingController(text: 'Rushvi Kathiriya');

  final TextEditingController enrollmentController =
      TextEditingController(text: '24AIML017');

  final TextEditingController departmentController =
      TextEditingController(text: 'Artificial Intelligence & ML');

  String studentName = 'Rushvi Kathiriya';
  String enrollment = '24AIML017';
  String department = 'Artificial Intelligence & ML';

  int selectedSemester = 5;
  String selectedLanguage = 'English';

  bool assignmentAlerts = true;
  bool examNotifications = true;
  bool placementUpdates = true;
  bool eventAnnouncements = true;

  final Map<String, bool> courses = {
    'Mobile Application Development': true,
    'Artificial Intelligence': true,
    'Database Management System': false,
    'Computer Networks': false,
  };

  double dashboardSize = 1.0;
  bool showAttendance = true;
  bool showAssignments = true;

  @override
  void dispose() {
    nameController.dispose();
    enrollmentController.dispose();
    departmentController.dispose();
    super.dispose();
  }

  void saveProfile() {
    setState(() {
      studentName = nameController.text.trim();
      enrollment = enrollmentController.text.trim();
      department = departmentController.text.trim();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Icon(
            widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // STUDENT PROFILE
          const SectionTitle(
            title: 'Student Profile',
            icon: Icons.person,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person,
                      size: 42,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    studentName.isEmpty ? 'Student Name' : studentName,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Enrollment: $enrollment'),
                  Text(department),
                  const Divider(height: 28),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Student Name',
                      prefixIcon: Icon(Icons.badge),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: enrollmentController,
                    decoration: const InputDecoration(
                      labelText: 'Enrollment Number',
                      prefixIcon: Icon(Icons.numbers),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: departmentController,
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      prefixIcon: Icon(Icons.school),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: saveProfile,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Profile'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // THEME SETTINGS
          const SectionTitle(
            title: 'Theme Settings',
            icon: Icons.palette,
          ),
          Card(
            child: SwitchListTile(
              secondary: Icon(
                widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              title: const Text('Dark Mode'),
              subtitle: Text(
                widget.isDarkMode
                    ? 'Dark theme enabled'
                    : 'Light theme enabled',
              ),
              value: widget.isDarkMode,
              onChanged: widget.onThemeChanged,
            ),
          ),

          const SizedBox(height: 20),

          // SEMESTER DROPDOWN
          const SectionTitle(
            title: 'Semester Selection',
            icon: Icons.calendar_month,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButtonFormField<int>(
                value: selectedSemester,
                decoration: const InputDecoration(
                  labelText: 'Select Semester',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(
                  8,
                  (index) => DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('Semester ${index + 1}'),
                  ),
                ),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    selectedSemester = value;
                  });
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Selected Semester'),
              trailing: Text(
                'Semester $selectedSemester',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // LANGUAGE RADIO BUTTONS
          const SectionTitle(
            title: 'Language Preference',
            icon: Icons.language,
          ),
          Card(
            child: Column(
              children: [
                for (final language in ['English', 'Hindi', 'Gujarati'])
                  RadioListTile<String>(
                    title: Text(language),
                    value: language,
                    groupValue: selectedLanguage,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedLanguage = value;
                      });
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Selected Language: $selectedLanguage',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // NOTIFICATION SETTINGS
          const SectionTitle(
            title: 'Notification Preferences',
            icon: Icons.notifications,
          ),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Assignment Alerts'),
                  value: assignmentAlerts,
                  onChanged: (value) {
                    setState(() {
                      assignmentAlerts = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Examination Notifications'),
                  value: examNotifications,
                  onChanged: (value) {
                    setState(() {
                      examNotifications = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Placement Updates'),
                  value: placementUpdates,
                  onChanged: (value) {
                    setState(() {
                      placementUpdates = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Event Announcements'),
                  value: eventAnnouncements,
                  onChanged: (value) {
                    setState(() {
                      eventAnnouncements = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // COURSE CHECKBOXES
          const SectionTitle(
            title: 'Course Preferences',
            icon: Icons.menu_book,
          ),
          Card(
            child: Column(
              children: [
                ...courses.keys.map(
                  (course) => CheckboxListTile(
                    title: Text(course),
                    value: courses[course],
                    onChanged: (value) {
                      setState(() {
                        courses[course] = value ?? false;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Selected Courses: '
                    '${courses.values.where((selected) => selected).length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // DASHBOARD CUSTOMIZATION
          const SectionTitle(
            title: 'Dashboard Customization',
            icon: Icons.dashboard_customize,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard Card Size: '
                    '${(dashboardSize * 100).round()}%',
                  ),
                  Slider(
                    value: dashboardSize,
                    min: 0.8,
                    max: 1.4,
                    divisions: 6,
                    label: '${(dashboardSize * 100).round()}%',
                    onChanged: (value) {
                      setState(() {
                        dashboardSize = value;
                      });
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Show Attendance Card'),
                    value: showAttendance,
                    onChanged: (value) {
                      setState(() {
                        showAttendance = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Show Assignments Card'),
                    value: showAssignments,
                    onChanged: (value) {
                      setState(() {
                        showAssignments = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // LIVE PREVIEW
          const SectionTitle(
            title: 'Dashboard Preview',
            icon: Icons.visibility,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $studentName!',
                    style: TextStyle(
                      fontSize: 18 * dashboardSize,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Semester $selectedSemester • $selectedLanguage'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (showAttendance)
                        PreviewChip(
                          icon: Icons.fact_check,
                          label: 'Attendance',
                          size: dashboardSize,
                        ),
                      if (showAssignments)
                        PreviewChip(
                          icon: Icons.assignment,
                          label: 'Assignments',
                          size: dashboardSize,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Notifications enabled: '
                    '${[
                      assignmentAlerts,
                      examNotifications,
                      placementUpdates,
                      eventAnnouncements,
                    ].where((enabled) => enabled).length} of 4',
                  ),
                  Text(
                    'Selected courses: '
                    '${courses.values.where((selected) => selected).length}',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          Center(
            child: Text(
              'Practical 4 • State Management using setState()',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PreviewChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final double size;

  const PreviewChip({
    super.key,
    required this.icon,
    required this.label,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10 * size),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}
