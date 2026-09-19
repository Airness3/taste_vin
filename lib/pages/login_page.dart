import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  bool isCreateMode = true;

  final _createFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();

  final _createEmailController = TextEditingController();
  final _createPasswordController = TextEditingController();
  final _createPseudoController = TextEditingController();
  final _createBioController = TextEditingController();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _cardOpacity;
  late Animation<Offset> _cardOffset;

  static const String _defaultAvatarUrl =
      'https://your-cdn-or-bucket/avatar_default.png';

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutBack,
      ),
    );

    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _cardOffset = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _logoController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _createEmailController.dispose();
    _createPasswordController.dispose();
    _createPseudoController.dispose();
    _createBioController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // 🔥 FONCTION : CRÉATION DE COMPTE
  // ------------------------------------------------------------
  Future<void> _handleSignup() async {
    if (!_createFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _createEmailController.text.trim();
    final password = _createPasswordController.text.trim();
    final pseudo = _createPseudoController.text.trim();
    final bio = _createBioController.text.trim();

    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'pseudo': pseudo,
        'bio': bio,
        'avatar_url': _defaultAvatarUrl,
      },
    );

    if (response.user == null) {
      setState(() {
        _errorMessage = "Impossible de créer le compte.";
        _isLoading = false;
      });
      return;
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // ------------------------------------------------------------
  // 🔥 FONCTION : CONNEXION
  // ------------------------------------------------------------
  Future<void> _handleLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _loginEmailController.text.trim();
    final password = _loginPasswordController.text.trim();

    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.session == null) {
      setState(() {
        _errorMessage = "Email ou mot de passe incorrect.";
        _isLoading = false;
      });
      return;
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // ------------------------------------------------------------
  // UI & DESIGN TasteVin (inchangé)
  // ------------------------------------------------------------

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontFamily: 'Montserrat',
        color: Color(0xFFD45A1F),
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: Colors.black.withOpacity(0.35),
      hintStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFC0C0C0),
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFD45A1F),
          width: 1.6,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
    );
  }

  Widget _buildToggleButtons() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFFC0C0C0),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isCreateMode = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isCreateMode
                      ? const Color(0xFFD45A1F)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Center(
                  child: Text(
                    'Créer son compte',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: isCreateMode
                          ? Colors.black
                          : const Color(0xFFC0C0C0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isCreateMode = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isCreateMode
                      ? const Color(0xFFD45A1F)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Center(
                  child: Text(
                    'Connexion',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: !isCreateMode
                          ? Colors.black
                          : const Color(0xFFC0C0C0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateForm() {
    return Form(
      key: _createFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _createEmailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Adresse e‑mail'),
            validator: (value) =>
                value == null || value.trim().isEmpty
                    ? 'Veuillez saisir une adresse e‑mail.'
                    : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _createPasswordController,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Mot de passe'),
            validator: (value) =>
                value == null || value.trim().length < 6
                    ? 'Mot de passe trop court (min. 6 caractères).'
                    : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _createPseudoController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Pseudo'),
            validator: (value) =>
                value == null || value.trim().isEmpty
                    ? 'Veuillez choisir un pseudo.'
                    : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _createBioController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Bio (optionnelle)'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleSignup,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC0C0C0),
              foregroundColor: const Color(0xFF0A1F1A),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 4,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF0A1F1A),
                      ),
                    ),
                  )
                : const Text(
                    'Créer son compte',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _loginEmailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Adresse e‑mail'),
            validator: (value) =>
                value == null || value.trim().isEmpty
                    ? 'Veuillez saisir une adresse e‑mail.'
                    : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _loginPasswordController,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Mot de passe'),
            validator: (value) =>
                value == null || value.trim().isEmpty
                    ? 'Veuillez saisir votre mot de passe.'
                    : null,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC0C0C0),
              foregroundColor: const Color(0xFF0A1F1A),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 4,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF0A1F1A),
                      ),
                    ),
                  )
                : const Text(
                    'Connexion',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF14533A),
              Color(0xFF0F3F2E),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _logoScale,
                    child: Column(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/images/icone_profil.png',
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Démarrez l’expérience Taste Vin',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFF4F4F4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  FadeTransition(
                    opacity: _cardOpacity,
                    child: SlideTransition(
                      position: _cardOffset,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/bois_chene_vieilli.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Color(0xFFC0C0C0),
                            width: 1.4,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildToggleButtons(),
                            const SizedBox(height: 20),

                            if (_errorMessage != null) ...[
                              Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Color(0xFFA32020),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],

                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: isCreateMode
                                  ? _buildCreateForm()
                                  : _buildLoginForm(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
