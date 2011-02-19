#!/bin/bash
# gerar.sh
# Copyright (c) 2006 by Bruno Ribas <ribas@ufpr.br>
# Depende de fakeroot

DIRTMP=$(mktemp -d)
VERSAO=$(cat VERSAO)

#arrumar versao
#$1 tipo de incremento
MAJOR=$(echo $VERSAO| cut -d'.' -f1)
MINOR=$(echo $VERSAO| cut -d'.' -f2)
REVISION=$(echo $VERSAO| cut -d'.' -f3)

case $1 in
	Minor)
		((MINOR++))
		REVISION=0
		;;
	Major)
		((MAJOR++))
		MINOR=0
		REVISION=0
		;;
	help)
		echo "Uso: $0 Major|Minor|Revision"
		echo '     Major - Altera versao Major'
		echo '     Minor - Altera versao Minor'
		exit
		;;
	*)
		((REVISION++))
		;;
esac

VERSAO="${MAJOR}.${MINOR}.${REVISION}"
echo "$VERSAO" > VERSAO

#Compila a documentacao do pacote no diretorio doc/
#cd doc/
#hevea -text *.tex
#hevea -text *.tex
#cd ../

cp -r pacote $DIRTMP

#Copia a documentacao compilada para dentro do pacote.
#cp doc/*.txt $DIRTMP/pacote/usr/share/doc/prd-*

cd $DIRTMP
find . -name ".svn" -exec rm -rf {} \; &>/dev/null
sed -i -e "s/Version:/Version: $VERSAO/" pacote/DEBIAN/control

fakeroot dpkg -b pacote .

cd -

cp $DIRTMP/*deb .
rm -rf $DIRTMP


# vim:tabstop=4:shiftwidth=4:encoding=iso-8859-1
