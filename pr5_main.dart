
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String demoEmail = '24aiml017@charusat.edu.in';
const String demoPassword = 'rushvi@123';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudentCompanionApp());
}

class StudentCompanionApp extends StatefulWidget {
  const StudentCompanionApp({super.key});

  @override
  State<StudentCompanionApp> createState() =>
      _StudentCompanionAppState();
}

class _StudentCompanionAppState extends State<StudentCompanionApp> {
  bool darkMode = false;
  String language = 'English';
  String semester = 'V';
  bool notifications = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      darkMode = prefs.getBool('darkMode') ?? false;
      language = prefs.getString('language') ?? 'English';
      semester = prefs.getString('semester') ?? 'V';
      notifications = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }

    if (!mounted) return;

    setState(() {
      if (key == 'darkMode') darkMode = value as bool;
      if (key == 'language') language = value as String;
      if (key == 'semester') semester = value as String;
      if (key == 'notifications') {
        notifications = value as bool;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Companion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(
        onSettingsChanged: () {
          setState(() {});
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(
              onLogin: () => setState(() {}),
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          return MaterialPageRoute(
            builder: (_) => DashboardScreen(
              onLogout: () => setState(() {}),
            ),
          );
        }

        return null;
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  final VoidCallback onSettingsChanged;

  const SplashScreen({
    super.key,
    required this.onSettingsChanged,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => loggedIn
            ? const DashboardScreen()
            : LoginScreen(
                onLogin: widget.onSettingsChanged,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school,
              size: 80,
              color: Colors.indigo,
            ),
            const SizedBox(height: 20),
            const Text(
              'Student Companion',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text('CHARUSAT • 24AIML017'),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;

  const LoginScreen({
    super.key,
    required this.onLogin,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  bool loading = false;

  Future<void> login() async {
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text;

    if (email == demoEmail && password == demoPassword) {
      setState(() => loading = true);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', 'Rushvi Kathiriya');
      await prefs.setString('email', demoEmail);

      if (!mounted) return;

      widget.onLogin();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password!'),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                const Icon(
                  Icons.school,
                  size: 80,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Student Companion',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text('CHARUSAT Student Login'),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'College Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => login(),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: loading ? null : login,
                    child: Text(loading ? 'Please wait...' : 'Login'),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Demo Login',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const SelectableText(demoEmail),
                const SelectableText(demoPassword),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final VoidCallback? onLogout;

  const DashboardScreen({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    return const StudentHomeShell();
  }
}

class StudentHomeShell extends StatefulWidget {
  const StudentHomeShell({super.key});

  @override
  State<StudentHomeShell> createState() => _StudentHomeShellState();
}

class _StudentHomeShellState extends State<StudentHomeShell> {
  int selectedIndex = 0;

  final pages = const [
    HomePage(),
    AttendancePage(),
    TimetablePage(),
    AssignmentsPage(),
  ];

  final titles = const [
    'Dashboard',
    'Attendance',
    'Timetable',
    'Assignments',
  ];

  void openPage(String page) {
    Navigator.pop(context);

    if (page == 'Profile') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    } else if (page == 'Events') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EventsPage()),
      );
    } else if (page == 'Settings') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SettingsPage()),
      ).then((_) {
        if (mounted) setState(() {});
      });
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('username');
    await prefs.remove('email');

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(onLogin: () {}),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Rushvi Kathiriya'),
              accountEmail: Text('24AIML017 • AIML'),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person, size: 38),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
                setState(() => selectedIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => openPage('Profile'),
            ),
            ListTile(
              leading: const Icon(Icons.event_available),
              title: const Text('Attendance'),
              onTap: () {
                Navigator.pop(context);
                setState(() => selectedIndex = 1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Timetable'),
              onTap: () {
                Navigator.pop(context);
                setState(() => selectedIndex = 2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Assignments'),
              onTap: () {
                Navigator.pop(context);
                setState(() => selectedIndex = 3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.campaign),
              title: const Text('Events'),
              onTap: () => openPage('Events'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => openPage('Settings'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fact_check),
            label: 'Attendance',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'Timetable',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment),
            label: 'Tasks',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'Welcome, Rushvi! 👋',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text('Your student life, all in one place.'),
        const SizedBox(height: 22),
        const Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Attendance',
                value: '85%',
                icon: Icons.fact_check,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                title: 'Semester',
                value: 'V',
                icon: Icons.school,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Assignments',
                value: '4',
                icon: Icons.assignment,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                title: 'Events',
                value: '2',
                icon: Icons.event,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Upcoming Activities',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.assignment, color: Colors.indigo),
            title: Text('Machine Learning Assignment'),
            subtitle: Text('Due: Friday'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.event, color: Colors.deepOrange),
            title: Text('Technical Event'),
            subtitle: Text('Next week'),
          ),
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.indigo),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = [
      ['Machine Learning', '90%'],
      ['Advanced Web Development', '85%'],
      ['Data Structures', '82%'],
      ['Database Management', '88%'],
      ['Software Engineering', '80%'],
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Attendance Overview',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...subjects.map(
          (subject) => Card(
            child: ListTile(
              leading: const Icon(Icons.menu_book),
              title: Text(subject[0]),
              trailing: Text(
                subject[1],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text('Note: Attendance values are sample data.'),
      ],
    );
  }
}

class TimetablePage extends StatelessWidget {
  const TimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final classes = [
      ['09:00 AM', 'Machine Learning', 'Room 201'],
      ['10:00 AM', 'Data Structures', 'Room 105'],
      ['11:00 AM', 'Advanced Web Development', 'Lab 2'],
      ['01:00 PM', 'Database Management', 'Room 202'],
      ['02:00 PM', 'Software Engineering', 'Room 106'],
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Today’s Timetable',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...classes.map(
          (item) => Card(
            child: ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(item[1]),
              subtitle: Text(item[2]),
              trailing: Text(item[0]),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text('Note: Timetable is sample data.'),
      ],
    );
  }
}

class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final assignments = [
      ['Machine Learning', 'Prepare model evaluation report', 'Pending'],
      ['Advanced Web Development', 'Complete REST API practical', 'Pending'],
      ['Data Structures', 'Solve linked list questions', 'Completed'],
      ['Database Management', 'Submit SQL exercises', 'Pending'],
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'My Assignments',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...assignments.map(
          (item) => Card(
            child: ListTile(
              leading: Icon(
                item[2] == 'Completed'
                    ? Icons.check_circle
                    : Icons.assignment,
                color: item[2] == 'Completed' ? Colors.green : Colors.indigo,
              ),
              title: Text(item[0]),
              subtitle: Text(item[1]),
              trailing: Text(item[2]),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          CircleAvatar(
            radius: 48,
            child: Icon(Icons.person, size: 55),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Rushvi Kathiriya',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: Icon(Icons.badge),
              title: Text('Student ID'),
              subtitle: Text('24AIML017'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.school),
              title: Text('Branch'),
              subtitle: Text('Artificial Intelligence and Machine Learning'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.email),
              title: Text('College Email'),
              subtitle: Text(demoEmail),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Semester'),
              subtitle: Text('V'),
            ),
          ),
        ],
      ),
    );
  }
}

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final events = [
      ['Technical Fest', 'College auditorium'],
      ['AI/ML Workshop', 'Computer Lab'],
      ['Coding Competition', 'Department'],
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('College Events')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: events
            .map(
              (event) => Card(
                child: ListTile(
                  leading: const Icon(Icons.event, color: Colors.indigo),
                  title: Text(event[0]),
                  subtitle: Text(event[1]),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  bool notifications = true;
  String language = 'English';
  String semester = 'V';
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      darkMode = prefs.getBool('darkMode') ?? false;
      notifications = prefs.getBool('notifications') ?? true;
      language = prefs.getString('language') ?? 'English';
      semester = prefs.getString('semester') ?? 'V';
      loaded = true;
    });
  }

  Future<void> updatePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }

    if (!mounted) return;

    setState(() {
      if (key == 'darkMode') darkMode = value as bool;
      if (key == 'notifications') notifications = value as bool;
      if (key == 'language') language = value as String;
      if (key == 'semester') semester = value as String;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: !loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode),
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Save your theme preference'),
                  value: darkMode,
                  onChanged: (value) =>
                      updatePreference('darkMode', value),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  value: notifications,
                  onChanged: (value) =>
                      updatePreference('notifications', value),
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  subtitle: Text(language),
                  trailing: DropdownButton<String>(
                    value: language,
                    items: const [
                      DropdownMenuItem(
                        value: 'English',
                        child: Text('English'),
                      ),
                      DropdownMenuItem(
                        value: 'Hindi',
                        child: Text('Hindi'),
                      ),
                      DropdownMenuItem(
                        value: 'Gujarati',
                        child: Text('Gujarati'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        updatePreference('language', value);
                      }
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.school),
                  title: const Text('Semester'),
                  subtitle: Text('Semester $semester'),
                  trailing: DropdownButton<String>(
                    value: semester,
                    items: const [
                      DropdownMenuItem(value: 'I', child: Text('I')),
                      DropdownMenuItem(value: 'II', child: Text('II')),
                      DropdownMenuItem(value: 'III', child: Text('III')),
                      DropdownMenuItem(value: 'IV', child: Text('IV')),
                      DropdownMenuItem(value: 'V', child: Text('V')),
                      DropdownMenuItem(value: 'VI', child: Text('VI')),
                      DropdownMenuItem(value: 'VII', child: Text('VII')),
                      DropdownMenuItem(value: 'VIII', child: Text('VIII')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        updatePreference('semester', value);
                      }
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Preferences are stored locally using SharedPreferences.',
                  ),
                ),
              ],
            ),
    );
  }
}
