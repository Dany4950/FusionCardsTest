enum MScreenType {
  dashboard('Dashboard', 'assets/images/dashboard.png', 0),
  efficiency('Efficiency', 'assets/images/emp_eff.png', 1),
  kitchen('Kitchen', 'assets/images/safety.png', 2),
  people('People', 'assets/images/people_count.png', 3),
  theft('Theft', 'assets/images/theft.png', 4),
  heatMap('Heatmap', 'assets/images/heat_map.png', 5),
  video('Video', 'assets/images/video.png', 6),
  live('Live', 'assets/icon/live_icon.png', 7);

  final String title;
  final String iconPath;
  final int pos;

  const MScreenType(this.title, this.iconPath, this.pos);

  static List<MScreenType> bottomNavScreens() => [
        dashboard,
        efficiency,
        kitchen,
        people,
        theft,
        heatMap,
      ];
}
