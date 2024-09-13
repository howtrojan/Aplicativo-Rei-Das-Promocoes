# Rei das Promoções

**Rei das Promoções** é um aplicativo desenvolvido em Flutter que ajuda os usuários a encontrar e visualizar promoções e cupons do dia. O aplicativo funciona como uma ferramenta para indexar e exibir ofertas de diversas fontes, facilitando a busca por boas oportunidades. Não se trata de uma loja online, mas sim de um indexador de promoções.


<p align="center">
  <img src="https://github.com/user-attachments/assets/0f2989f8-ea56-4544-98b6-f5f56f657305" width="150" />
  <img src="https://github.com/user-attachments/assets/88479d99-3cdf-47c3-b6ff-f0165ca5e21e" width="150" />
  <img src="https://github.com/user-attachments/assets/2fb4eb80-4466-44a5-ba4f-6fa7da9cf169" width="150" />
  <img src="https://github.com/user-attachments/assets/66855fcb-fa8e-42a9-b696-859e9452734a" width="150" />
  <img src="https://github.com/user-attachments/assets/2eb1fd6b-e2a3-4ee2-a9e9-59504ea9377d" width="150" />
</p>

## Recursos

- **Interface Amigável:** Design intuitivo com uma barra de busca para encontrar promoções rapidamente.
- **Filtragem de Promoções:** Filtre promoções por data e palavras-chave.
- **Atualização Dinâmica:** Atualize a lista de promoções ao arrastar para baixo.
- **Gerenciamento de Estado com Provider:** Utiliza o pacote `provider` para gerenciar o estado da aplicação de forma eficiente.
- **Integração com Firebase:** Autenticação anônima e armazenamento de dados de promoções.
- **Anúncios:** Integração com Google AdMob para exibir anúncios banner e intersticiais.
- **Consentimento do Usuário:** Exibição de um diálogo de consentimento com os termos de uso.

## Funcionalidades

- **Página Inicial:** Exibe uma lista de promoções filtradas com base em pesquisa e data selecionada.
- **Barra de Pesquisa:** Permite buscar promoções por título e descrição.
- **Filtro por Data:** Filtra promoções para uma data específica.
- **Anúncios:** Exibe anúncios banner no rodapé da tela e intersticiais em momentos apropriados.

## Tecnologias Utilizadas

- **Flutter:** Framework para desenvolvimento de aplicativos móveis.
- **Provider:** Pacote para gerenciamento de estado.
- **Firebase:** Para autenticação e gerenciamento de dados.
- **Google AdMob:** Para exibição de anúncios.
- **Shared Preferences:** Para armazenamento de dados locais.
- **Python:** Utilizado para raspagem de dados das promoções.

## Raspagem de Dados

Os dados das promoções são raspados usando Python. O processo de raspagem coleta informações de várias fontes e as armazena para serem exibidas no aplicativo. O script de raspagem está localizado no diretório `python_scrapers/` e deve ser executado periodicamente para atualizar as promoções no Firebase.

## Uso
- Autenticação: O aplicativo realiza a autenticação anônima com Firebase na inicialização.
- Consentimento do Usuário: Um diálogo de consentimento é exibido na primeira execução do aplicativo para aceitar os termos de uso.
- Visualização de Promoções: As promoções são exibidas na página inicial com opções de pesquisa e filtragem por data.
- Atualização de Dados: Arraste para baixo para atualizar a lista de promoções.

## Link Para Download
- Você pode baixar o [Rei Das Promoções](https://play.google.com/store/apps/details?id=com.myapp.reidaspromocoes) na Google Play Store aqui.

## Contato

Para mais informações, entre em contato com [andre.braga.asb@gmail.com](mailto:andre.braga.asb@gmail.com).


