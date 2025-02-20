import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neura_app/app/core/constants/app_colors.dart';
import 'package:neura_app/app/features/chats/presentation/widgets/assistant_message.dart';
import 'package:neura_app/app/features/chats/presentation/widgets/user_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> messages = [
    Message(
      role: 'user',
      content: 'Hola como estas',
      createdAt: DateTime.now(),
    ),

    Message(
      role: 'assistant',
      content:
          "### Comparación entre una moto y un carro\n\n#### **Pros de una moto:**\n1. **Menor costo de compra:** Las motos suelen ser más económicas que los carros.\n2. **Ahorro de combustible:** Consumen menos gasolina, lo que reduce los gastos diarios.\n3. **Facilidad de estacionamiento:** Ocupan menos espacio y es más fácil encontrar lugar para estacionar.\n4. **Movilidad en el tráfico:** Pueden filtrarse entre el tráfico, lo que reduce el tiempo de viaje en ciudades congestionadas.\n5. **Mantenimiento más económico:** Los costos de mantenimiento y reparación suelen ser menores.\n6. **Experiencia de conducción:** Ofrecen una sensación de libertad y conexión con el entorno.\n\n#### **Contras de una moto:**\n1. **Menor seguridad:** Son más vulnerables en accidentes y no ofrecen protección contra el clima o impactos.\n2. **Limitación de pasajeros:** Generalmente solo pueden transportar a una o dos personas.\n3. **Exposición a las condiciones climáticas:** No protegen de la lluvia, el frío o el calor extremo.\n4. **Menor capacidad de carga:** No son prácticas para transportar objetos grandes o muchas cosas.\n5. **Mayor riesgo de robo:** Las motos son más fáciles de robar que los carros.\n\n---\n\n#### **Pros de un carro:**\n1. **Mayor seguridad:** Ofrecen protección en caso de accidentes y están equipados con sistemas de seguridad como airbags y cinturones.\n2. **Comodidad:** Protegen de las condiciones climáticas y ofrecen espacio para pasajeros y carga.\n3. **Capacidad de pasajeros:** Pueden transportar a más personas, ideal para familias o grupos.\n4. **Mayor capacidad de carga:** Tienen espacio para maletas, compras o equipos grandes.\n5. **Confort:** Cuentan con sistemas de climatización, asientos cómodos y tecnología avanzada.\n\n#### **Contras de un carro:**\n1. **Costo de compra más alto:** Los carros suelen ser más caros que las motos.\n2. **Mayor consumo de combustible:** Gastan más gas",
      createdAt: DateTime.now(),
    ),
    Message(
      role: 'user',
      content:
          'Para darle un color de fondo (background-color) a un checkbox, no puedes hacerlo directamente con CSS estándar, ya que los checkboxes son elementos de entrada nativos del navegador y su apariencia está',
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.dark1,
        scrolledUnderElevation: 0,
        toolbarHeight: 52,
        flexibleSpace: SafeArea(
          child: Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/menu.svg',
                  width: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 16),
                SvgPicture.asset('assets/icons/neura_text_white.svg', height: 16),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 24,
                    bottom: 16,
                  ),
                  sliver: SliverList.separated(
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      if (message.role == 'user') {
                        return UserMessage(content: messages[index].content);
                      }

                      return AssistantMessage(content: message.content);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 24);
                    },
                    itemCount: messages.length,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: AppColors.dark1),
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                color: AppColors.dark2,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(
                      color: AppColors.neutralOffWhite,
                      fontSize: 16,
                      height: 24 / 16,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.only(
                        left: 0,
                        right: 0,
                        top: 16,
                      ),
                    ),
                    minLines: 1,
                    maxLines: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primary2,
                            disabledBackgroundColor: AppColors.dark8,
                            padding: EdgeInsets.zero,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/send.svg',
                            width: 20,
                            colorFilter: const ColorFilter.mode(
                              AppColors.white,
                              BlendMode.srcIn,
                            ),
                          ),
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
    );
  }
}

class Message {
  final String role;
  final String content;
  final DateTime createdAt;

  Message({required this.role, required this.content, required this.createdAt});
}
