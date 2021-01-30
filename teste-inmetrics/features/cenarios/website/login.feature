# language: pt
# encoding UTF-8

@login
Funcionalidade: Teste de Login

@automacao
Esquema do Cenário: Cenários Possíveis na Tela de Login do Painel.
# Validar os cenários possíveis ao tentar logar no painel.

    Dada <condição inicial>
        Quando eu insiro os dados:
        |usuario  |<usuario> |
        |Senha    |<senha>   |
    Entao <tento logar>


    @erro
    Exemplos:
    # logar com valores inválidos e/ou incorretos.
    |condição inicial                         |usuario        |senha          |tento logar               |
    |abri o browser e acessei a tela "Login"  |               |senha_qualquer |clico no botao "Login"    |
    |estou na tela "Login" do "Painel"        |login_errado   |               |clico no botao "Login"    |
    |estou na tela "Login" do "Painel"        |login_invalido |senha_qualquer |clico no botao "Login"    |
    |estou na tela "Login" do "Painel"        |login_valido   |senha_invalida |clico no botao "Login"    |

    @sucesso 
    Exemplos:
    # logar com um email válido e senha correta.
    |condição inicial                                 |usuario      |senha     |tento logar             |
    |abri o browser e acessei a tela "Login"          |inmetrics    |automacao |clico no botao "Login"  | 
