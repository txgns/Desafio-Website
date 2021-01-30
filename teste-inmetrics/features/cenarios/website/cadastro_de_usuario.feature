# language: pt
# encoding UTF-8

@cadastro_de_usuario
Funcionalidade: Cadastro de usuário

@automacao
Esquema do Cenário: Cenários Possíveis na Tela de Cadastro de usuário do Painel.
# Validar os cenários possíveis ao tentar cadastrar usuários no painel.

    Dada <condição inicial>
    E preencho o campo "Usuario" com um nome aleatório
        E eu insiro os dados:
        |Senha           |<senha>           |
        |Confirmar Senha |<confirmar_senha> |
    Entao <tento cadastrar>


    @erro
    Exemplos:
    # cadastrar com valores inválidos e/ou incorretos. 
    |condição inicial                                       |senha          |confirmar_senha |tento cadastrar            |
    |abri o browser e acessei a tela "Cadastro de Usuario"  |senha_qualquer |                |clico no botao "Cadastrar" |
    |estou na tela "Cadastro de Usuario" do "Painel"        |               |senha_qualquer  |clico no botao "Cadastrar" |
    |estou na tela "Cadastro de Usuario" do "Painel"        |senha_qualquer |senha_qualquer2 |clico no botao "Cadastrar" |
    |estou na tela "Cadastro de Usuario" do "Painel"        |senha_invalida |senha_invalida2 |clico no botao "Cadastrar" |

    @sucesso 
    Exemplos:
    # logar com um email válido e senha correta.
    |condição inicial                                          |senha     |confirmar_senha |tento cadastrar             |
    |abri o browser e acessei a tela "Cadastro de Usuario"     |automacao |automacao       |clico no botao "Cadastrar"  | 
