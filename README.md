# Projeto de Autenticação e Extrato
Este projeto consiste em dois fluxos principais: autenticação/login e listagem de extratos financeiros, incluindo a visualização dos detalhes de cada extrato. O projeto foi desenvolvido utilizando UIKit com ViewCode e SwiftUI para algumas partes da interface gráfica. Além disso, a arquitetura segue o padrão MVVM (Model-View-ViewModel), sem o uso de bibliotecas externas.

# Funcionalidades
1. Fluxo de Login
Autenticação: O usuário precisa inserir suas credenciais (CPF e senha) para acessar o aplicativo.
Token de autenticação: Após o login bem-sucedido, um token é recebido e deve ser renovado automaticamente a cada 1 minuto. A renovação é feita em segundo plano para manter a sessão ativa sem necessidade de interação do usuário.
Validação: O fluxo de login possui validação dos campos de entrada (CPF e senha), garantindo que os dados estejam no formato correto antes do envio.
2. Fluxo de Listagem de Extrato
Skeleton Loading: Enquanto os dados do extrato estão sendo carregados, um skeleton loading é exibido tanto na UITableView quanto na lista de detalhes, proporcionando uma melhor experiência visual para o usuário.
Listagem de extratos: Após o carregamento dos dados, o extrato é exibido em uma tabela, mostrando as transações financeiras do usuário.
Detalhes do extrato: Ao selecionar um item da lista, o usuário pode visualizar os detalhes da transação, como valor, data, e as partes envolvidas.
Arquitetura

# Arquitetura
O projeto foi desenvolvido utilizando o padrão MVVM:

Model: Representa os dados e as estruturas de dados do aplicativo, como os objetos TransactionDTO e TransferDTO que contêm as informações do extrato.

View: Toda a interface de usuário, implementada em UIKit usando ViewCode para maior controle e personalização, e SwiftUI para partes específicas da interface.

ViewModel: Contém a lógica de apresentação e manipulação dos dados, servindo de intermediário entre a View e o Model. As ViewModels também gerenciam o estado da UI, como o controle do loading.


# Managers
Os managers foram implementados para centralizar responsabilidades e facilitar o desenvolvimento. 
Eles incluem:

1. Constantes estáticas: Centralizam valores reutilizáveis, como cores e fontes, garantindo consistência visual no projeto.
2. NetworkManager: Responsável pelas requisições de rede, autenticação e renovação automática de tokens, simplificando o gerenciamento de dados externos.
3. KeychainManager: Gerencia o armazenamento seguro de informações sensíveis, como tokens, utilizando o Keychain do iOS para garantir a proteção dos dados.

# Tecnologia
UIKit: A maior parte da interface foi construída com ViewCode para garantir flexibilidade e performance.

SwiftUI: Utilizado para algumas telas, aproveitando o poder declarativo de SwiftUI para criar componentes de interface de forma rápida e eficiente.

# Testes Unitários
Todos as viewModels do projeto foram testados usando testes unitários. O foco foi garantir a funcionalidade do login (com autenticação) e o fluxo de carregamento e exibição dos extratos.

Foram utilizados Mocks para simular as respostas da rede, permitindo testar cenários de sucesso e falha sem a necessidade de dependência de serviços externos.

# Instruções para Rodar o Projeto
Clone o repositório
Abra o projeto no Xcode:

Navegue até o diretório do projeto e abra o arquivo .xcodeproj no Xcode.
Build e execução:

Selecione um simulador ou dispositivo e execute o projeto pressionando Cmd + R.
Testes unitários:

Para rodar os testes unitários, use Cmd + U ou vá em Product > Test.
