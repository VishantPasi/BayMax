import 'package:baymax/screens/login/initial_login_screen.dart';
import 'package:baymax/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:baymax/providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, required this.accessToken});

  final String accessToken;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  static const Color backgroundColor = Color(0xFF0D0D0D);

  static const Color cardColor = Color(0xFF171717);

  static const Color accentColor = Color.fromARGB(255, 255, 198, 75);

  static const Color secondaryText = Color(0xFF9E9E9E);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(profileProvider.notifier).loadProfile(token: widget.accessToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),

        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: profileState.when(
        // --------------------------------------------------
        // LOADING
        // --------------------------------------------------
        loading: () {
          return const Center(
            child: CircularProgressIndicator(color: accentColor),
          );
        },

        // --------------------------------------------------
        // ERROR
        // --------------------------------------------------
        error: (error, stackTrace) {
          return _buildErrorState(error.toString());
        },

        // --------------------------------------------------
        // DATA
        // --------------------------------------------------
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text(
                "Unable to load profile",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return RefreshIndicator(
            color: accentColor,

            backgroundColor: cardColor,

            onRefresh: () async {
              await ref
                  .read(profileProvider.notifier)
                  .refreshProfile(token: widget.accessToken);
            },

            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

              child: Column(
                children: [
                  // PROFILE HEADER
                  _buildProfileHeader(name: user.name, email: user.email),

                  const SizedBox(height: 30),

                  // ACCOUNT
                  _sectionTitle("ACCOUNT"),

                  const SizedBox(height: 10),

                  _buildAccountCard(
                    name: user.name,
                    email: user.email,
                    authProvider: user.authProvider,
                  ),

                  const SizedBox(height: 30),

                  // LOGOUT
                  _buildLogoutButton(),

                  const SizedBox(height: 20),

                  const Text(
                    "BayMax",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Version 1.0.0",
                    style: TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildProfileHeader({String? name, String? email}) {
    final displayName = name?.trim().isNotEmpty == true ? name!.trim() : "User";

    final emailText = email?.trim().isNotEmpty == true
        ? email!.trim()
        : "No email";

    return Column(
      children: [
        // ------------------------------------------------------
        // INITIAL AVATAR
        // ------------------------------------------------------
        Container(
          width: 108,
          height: 108,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: accentColor.withOpacity(0.10),

            border: Border.all(color: accentColor, width: 2),

            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.15),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),

          child: Center(
            child: Text(
              _getInitial(displayName),

              style: const TextStyle(
                color: accentColor,
                fontSize: 44,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          displayName,

          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          emailText,

          style: const TextStyle(color: secondaryText, fontSize: 14),
        ),
      ],
    );
  }

  // ============================================================
  // INITIAL
  // ============================================================

  String _getInitial(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return "?";
    }

    return trimmedName
        .split(RegExp(r'\s+'))
        .first
        .substring(0, 1)
        .toUpperCase();
  }

  // ============================================================
  // ACCOUNT CARD
  // ============================================================

  Widget _buildAccountCard({
    String? name,
    String? email,
    String? authProvider,
  }) {
    return _card(
      children: [
        _infoTile(
          icon: Icons.person_outline_rounded,
          title: "Full Name",
          value: name?.isNotEmpty == true ? name! : "Not available",
        ),

        _divider(),

        _infoTile(
          icon: Icons.email_outlined,
          title: "Email",
          value: email?.isNotEmpty == true ? email! : "Not available",
        ),

        _divider(),

        _infoTile(
          icon: Icons.login_rounded,
          title: "Authentication",
          value: _formatAuthProvider(authProvider),
        ),
      ],
    );
  }

  // ============================================================
  // AUTH PROVIDER
  // ============================================================

  String _formatAuthProvider(String? provider) {
    if (provider == null || provider.trim().isEmpty) {
      return "Unknown";
    }

    switch (provider.toLowerCase()) {
      case "google":
        return "Google";

      case "email":
        return "Email";

      case "password":
        return "Email";

      default:
        return provider;
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,

      child: OutlinedButton.icon(
        onPressed: () {
          _showLogoutDialog();
        },

        icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),

        label: const Text(
          "Log Out",
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),

        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOGOUT DIALOG
  // ============================================================

  void _showLogoutDialog() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          backgroundColor: cardColor,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text("Log Out?", style: TextStyle(color: Colors.white)),

          content: const Text(
            "Are you sure you want to log out?",
            style: TextStyle(color: secondaryText),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white70),
              ),
            ),

            TextButton(
              onPressed: () async {
                // Close the logout confirmation dialog
                Navigator.pop(context);

                // Clear token and all stored login data
                await SecureStorageService.clearStorageData();

                // Go to login screen and remove all previous screens
                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InitialLoginScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text(
                "Log Out",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 50,
            ),

            const SizedBox(height: 16),

            const Text(
              "Unable to load profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              error,
              textAlign: TextAlign.center,

              style: const TextStyle(color: secondaryText, fontSize: 13),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                ref
                    .read(profileProvider.notifier)
                    .loadProfile(token: widget.accessToken);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.black,
              ),

              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CARD
  // ============================================================

  Widget _card({required List<Widget> children}) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),

      child: Column(children: children),
    );
  }

  // ============================================================
  // INFO TILE
  // ============================================================

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.10),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: accentColor, size: 21),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(color: secondaryText, fontSize: 12),
                ),

                const SizedBox(height: 4),

                Text(
                  value,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTION TILE
  // ============================================================

  Widget _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.10),

                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(icon, color: accentColor, size: 21),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const Icon(Icons.chevron_right_rounded, color: Colors.white38),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,

      child: Text(
        title,

        style: const TextStyle(
          color: secondaryText,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.3,
        ),
      ),
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _divider() {
    return Divider(
      height: 1,
      indent: 72,

      color: Colors.white.withOpacity(0.05),
    );
  }
}
