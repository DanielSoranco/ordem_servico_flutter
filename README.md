# 📱 Gestão de Atendimentos

Aplicativo móvel desenvolvido em **Flutter** para o gerenciamento de ordens de serviço e atendimentos técnicos. O projeto foca na aplicação de boas práticas de engenharia de software, utilizando **Clean Architecture** e persistência de dados local.

## ✨ Funcionalidades

* **Listagem de Atendimentos:** Visualização rápida de todos os serviços com filtros por status (Todos, Ativo, Em Andamento, Finalizado).
* **Gestão Completa (CRUD):** Criação, Edição e Exclusão de atendimentos.
* **Captura de Imagem:** Integração com a câmera do dispositivo para anexar fotos aos atendimentos.
* **Persistência de Dados:** Os dados são salvos localmente utilizando **SQLite**, garantindo acesso offline e persistência após reiniciar o app.
* **Status:** Controle visual de status com cores distintas.

## 🛠️ Tecnologias e Arquitetura

O projeto foi construído seguindo rigorosamente a **Clean Architecture**, garantindo desacoplamento entre as camadas e facilidade de manutenção.

* **Linguagem:** Dart (SDK 3.8+)
* **Framework:** Flutter
* **Gerência de Estado:** `flutter_bloc` (Cubit)
* **Injeção de Dependência:** `get_it` e `injectable`
* **Banco de Dados Local:** `sqflite`
* **Câmera:** `image_picker`
* **Geração de Código:** `build_runner`

### 📂 Estrutura de Pastas

A estrutura reflete a divisão de responsabilidades da Clean Architecture:

```text
lib/
├── core/           # Configurações globais (Injeção de Dep., Database)
├── data/           # Implementação dos repositórios e acesso a dados (SQLite)
├── domain/         # Regras de negócio (Entidades, UseCases e Contratos)
└── presentation/   # Camada visual (Telas, Cubits e Widgets)
