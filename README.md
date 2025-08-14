# Data Cleaning and Harmonization Repository

## Overview
This repository provides a stepwise workflow for data cleaning and harmonization using R scripts. Each step is modular and builds on the previous, enabling robust, reproducible data processing for teams.

## Estrutura
Este repositório oferece um fluxo de trabalho passo a passo para limpeza e harmonização de dados utilizando scripts em R. Cada etapa é modular e depende da anterior, permitindo um processamento robusto e reprodutível para equipes.

## Structure / Estrutura

- `01_data_loading.R`: Load raw data / Carregar dados brutos
- `02_data_cleaning.R`: Clean loaded data / Limpar dados carregados
- `03_data_harmonization.R`: Harmonize cleaned data / Harmonizar dados limpos
- `04_analysis.R`: Analysis routines / Rotinas de análise
- `config/config.yml`: Configuration settings / Configurações
- `scripts/helper_functions.R`: Common functions / Funções auxiliares
- `docs/best_practices.md`: Team rules, naming conventions, and guidelines / Regras, convenções e diretrizes

## Usage / Uso

1. Clone the repository / Clone o repositório. 

> git clone <repository_url>

or / ou

> git push <repository_url

2. Configure `config/config.yml` as needed / Configure `config/config.yml` conforme necessário.
3. Run scripts in order, sourcing the previous script in each step / Execute os scripts em ordem, usando `source` para chamar o script anterior em cada etapa.

## Contribution / Contribuição

- Follow best practices in `docs/best_practices.md` / Siga as boas práticas em `docs/best_practices.md`.
- Add script headers as shown in each `.R` file / Adicione cabeçalhos como mostrado nos arquivos `.R`.
- Commit early, commit often / Faça commits frequentes e com mensagens descritivas.
- Use pull requests for changes / Use pull requests para alterações.
- Document your code / Documente seu código.

    + Examples commit messages / Exemplos mensagens de commit:
        - "Added data loading script" / "Adicionado script de carregamento de dados"
        - "Fixed data cleaning issues" / "Corrigidos problemas de limpeza de dados"
        - "Updated harmonization process" / "Atualizado processo de harmonização"
        - "Improved analysis scripts" / "Melhorados scripts de análise"
        - "Refactored data loading" / "Refatorado carregamento de dados"
        - "Optimized data processing" / "Otimizados processos de dados"

- Pull request template / Modelo de pull request

Pull requests should be made for all changes, no matter how small. Each pull request should be linked to a specific issue or task.

As a general guideline, pull requests should:

- Be small and focused / Ser pequenos e focados
- Include tests / Incluir testes
- Be well-documented / Ser bem documentados, de acordo com o template a seguir:

## Pull Request Template

### Descrição

- O que foi feito?
- Por que foi feito?
- Quais problemas isso resolve?

### Tipo de Mudança

- [ ] Correção de bug
- [ ] Nova funcionalidade
- [ ] Mudança de documentação

### Testes

- [ ] Testes foram adicionados/atualizados?
- [ ] Todos os testes existentes passaram?

### Checklist

- [ ] O código segue as diretrizes de estilo do projeto? encontra-se no arquivo `docs/best_practices.md`    
- [ ] A documentação foi atualizada? --> encontra-se no arquivo `docs/best_practices.md`
- [ ] O changelog foi atualizado? --> encontra-se no arquivo `CHANGELOG.md`
