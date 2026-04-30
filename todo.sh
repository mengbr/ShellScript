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
# $0 é a variavel que traz o primeiro argumento do script que é o próprio nome do script
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

# Função para adicionar uma tarefa no arquivo
function adicionar_tarefa() {
    # Variaveis locais para controle
    # $1 e $2 são argumentos passados para a função que foi chamada no Switch Case
    local descricao="$1"
    local prioridade="$2"

    # Obter a data atual no formato 2026-04-28
    local data=$(date +%Y-%m-%d)

    # Adicionar tarefa ao arquivo
    echo "[]|$data|$prioridade|$descricao" >> "$TODO_FILE"
    echo "Tarefa adicionada com sucesso!"
}

# Função para listar as tarefas salvas
function listar_tarefas() {

    # Variável responsável por adicionar o número da linha
    local linha=1

    # O IFS (Internal Field Separator) é uma variável usada 
    # para dividir linhas em palavras através do separador especificado 
    # é utilizado em conjunto com o comando read.
    while IFS="|" read -r status data prioridade descricao; do
        echo -e "${linha}. $status | $data | $prioridade | $descricao"
        linha=$((linha + 1))
    done < "$TODO_FILE"
}

# Conclui uma tarefa de acordo com a linha especificada
function marcar_concluida() {
    # Pega o numero informado para conlcuir a tarefa com a linha específica
    local numero="$1"

    # Cria um arquivo temporário
    local temp_file=$(mktemp)

    # Processar o arquivo linha por linha
    linha=1
    while IFS="|" read -r status resto; do
        # se a linha for igual a que informei então
        if [ "$linha" -eq "$numero" ]; then

            # Substituir [ ] por [x] se não estiver concluída
            if [[ "$status" == "[]" ]]; then
                echo "[x]|$resto" >> "$temp_file"
            else
                echo "[]|$resto" >> "$temp_file"
            fi

        else
            echo "$status|$resto" >> "$temp_file"
        fi
        linha=$((linha + 1))
    done < "$TODO_FILE"
    
    # Substituir o arquivo original
    mv "$temp_file" "$TODO_FILE"

    echo "Tarefa $numero marcada/desmarcada com sucesso!"

}

function remover_tarefa() {
    local numero="$1"
    local temp_file=$(mktemp)

    # Processar o arquivo linha por linha
    linha=1
    while read -r tarefa; do
        if [ "$linha" -ne "$numero" ]; then
            echo "$tarefa" >> "$temp_file"
        fi
        linha=$((linha + 1))
    done < "$TODO_FILE"
    
    # Substituir o arquivo original
    mv "$temp_file" "$TODO_FILE"

    echo "Tarefa $numero removida com sucesso"

}

# Processamento dos comandos por meio de SWITCH CASE
# O primeiro argumento "$1" será o comando passado para o script
case "$1" in
    add)
        adicionar_tarefa "$2" "$3"
        ;;
    list)
        listar_tarefas
        ;;
    done)
        marcar_concluida "$2"
        ;;
    del)
        remover_tarefa "$2"
        ;;
    search)
        # Implementar pesquisa de tarefas
        ;;
    help)
        mostrar_ajuda
        ;;
    *)
        echo "Comando desconhecido: $1"
        mostrar_ajuda
        exit 1
        ;;
esac

exit 0