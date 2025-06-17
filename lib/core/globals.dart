import 'package:flutter/material.dart';

// متغير عشان نعرف احنا في شات انهي واحد
String? currentlyOpenedChatId;

// navigatorKey عشان نتحكم في الـ navigation من أي حتة
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
