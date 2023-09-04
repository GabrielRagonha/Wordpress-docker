#!/bin/bash

print_menu() {
    echo "Selecione uma opção:"
    echo "1. Criar base"        #Cria a base
    echo "2. Apagar base"       #Apaga todos os dados do seu projeto
    echo "3. Parar Docker"      #Caso queira parar o Docker pós término do desenvolvimento
    echo "4. Startar Docker"    #Caso a base já esteja criada e o docker tenha sido parado
    echo
}

create_base() {
    echo "Criando base..."    

    start_docker

    chmod -R 777 wordpress

    sleep 2

    rm -rf wordpress/wp-content/themes/*
    echo "<?php" > wordpress/wp-content/themes/index.php

    rm -rf wordpress/wp-content/plugins/*
    echo "<?php" > wordpress/wp-content/plugins/index.php

    rm wordpress/readme.html
    rm wordpress/wp-config-sample.php
    
    create_theme

    chmod -R 777 wordpress
    
    echo "Base criada com sucesso!"
}

create_theme() {
    clear

    echo "Criando tema..."
    
    echo "Insira o nome do tema: "
    read THEME_NAME

    git clone https://github.com/GabrielRagonha/Wordpress-base-theme $THEME_NAME

    cp -r $THEME_NAME/ wordpress/wp-content/themes
    rm -rf $THEME_NAME

    clear

    echo "Tema criado com sucesso!"
}

delete_base() {
    echo "Apagando base..."

    read -p "Tem certeza que deseja apagar a base? (S/N): " confirm
    if [[ "$confirm" != "S" && "$confirm" != "s" ]]; then
        echo "Operação cancelada."
        return
    fi
    
    shutdown_docker

    rm -rf wordpress/

    docker volume prune -af
    docker image prune -af

    clear
    
    echo "Base apagada com sucesso!"
}

start_docker() {
    echo "Startando Docker..."

    docker compose up -d

    echo "Docker startado com sucesso!"
}

shutdown_docker() {
    echo "Desligando Docker..."
    
    docker compose down
    
    echo "Docker desligado com sucesso!"
}

print_menu

read -p "Opção: " option
echo

case $option in
    1)
        create_base
        ;;
    2)
        delete_base
        ;;
    3)
        shutdown_docker
        ;;
    4)
        start_docker
        ;;
    *)
        echo "Opção inválida. Saindo..."
        ;;
esac
