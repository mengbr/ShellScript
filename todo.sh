#!/bin/bash
# todo.sh - Gerenciador de tarefas em bash
#
# XI SEMANA DE ENGENHARIA E TECNOLOGIA - Engenharia de Software
# Local: Universidade de Ribeirão Preto
# Professor: Michael Oliveira
# Data: 28/04/2026 a 30/04/2026
#
# Referência comandos shell: https://aurelio.net/shell/canivete/
# 

# Variável global para armazenar o caminho do arquivo que será usado
# para armazenar as tarefas
TODO_FILE="$HOME/.todo.txt"

# Verificar se o arquivo de tarefas existe, se não, criar
if [ ! -e "$TODO_FILE" ]; then
    touch "$TODO_FILE"
fi

# Função de ajuda que mostra as opções disponíveis
# $0 variavel que traz o primeiro argumento do script que é o ome do programa
function mostrar_ajuda() {
    echo "Uso: $0 [opção] [argumentos]"
    echo
    echo "Opções:"
    echo "  add \"TAREFA\" [prioridade]   Adicionar uma nova tarefa"
    echo "  list                        Listar todas as tarefas"
    echo "  done NÚMERO                 Marcar tarefa como concluída"
    echo "  del NÚMERO                  Remover tarefa"
    echo "  search TERMO                Pesquisar tarefas"
    echo "  help                        Mostrar esta ajuda"
    echo
    echo "Exemplo:"
    echo "  $0 add \"Preparar aula de Shell Script\" alta"
}

# Verificar se nenhum argumento foi passado
# $# = quantidade de parametros passados ao chamar o programa /todo.sh
if [ $# -eq 0 ]; then
    mostrar_ajuda
    exit 0
fi
