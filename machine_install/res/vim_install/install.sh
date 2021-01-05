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
rm -r ${HOME}/vim_install
sudo mv ./res ${HOME}/vim_install
rm -r ${HOME}/.vim
ln -s ${HOME}/vim_install ${HOME}/.vim

#copy .vimrc
sudo cp ./.vimrc ${HOME}/

#remove ./res
cd -
