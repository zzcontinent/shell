#!/bin/bash
CURDIR=`dirname $0`
cd ${CURDIR}
sudo rm -r ./res
mkdir -p ./res

#unzip bundle taghighlight_r2 vim-autocomplpop
unzip ./taghighlight_r2.1.4.zip -d ./res
unzip ./vim-autocomplpop.zip -d ./res
tar -zxvf ./bundle.tgz -C ./res

#unzip YouCompleteMe into bundle
rm ./YouCompleteMe.tgz
for sf in `ls xa*`
do
	cat $sf >> YouCompleteMe.tgz
done
tar -zxvf ./YouCompleteMe.tgz -C ./res/bundle

#copy auto-highlight
cp ./auto-highlight.vim ./res/plugin/

#backup to ~/.vim
sudo rm -r ${HOME}/.vim.bak
sudo mv ${HOME}/.vim ${HOME}/.vim.bak
mkdir -p ${HOME}/.vim
sudo cp -a ./res/* ${HOME}/.vim/

#copy .vimrc
sudo cp ./.vimrc ${HOME}/

#remove ./res
sudo rm -r ./res
rm ./YouCompleteMe.tgz
cd -
