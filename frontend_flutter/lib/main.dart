import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Recommender',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0F1A),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();

  List movies = [];
  bool isLoading = false;
  Timer? debounce;

  final List trending = [
    "Interstellar",
    "Inception",
    "The Dark Knight",
    "Tenet",
    "Avengers",
  ];

  Future<void> fetchMovies(String movie) async {
    if (movie.trim().isEmpty) {
      setState(() => movies = []);
      return;
    }

    setState(() => isLoading = true);

    try {
      final url = Uri.parse(
        "http://127.0.0.1:8000/recommend?movie=${Uri.encodeComponent(movie)}",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          movies = List.from(json.decode(response.body));
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void onSearchChanged(String value) {
    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(const Duration(milliseconds: 400), () {
      fetchMovies(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌌 Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0B0F1A),
                  Color(0xFF111827),
                  Color(0xFF0B0F1A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                const SizedBox(height: 20),

                const Text(
                  "🎬 Movie Recommender",
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                // 🔍 Search
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: TextField(
                    controller: controller,
                    onChanged: onSearchChanged,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Search movies...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // 🔥 TRENDING CAROUSEL
                if (controller.text.isEmpty) ...[
                  const Text(
                    "🔥 Trending",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 230,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: trending.length,
                      itemBuilder: (context, index) {
                        final movie = trending[index];
                        return GestureDetector(
                          onTap: () {
                            controller.text = movie;
                            fetchMovies(movie);
                          },
                          child: TrendingPoster(title: movie),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                ],

                // 🎬 NETFLIX STYLE CAROUSEL (from API)
                if (movies.isNotEmpty && controller.text.isEmpty) ...[
                  const Text(
                    "🍿 Recommended",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 230,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        return PosterCard(movie: movies[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                if (isLoading)
                  const Center(child: CircularProgressIndicator()),

                if (!isLoading &&
                    movies.isEmpty &&
                    controller.text.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No results"),
                  ),

                // 🎬 LIST RESULTS
                if (movies.isNotEmpty && controller.text.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      return HoverCard(movie: movies[index]);
                    },
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🔥 TRENDING POSTER (NETFLIX STYLE)
class TrendingPoster extends StatefulWidget {
  final String title;

  const TrendingPoster({super.key, required this.title});

  @override
  State<TrendingPoster> createState() => _TrendingPosterState();
}

class _TrendingPosterState extends State<TrendingPoster> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        transform: Matrix4.identity()..scale(hover ? 1.08 : 1),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent.withOpacity(0.5),
              Colors.purpleAccent.withOpacity(0.5),
            ],
          ),
        ),
        child: Center(
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// 🎬 POSTER CARD (REAL POSTER)
class PosterCard extends StatefulWidget {
  final dynamic movie;

  const PosterCard({super.key, required this.movie});

  @override
  State<PosterCard> createState() => _PosterCardState();
}

class _PosterCardState extends State<PosterCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.movie;

    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        transform: Matrix4.identity()..scale(hover ? 1.08 : 1),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            m["poster"] ?? "",
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => fallbackPoster(),
          ),
        ),
      ),
    );
  }

  Widget fallbackPoster() {
    return Container(
      color: Colors.grey,
      child: const Icon(Icons.movie),
    );
  }
}

// 🎬 LIST CARD
class HoverCard extends StatefulWidget {
  final dynamic movie;

  const HoverCard({super.key, required this.movie});

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.movie;

    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 10),
        transform: Matrix4.identity()..scale(isHover ? 1.03 : 1),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.05),
          border: Border.all(
            color: isHover ? Colors.blueAccent : Colors.white10,
          ),
        ),

        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(20)),
              child: Image.network(
                m["poster"] ?? "",
                width: 120,
                height: 170,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => fallbackPoster(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m["title"] ?? "",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "⭐ ${m["rating"] ?? "N/A"}",
                      style: const TextStyle(color: Colors.amber),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      m["overview"] ?? "",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget fallbackPoster() {
    return Container(
      width: 120,
      height: 170,
      color: Colors.grey,
      child: const Icon(Icons.movie, size: 40),
    );
  }
}