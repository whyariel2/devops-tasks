# DevOps Tasks

Repositório com um menu interativo para executar tarefas rotineiras de
DevOps de forma rápida, padronizada e sem precisar lembrar de cada comando.

## Objetivo

Centralizar scripts e automações do dia a dia de infraestrutura, reduzindo
trabalho manual e erros operacionais.

## Tarefas disponíveis

- **Backup:** rotinas de backup de arquivos, diretórios e bancos de dados
- **Monitoramento de disco:** checagem de uso de disco e disparo de notificação no Teams a partir de webhook

## Como usar

1. Clone o repositório:
   git clone https://github.com/whyariel2/devops-tasks.git
2. Entre na pasta e dê permissão de execução:
   cd devops-tasks && chmod +x menu.sh
3. Execute o menu:
   ./menu.sh
4. Escolha a tarefa desejada pelo número.

## Requisitos

- Linux/Unix com Bash 4+
- df, jq, curl, awk

## Estrutura

```text
.
|-- menu.sh          # Menu principal
|-- src/             # Scripts de cada tarefa
|   |-- backup.sh
|   |-- lib.sh
|   `-- monitor_disk.sh
`-- README.md
```
