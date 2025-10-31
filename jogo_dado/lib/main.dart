//Importa a biblioteca para trabalhar com números aleatórios (para o dado)
import 'dart:math';
//importa o pacote principal do flutter (widgets,design ...etc)
import 'package:flutter/material.dart';

// 1. STRUTURRA BASE DO APP
//A função principal que inicia o app

void main() => runApp(const AplicativoJogodeDados());

//Raiz (base) do app. Dfinir o tema e o fluxo inicial
class AplicativoJogodeDados extends StatelessWidget {
  const AplicativoJogodeDados({super.key});

  @override
  Widget build(BuildContext context) {
    //Fazer o return do MaterialApp, que dá o visual ao projeto
    return MaterialApp(
      title: 'Jogo de Dados', //Título que aparece no gerenciador
      theme: ThemeData(
        primarySwatch: Colors.blue, //Cor primária do app
      ),
      home: const TelaConfiguracaoJogadores(), //Tela inicial do app
    );
  }
}

//2. TELA DE CONFIGURAÇÃO
// Primeira tela do app. Coletar os niomes dos jogadores
class TelaConfiguracaoJogadores extends StatefulWidget {
  const TelaConfiguracaoJogadores({super.key});

  @override // sobrepoe a classe pai
  //Cria o objeto de estado que vai gerenciar o formulario do jogador
  State<TelaConfiguracaoJogadores> createState() =>
      _EstadoTelaConfuguracaoJogadores();
}

class _EstadoTelaConfuguracaoJogadores
    extends State<TelaConfiguracaoJogadores> {
  //chave global para identificar e validar o widget
  //final é uma chevae do dart para criaruma variável que só recebe valor uma vez(imutável)
  // FormState é o estao interno desse formulário, é  parte que sabe o que está digitado e consegue validar os campos
  final _chaveFormulario = GlobalKey<FormState>(); //estado do formulário
  //Controladores para pegar o texto digitado nos campos
  final TextEditingController _controladorJogador1 = TextEditingController();
  final TextEditingController _controladorJogador2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //corpo do widget (body)
      appBar: AppBar(title: const Text("Configuração dos Jogadores")),
      body: Padding(
        padding: const EdgeInsets.all(16), //Espaçamento interno
        child: Form(
          //Formulário para pegar os nomes dos jogadores
          key: _chaveFormulario, //assosciando a chave GlabalKey ao formulário
          child: Column(
            //Organiza os campos em coluna
            children: [
              //campo de texto para joagador numero 1
              TextFormField(
                controller:
                    _controladorJogador1, //associando o controlador ao campo
                decoration: const InputDecoration(
                  labelText: "Nome do Jogador 1",
                ), //rótulo do campo
                validator: (valor) => valor!.isEmpty
                    ? "Digite o nome do jogador 1"
                    : null, //validação do campo
                //condição ? valor_se_verdadeiro : valor_se_falso
                //Se o campo estiver vazio, mostre o texto Digite um nome.
              ),
              const SizedBox(height: 16),
              //campo de texto para joagador numero 2
              TextFormField(
                controller:
                    _controladorJogador2, //associando o controlador ao campo
                decoration: const InputDecoration(
                  labelText: "Nome do Jogador 2",
                ), //rótulo do campo
                validator: (valor) => valor!.isEmpty
                    ? "Digite o nome do jogador 2"
                    : null, //validação do campo
                //condição ? valor_se_verdadeiro : valor_se_falso
                //Se o campo estiver vazio, mostre o texto Digite um nome.
              ),
              const Spacer(), //ocupar o espaço vertical disponível, empurrando o botãop/ baixo
              //Fazer um botão para iniciar o jogo
              ElevatedButton(
                onPressed: () {
                  //chamar a validação do formulário(se os campos está preenchido)
                  if (_chaveFormulario.currentState!.validate()) {
                    //Se o formulário for válido, navegar para a próxima tela
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //Cri a tela do jogo, PASSANDO os nomes digitados como parâmetros
                        builder: (context) => TelaJogodeDados(
                          nomeJogador1: _controladorJogador1.text,
                          nomeJogador2: _controladorJogador2.text,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                //Botão de largura total.
                child: const Text("Iniciar Jogo"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//3. Tela PRINCIPAL DO JOGO

// Aqui eu vou receber os nomes como propriedades
class TelaJogodeDados extends StatefulWidget {
  //varíaveis finais que armazenam os nomes recebidos da tela anterior
  final String nomeJogador1;
  final String nomeJogador2;
  //TELAJOGODEDADOS é o corpo de um robô
  const TelaJogodeDados({
    super.key,
    //o required garante que esses vlores deverão ser passados.
    required this.nomeJogador1,
    required this.nomeJogador2,
  });

  @override
  //Ei tio flutter, quando essa tela for criada, use essa classe chamada _EstadoTelaJogoDeDados para guardar e controlar o estado dela
  //ESTADOTELAJOGODEDADOS é o cérebro do robô
  //O CREATESTATE é o botão que coloca o cérebro dentro do robô
  State<TelaJogodeDados> createState() => _EstadoTelaJogoDeDados();
}

class _EstadoTelaJogoDeDados extends State<TelaJogodeDados> {
  final Random _aleatorio = Random(); //gerador de números aleatórios
  List<int> _lancamentosJogador1 = [1, 1, 1];
  List<int> _lancamentosJogador2 = [1, 1, 1];
  String _mensagemResultado = ''; //Mensagem de resulado da rodada.

  //mapear as associoações dos números do dado referente ao link
  final Map<int, String> imagensDados = {
    1: 'https://i.imgur.com/1xqPfjc.png&#39',
    2: 'https://i.imgur.com/5ClIegB.png&#39;',
    3: 'https://i.imgur.com/hjqY13x.png&#39',
    4: 'https://i.imgur.com/CfJnQt0.png&#39',
    5: 'https://i.imgur.com/6oWpSbf.png&#39',
    6: 'https://i.imgur.com/drgfo7s.png&#39',
  };
  // lógica da pontuação: verefica combinações para aplicar os muliplicadores.
  int _calcularPontuacao(List<int> lancamentos) {
    //reduce percorre toda a lista somando tudo
    final soma = lancamentos.reduce((a, b) => a + b);
    //[4,4,1] > 4 + 4 = 8 > 8 + 1 = 9 > soma = 9
    final valoresUnicos = lancamentos.toSet().length;
    //toSet remove valores repetidos
    if (valoresUnicos == 1) {
      //[5,5,5] TrÊ igais = 3x  a soma
      return soma * 3;
    } else if (valoresUnicos == 2) {
      //[2,2,5] Dois iguais = 2x a soma
      return soma * 2;
    } else {
      return soma; //todos diferentes = soma normal
    }
  }

  //função chamada pelo botão para lançar os dados
  void _lancarDados() {
    //eu uso sublinhado _ para indicar que a função é privada, só pode ser usada dentro dessa classe
    //comando crucial p/ forçar a atualização da tela
    setState(() {
      _lancamentosJogador1 = List.generate(3, (_) => _aleatorio.nextInt(6) + 1);
      _lancamentosJogador2 = List.generate(3, (_) => _aleatorio.nextInt(6) + 1);
      final pontuacao1 = _calcularPontuacao(_lancamentosJogador1);
      final pontuacao2 = _calcularPontuacao(_lancamentosJogador2);

      if (pontuacao1 > pontuacao2) {
        _mensagemResultado =
            '${widget.nomeJogador1} venceu! ($pontuacao1 x $pontuacao2)';
      } else if (pontuacao2 > pontuacao1) {
        _mensagemResultado =
            '${widget.nomeJogador2} venceu! ($pontuacao2 x $pontuacao1)';
      } else {
        _mensagemResultado = 'Empate! Joguem novamente.';
      }
    });
  }

  // declara a função que devolve um widget: recebe nome jogador, lançamentos: os 3 valores do dado
  Widget _construirColunaJogador(String nome, List<int> lancamentos) {
    return Expanded(
      //pega todo espaço disponível dentro de um row (linha) ou column (coluna)
      child: Column(
        children: [
          Text(
            nome,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment
                .center, //é o justify-container: center; do css
            children: lancamentos.map((valor) {
              //map transforma o numero do dado em um widget e imagem
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.network(
                imagensDados[valor]!, //pega a url do mapa usando o valor do dado
                  width: 50,
                  height: 50,
                  errorBuilder: (context, erro, stackTrace) => 
                  const Icon(Icons.error, size: 40), //mostra um ícone de erro se a imagem não carregar
                ),
              );
            }).toList(), //converte o resultado do map em uma lista de widgets/organiza a lista dos dados
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context){
  return Scaffold( //Scaffold é tipo o body
  appBar: AppBar(title: const Text('Jogo de Dados')),
  body: Column(
  children: [
  Row(
  children: [
  _construirColunaJogador(widget.nomeJogador1, _lancamentosJogador1),
  _construirColunaJogador(widget.nomeJogador2, _lancamentosJogador2),//
  ],  
  ),  
  const SizedBox(height: 20),
  Text(
  _mensagemResultado,
  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  textAlign: TextAlign.center,  
  ),
  const Spacer(), //empurra o botão para a parte debaixo da tela/ o br
  
  ElevatedButton(
  onPressed: _lancarDados,
  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
  child: const Text('Jogar Dados'),
  )
  ],  
  ) 
  );  
  }
}