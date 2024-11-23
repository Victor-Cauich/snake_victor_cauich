import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para construir interfaces de usuario.
import 'dart:async'; // Importa la biblioteca para trabajar con temporizadores y operaciones asincrónicas.
import 'dart:math'; // Importa la biblioteca para cálculos matemáticos y generación de números aleatorios.

void main() {runApp(const MyApp()); // Inicia la aplicación Flutter con `MyApp` como widget raíz.
}

class MyApp extends StatelessWidget { // Definición de la clase MyApp que es un widget sin estado.
  const MyApp({super.key}); // Constructor constante de la clase MyApp
  @override
  Widget build(BuildContext context) { // Método que define la interfaz del widget.
    return MaterialApp( // Devuelve un widget `MaterialApp` que contiene la estructura básica de la app.
      debugShowCheckedModeBanner: false, // Oculta el banner de depuración.
      home: HomePage(), // Establece `HomePage` como la pantalla inicial de la aplicación.
    );
  }
}

class HomePage extends StatefulWidget { // Define el widget `HomePage` que tiene un estado mutable.
  const HomePage({super.key}); // Constructor constante de la clase `HomePage`.
  @override
  _HomePageState createState() => _HomePageState(); // Crea el estado asociado a `HomePage`.
}

class _HomePageState extends State<HomePage> { // Clase que define el estado dinámico de `HomePage`.
  static List<int> snakePosition = [45, 65, 85, 105, 125]; // Posiciones iniciales de la serpiente en la cuadrícula.
  int numberOfSquares = 760; // Número total de casillas en la cuadrícula (20 columnas x 38 filas).
  static var randomNumber = Random(); // Crea un generador de números aleatorios.
  int food = randomNumber.nextInt(700); // Genera una posición aleatoria inicial para la comida.

  void generateNewFood() {  // metodo para generar la comida
    food = randomNumber.nextInt(700); // Cambia la posición de la comida a una nueva posición aleatoria.
  }

  void startGame() { // metodo para comenzar el juego
    snakePosition = [45, 65, 85, 105, 125]; // Restablece las posiciones iniciales de la serpiente.
    const duration = Duration(milliseconds: 300); // Velocidad de la serpiente
    Timer.periodic(duration, (Timer timer) { // Ejecuta una acción repetida con un intervalo definido.
      updateSnake(); // Actualiza la posición de la serpiente.
      if (gameOver()) {  // si el juego termino
        timer.cancel(); // Detiene el temporizador si el juego ha terminado.
        _showGameOverScreen(); // Muestra un mensaje de "Game Over".
      }
    });
  }

  var direction = "down"; // Dirección inicial de la serpiente.
  void updateSnake() { // metodo para actualizar la direccion de la serpiente
    setState(() { // Actualiza el estado del widget.
      switch (direction) { // Cambia la dirección de la serpiente según el movimiento del usuario.
        case "down": // caso abajo
          if (snakePosition.last > 740) { // Si llega al borde inferior,
            snakePosition.add(snakePosition.last + 20 - 760); // reaparece arriba.
          } else { // si no
            snakePosition.add(snakePosition.last + 20); // Se mueve hacia abajo.
          }
          break; // Fin del caso abajo
        case "up": // caso arriba
          if (snakePosition.last < 20) { // Si llega al borde superior
            snakePosition.add(snakePosition.last - 20 + 760); // reaparece abajo.
          } else { // si no
            snakePosition.add(snakePosition.last - 20); // Se mueve hacia arriba.
          }
          break;// Fin del caso arriba
        case "left": //caso izquierda
          if (snakePosition.last % 20 == 0) { // Si llega al borde izquierdo
            snakePosition.add(snakePosition.last - 1 + 20); // reaparece en el lado derecho.
          } else { // si no
            snakePosition.add(snakePosition.last - 1); // Se mueve hacia la izquierda.
          }
          break; // Fin del caso izquierda
        case "right": // caso derecha
          if ((snakePosition.last + 1) % 20 == 0) { // Si llega al borde derecho
            snakePosition.add(snakePosition.last + 1 - 20); // reaparece en el izquierdo.
          } else { // si no
            snakePosition.add(snakePosition.last + 1); // Se mueve hacia la derecha.
          }
          break; // Fin del caso derecha
      }

      if (snakePosition.last == food) { // Si la serpiente come la comida
        generateNewFood(); // genera nueva comida.
      } else { // si no come
        snakePosition.removeAt(0); // elimina el último segmento para simular el movimiento.
      }
    });
  }

  bool gameOver() { // Método que verifica si el juego ha terminado.
    for (int i = 0; i < snakePosition.length; i++) { // Itera a través de todas las posiciones de la serpiente.
      int count = 0; // Cuenta las veces que una posición aparece en la serpiente.
      for (int j = 0; j < snakePosition.length; j++) { // Itera nuevamente para comparar la posición actual con todas las demás posiciones de la serpiente.
        if (snakePosition[i] == snakePosition[j]) { // Si la posición actual (i) es igual a alguna otra posición (j)
          count += 1; // Incrementa el contador si hay una coincidencia.
        }
        if (count == 2) { // Si una posición aparece dos veces,
          return true; // el juego termina.
        }
      }
    }
    return false; // Si no hay colisiones, el juego continúa.
  }

  void _showGameOverScreen() {// Método que muestra el cuadro de diálogo de "Game Over" cuando el juego termina.
    showDialog( // Llama a la función `showDialog` para mostrar un cuadro de diálogo en la pantalla.
      context: context, // Muestra un cuadro de diálogo.
      builder: (BuildContext context) { // El builder crea el contenido del cuadro de diálogo.
        return AlertDialog( // Devuelve un cuadro de diálogo
          title: Text("Game Over"), // Título del cuadro de diálogo.
          content: Text("Your score: " + snakePosition.length.toString()), // Muestra la puntuación del jugador.
          actions: <Widget>[ // Define las acciones que pueden tomarse desde el cuadro de diálogo.
            FloatingActionButton( // Un botón flotante que sirve para reiniciar el juego.
              child: Text("Play Again"), // Botón para reiniciar el juego.
              onPressed: () { // Acción que se ejecuta cuando el botón es presionado.
                startGame(); // Reinicia el juego.
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo.
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) { // Método que construye la interfaz del widget.
    return Scaffold( // Crea una estructura básica para la pantalla con una AppBar
      backgroundColor: Colors.black, // Fondo negro de la interfaz principal.
      body: Column( // Organiza los elementos dentro del cuerpo de la interfaz en una columna vertical.
        children: <Widget>[
          Expanded( // Expande el widget para que ocupe todo el espacio disponible.
            child: GestureDetector( // Detecta gestos del usuario.
              onVerticalDragUpdate: (details) { // Detecta el movimiento vertical del dedo del usuario.
                if (direction != "up" && details.delta.dy > 0) {  // Si la dirección actual no es "arriba" y el movimiento es hacia abajo
                  direction = "down"; // Cambia la dirección de la serpiente a "abajo".
                } else if (direction != "down" && details.delta.dy < 0) { // Si la dirección actual no es "abajo" y el movimiento es hacia arriba
                  direction = "up"; // Cambia la dirección de la serpiente a "arriba"
                }
              },
              onHorizontalDragUpdate: (details) { // Detecta el movimiento horizontal del dedo del usuario.
                if (direction != "left" && details.delta.dx > 0) { // Si la dirección actual no es "izquierda" y el movimiento es hacia la derecha
                  direction = "right"; // Cambia la dirección de la serpiente a "derecha".
                } else if (direction != "right" && details.delta.dx < 0) { // Si la dirección actual no es "derecha" y el movimiento es hacia la izquierda
                  direction = "left"; // Cambia la dirección de la serpiente a "izquierda". 
                }
              },
              child: Container( // Crea un contenedor que envuelve el GridView.
                child: GridView.builder( // Crea una cuadrícula (grid) con un número dinámico de elementos.
                  physics: NeverScrollableScrollPhysics(), // Desactiva el desplazamiento.
                  itemCount: numberOfSquares, // Número total de casillas en la cuadrícula.
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( // Define cómo se organizarán los elementos en la cuadrícula.
                    crossAxisCount: 20), // Divide la cuadrícula en 20 columnas.
                  itemBuilder: (BuildContext context, int index) {// Constructor de elementos de la cuadrícula, que construye cada casilla.
                    if (snakePosition.contains(index)) { // Verifica si la posición actual es parte de la serpiente.
                      return Center( // Centra el contenido de la casilla.
                        child: Container( // Crea un contenedor para representar una parte de la serpiente.
                          padding: EdgeInsets.all(2), // Margen interno de la casilla.
                          child: ClipRRect( // Crea un contenedor con bordes redondeados.
                            borderRadius: BorderRadius.circular(2), // Esquinas redondeadas.
                            child: Container( // Contenedor interno que representa una parte de la serpiente.
                              color: Colors.white, // Dibuja una casilla blanca para la serpiente.
                            ),
                          ),
                        ),
                      );
                    }
                    if (index == food) { // Comprueba si el índice actual coincide con la posición de la comida.
                      return Container( // Devuelve un contenedor que representa la comida.
                        padding: EdgeInsets.all(2), // Aplica un margen interno de 2 píxeles.
                        child: ClipRRect( // Recorta el contenido con bordes redondeados.
                          borderRadius: BorderRadius.circular(5), // Define un radio de 5 píxeles para las esquinas redondeadas.
                          child: Container(color: Colors.green), // Casilla verde para la comida.
                        ),
                      );
                    } else { // Si el índice actual no es la posición de la comida,
                      return Container(  // Devuelve un contenedor que representa una casilla vacía del tablero.
                        padding: EdgeInsets.all(2), // Aplica un margen interno de 2 píxeles
                        child: ClipRRect( // Recorta el contenido con bordes redondeados
                          borderRadius: BorderRadius.circular(5), // Define un radio de 5 píxeles para las esquinas redondeadas.
                          child: Container(color: Colors.grey[900]), // Fondo gris para el tablero.
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Padding( // Ajusta el espaciado alrededor de la fila
            padding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0), // Espaciado inferior y lateral.
            child: Row( // Crea una fila para alinear elementos horizontalmente.
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacia los elementos entre sí.
              children: <Widget>[ // Lista de widgets que estarán dentro de la fila.
                GestureDetector( // Detecta toques en el texto "S T A R T".
                  onTap: startGame, // Inicia el juego al tocar este texto.
                  child: Text( // Muestra el texto 
                    "S T A R T",  // Texto para iniciar el juego.
                    style: TextStyle(color: Colors.white, fontSize: 20), // Estilo del texto de inicio.
                  ),
                ),
                Text( // Muestra el texto de los créditos
                  "C R E A D O  P O R  V I C T O R", // Texto de los creditos
                  style: TextStyle(color: Colors.white, fontSize: 20), // Texto de crédito del desarrollador.
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
