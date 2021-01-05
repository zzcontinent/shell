#!/bin/bash
REAL_HOME=${HOME}
CURDIR=`dirname $0`
cd ${CURDIR}
sudo rm -r ./res
mkdir -p ./res

#unzip bundle taghighlight_r2 vim-autocomplpop
unzip ./taghighlight_r2.1.4.zip -d ./res
unzip ./vim-autocomplpop.zip -d ./res
tar -zxvf ./bundle.tgz -C ./res

#unzip YouCompleteMe into bundle
sudo rm ./YouCompleteMe.tgz
for sf in `ls xa*`
do
	cat $sf >> YouCompleteMe.tgz
done
tar -zxvf ./YouCompleteMe.tgz -C ./res/bundle

#copy auto-highlight
cp ./auto-highlight.vim ./res/plugin/

#backup to ~/.vim
sudo rm -r ${REAL_HOME}/vim_install
sudo mv ./res ${REAL_HOME}/vim_install
sudo rm -r ${REAL_HOME}/.vim
ln -s ${REAL_HOME}/vim_install ${REAL_HOME}/.vim

#copy .vimrc
sudo cp ./.vimrc ${REAL_HOME}/

#remove ./res
rm ./YouCompleteMe.tgz
cd -
