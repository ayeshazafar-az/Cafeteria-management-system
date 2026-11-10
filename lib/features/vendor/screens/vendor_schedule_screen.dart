import 'package:flutter/material.dart';

class DaySchedule {
  final String dayName;
  bool isOpen;
  TimeOfDay openTime;
  TimeOfDay closeTime;

  DaySchedule({
    required this.dayName,
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
  });
}

class VendorScheduleScreen extends StatefulWidget {
  const VendorScheduleScreen({super.key});

  @override
  State<VendorScheduleScreen> createState() => _VendorScheduleScreenState();
}

class _VendorScheduleScreenState extends State<VendorScheduleScreen> {
  bool _autoCloseSchedule = true;
  bool _isManualOverrideClosed = false;
  int _defaultPrepMinutes = 15;

  final List<DaySchedule> _schedules = [
    DaySchedule(
      dayName: 'Monday',
      isOpen: true,
      openTime: const TimeOfDay(hour: 8, minute: 0),
      closeTime: const TimeOfDay(hour: 17, minute: 0),
    ),
    DaySchedule(
      dayName: 'Tuesday',
      isOpen: true,
      openTime: const TimeOfDay(hour: 8, minute: 0),
      closeTime: const TimeOfDay(hour: 17, minute: 0),
    ),
    DaySchedule(
      dayName: 'Wednesday',
      isOpen: true,
      openTime: const TimeOfDay(hour: 8, minute: 0),
      closeTime: const TimeOfDay(hour: 17, minute: 0),
    ),
    DaySchedule(
      dayName: 'Thursday',
      isOpen: true,
      openTime: const TimeOfDay(hour: 8, minute: 0),
      closeTime: const TimeOfDay(hour: 17, minute: 0),
    ),
    DaySchedule(
      dayName: 'Friday',
      isOpen: true,
      openTime: const TimeOfDay(hour: 8, minute: 0),
      closeTime: const TimeOfDay(hour: 16, minute: 30),
    ),
    DaySchedule(
      dayName: 'Saturday',
      isOpen: false,
      openTime: const TimeOfDay(hour: 9, minute: 0),
      closeTime: const TimeOfDay(hour: 14, minute: 0),
    ),
    DaySchedule(
      dayName: 'Sunday',
      isOpen: false,
      openTime: const TimeOfDay(hour: 9, minute: 0),
      closeTime: const TimeOfDay(hour: 14, minute: 0),
    ),
  ];

  Future<void> _pickTime(
    BuildContext context,
    DaySchedule schedule,
    bool isOpenTime,
  ) async {
    final initialTime = isOpenTime ? schedule.openTime : schedule.closeTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        if (isOpenTime) {
          schedule.openTime = picked;
        } else {
          schedule.closeTime = picked;
        }
      });
    }
  }

  void _saveSchedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('Stall operating hours & prep defaults saved!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Operating Hours & Schedule')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Master Operational Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stall Control Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(
                        Icons.schedule_send_rounded,
                        color: Colors.blue,
                      ),
                      title: const Text('Automatic Schedule Enforcement'),
                      subtitle: const Text(
                        'Auto-open/close stall on student app based on set hours',
                      ),
                      value: _autoCloseSchedule,
                      onChanged: (val) {
                        setState(() => _autoCloseSchedule = val);
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(
                        Icons.power_settings_new_rounded,
                        color: Colors.red,
                      ),
                      title: const Text('Emergency Emergency Close'),
                      subtitle: const Text(
                        'Instantly mark stall as CLOSED regardless of schedule',
                      ),
                      value: _isManualOverrideClosed,
                      onChanged: (val) {
                        setState(() => _isManualOverrideClosed = val);
                      },
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Default Preparation Time',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Used for live countdown timers',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: _defaultPrepMinutes > 5
                                  ? () =>
                                        setState(() => _defaultPrepMinutes -= 5)
                                  : null,
                            ),
                            Text(
                              '$_defaultPrepMinutes m',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: _defaultPrepMinutes < 60
                                  ? () =>
                                        setState(() => _defaultPrepMinutes += 5)
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Weekly Operating Hours',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Set opening and closing times for each campus day.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),

            // Weekly Schedule List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _schedules.length,
              itemBuilder: (context, index) {
                final day = _schedules[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Switch(
                                  value: day.isOpen,
                                  onChanged: (val) {
                                    setState(() => day.isOpen = val);
                                  },
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  day.dayName,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: day.isOpen
                                        ? Theme.of(
                                            context,
                                          ).textTheme.bodyLarge?.color
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: day.isOpen
                                    ? Colors.green.shade50
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                day.isOpen ? 'OPEN' : 'CLOSED',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: day.isOpen
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (day.isOpen) ...[
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () => _pickTime(context, day, true),
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Opens At',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 16,
                                            color: primaryColor,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            day.openTime.format(context),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Text(
                                'to',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                onTap: () => _pickTime(context, day, false),
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Closes At',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_filled,
                                            size: 16,
                                            color: primaryColor,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            day.closeTime.format(context),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveSchedule,
                icon: const Icon(Icons.save_rounded, size: 20),
                label: const Text(
                  'Save Operating Hours',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
