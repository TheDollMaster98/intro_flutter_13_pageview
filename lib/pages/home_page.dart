import 'package:flutter/material.dart';
import 'package:intro_flutter_13_pageview/model/splash_page_model.dart';

// HomePage è un widget senza stato che restituisce un oggetto Scaffold.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // specifico che la pagina iniziale sia la 1
  // 'pageController' è un'istanza di PageController
  // che gestisce la navigazione tra le pagine e inizia dalla pagina 0.
  // funge come una sorta di telecomando per controllare la pageView.
  final PageController PageViewController = PageController(initialPage: 0);
  int currentPageIndex = 0;

  void onPageChanged(int index) {
    setState(() {
      this.currentPageIndex = index;
    });
  }

  //concetto di controller in flutter:
  void onIndicatorPressed(int indicatorIndexPressed) {
    //jumptopage:
    // passo l'indice della pagina a cui voglio andare
    PageViewController.animateToPage(
      indicatorIndexPressed,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: body()));
  }

// pageView:
// è l'equivalente del carosello.

//v1:
// Widget body() => PageView(
//       children: List.generate(
//         splashPages.length,
//         (index) => SplashScreen(splashPages[index]),
//       ),
//     );

//v2 con builder ottimizzato.
// i pallini dinamici fissi che non si muovono.
// Stack permette di sovrapporre più widget.
  Widget body() => Stack(
        children: [
          // PageView.builder crea una scorrimento orizzontale di pagine.
          PageView.builder(
            // Il 'controller' in PageView gestisce la navigazione
            // tra le pagine e fornisce informazioni sulla pagina corrente.
            controller: PageViewController,
            //mi sto mettendo in ascolto delle pagine che cambiano
            // corrisponde alla pagina attuale:
            onPageChanged: onPageChanged,
            // itemCount definisce il numero di pagine.
            itemCount: splashPages.length,
            // itemBuilder costruisce ciascuna pagina.
            itemBuilder: (context, index) => SplashScreen(splashPages[index]),
          ),
          // Positioned permette di posizionare un widget all'interno di Stack.
          Positioned(
            // bottom, left e right posizionano il widget PageViewIndicators.
            bottom: 10,
            left: 0,
            right: 0,
            // SafeArea mantiene il widget all'interno dell'area utilizzabile.
            child: SafeArea(
              child: PageViewIndicators(
                // index della pagina
                pageViewIndex: currentPageIndex,
                onIndicatorPressed: onIndicatorPressed,
              ),
            ),
          ),
        ],
      );
}

// SplashScreen è un widget senza stato che restituisce un Container.
class SplashScreen extends StatelessWidget {
  final SplashPageModel splashPageModel;
  const SplashScreen(this.splashPageModel, {super.key});

  @override
  Widget build(BuildContext context) {
    // Container è un box che contiene altri widget.
    return Container(
      padding: const EdgeInsets.all(16),
      // BoxDecoration fornisce una serie di modi per dipingere un box.
      decoration: BoxDecoration(color: splashPageModel.backgroundColor),
      child: SafeArea(
        child: Column(
          // mainAxisAlignment posiziona i figli lungo l'asse verticale.
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Text mostra una stringa di testo con stile.
            Text(
              splashPageModel.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            // SizedBox crea uno spazio vuoto.
            const SizedBox(height: 10),
            Text(
              splashPageModel.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// PageViewIndicators è un widget senza stato che restituisce una Row.
class PageViewIndicators extends StatelessWidget {
  final int pageViewIndex;
  //index sarà l'indice del pallino cliccato!
  final void Function(int index) onIndicatorPressed;

  const PageViewIndicators({
    super.key,
    required this.pageViewIndex,
    required this.onIndicatorPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Row è un widget che visualizza i suoi figli in una riga orizzontale.
    return Row(
      // mainAxisAlignment posiziona i figli lungo l'asse orizzontale.
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        splashPages.length,
        // Container è un box che contiene un widget.
        //vado a comandare la pageview con GestureDetector
        // che mi aiuta a
        (index) => GestureDetector(
          onTap: () => onIndicatorPressed(index),
          child: Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            // BoxDecoration fornisce una serie di modi per dipingere un box.
            decoration: BoxDecoration(
              color: index == pageViewIndex ? Colors.white : Colors.white54,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
