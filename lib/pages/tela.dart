import 'package:calculadora/models/valores.dart';
import 'package:flutter/material.dart';

class Tela extends StatefulWidget {
  const Tela({super.key});

  @override
  State<Tela> createState() => _TelaState();
}

class _TelaState extends State<Tela> {
  String numero1 = ""; // . ou 0-9
  String operador = ""; // + ou - ou * ou /
  String numero2 = ""; // . ou 0-9

  @override
  Widget build(BuildContext context) {
    final tamanhoTela =MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            //saída
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$numero1$operador$numero2".isEmpty
                        ? "0"
                        : "$numero1$operador$numero2",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            //botões
            Wrap(
              children: Botao.valores
                  .map(
                    (value) => SizedBox(
                  width: value == Botao.n0
                      ? tamanhoTela.width / 2
                      : (tamanhoTela.width / 4),
                  height: tamanhoTela.width / 5,
                  child: construcaoBotao(value),
                ),
              )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget construcaoBotao(value){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: corBotao(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.white24,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => toqueBotao(value),
          child: Center(
              child: Text(
                value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                ),
              ),
          ),
        ),
      ),
    );
  }

  void toqueBotao(String value){
    if (value == Botao.del){
      excluir();
      return;
    }
    if (value == Botao.clr){
      clearAll();
      return;
    }
    if (value == Botao.per){
      conversaoPorcentagem();
      return;
    }
    if (value == Botao.calculate){
      calcular();
      return;
    }
    acrescentarValor(value);
  }

  void calcular(){
    if (numero1.isEmpty) return;
    if (operador.isEmpty) return;
    if (numero2.isEmpty) return;

    double num1 = double.parse(numero1);
    double num2 = double.parse(numero2);

    var resultado = 0.0;
    switch (operador){
      case Botao.add:
        resultado = num1 + num2;
        break;
      case Botao.subtract:
        resultado = num1 - num2;
        break;
      case Botao.multiply:
        resultado = num1 * num2;
        break;
      case Botao.divide:
        resultado = num1 / num2;
        break;
      default:
    }

    setState(() {
      numero1 = resultado.toStringAsPrecision(3);

      if (numero1.endsWith(".0")){
        numero1 = numero1.substring(0, numero1.length - 2);
      }

      operador = "";
      numero2 = "";
    });
  }

  void conversaoPorcentagem(){
    if (numero1.isNotEmpty && operador.isNotEmpty && numero2.isNotEmpty){
      calcular();
    }
    if (operador.isNotEmpty){
      return;
    }
    final numero = double.parse(numero1);
    setState(() {
      numero1 = "${(numero / 100)}";
      operador = "";
      numero2 = "";
    });
  }

  void clearAll(){
    setState(() {
      numero1 = "";
      operador = "";
      numero2 = "";
    });
  }

  void excluir(){
    if (numero2.isNotEmpty){
      // 12323 => 1232
      numero2 = numero2.substring(0, numero2.length - 1);
    } else if (operador.isNotEmpty){
      operador = "";
    } else if (numero1.isNotEmpty){
      numero1 = numero1.substring(0, numero1.length - 1);
    }
    setState(() {

    });
  }

  void acrescentarValor(String value){
    // A ordem é: numero1 + operador + numero2

    // Se é operador e não é "."
    if (value != Botao.dot && int.tryParse(value) == null){
      if(operador.isNotEmpty && numero2.isNotEmpty){
        calcular();
      }
      operador = value;
    } else if(numero1.isEmpty || operador.isEmpty){
      // Verificação se o valor é "." | Exemplo: numero1 = "1.2"
      if (value == Botao.dot && numero1.contains(Botao.dot)) return;
      if (value == Botao.dot && (numero1.isEmpty || numero1 == Botao.n0)) {
        // Exemplo: numero1 = "" | "0"
        value = "0.";
      }
      numero1 += value;
    }else if (numero2.isEmpty || operador.isNotEmpty){
      // Verificação se o valor é "." | Exemplo: numero2 = "1.2"
      if (value == Botao.dot && numero2.contains(Botao.dot)) return;
      if (value == Botao.dot && (numero2.isEmpty || numero2 == Botao.n0)) {
        // Exemplo: numero2 = "" | "0"
        value = "0.";
      }
      numero2 += value;
    }
    setState(() {});
  }

  Color corBotao(value){
    return [
      Botao.del,
      Botao.clr,
    ].contains(value)
        ? Colors.blueGrey
        : [
      Botao.per,
      Botao.multiply,
      Botao.add,
      Botao.subtract,
      Botao.divide,
      Botao.calculate
    ].contains(value)
        ? Colors.orange
        : Colors.black87;
  }
}
