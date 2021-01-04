#!/bin/sh
#dbus-send --system --type=signal /path interface.signalname
dbus-send --session --dest=org.gnome.ScreenSaver --type=method_call --print-reply /org/gnome/ScreenSaver org.gnome.ScreenSaver.SetActive boolean:false
#dbus-send --session --dest=org.gnome.ScreenSaver --type=method_call --print-reply /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock
#dbus-send --session --dest=org.gnome.ScreenSaver --type=method_call --print-reply /org/gnome/ScreenSaver org.freedesktop.DBus.Introspectable.Introspect
#for dbus session
#dbus-send --session --dest=com.deepglint.delinux.test --type=method_call --print-reply /com/deepglint/delinux/test com.deepglint.delinux.test.Method1
#dbus-send --session --dest=com.deepglint.delinux.test --type=method_call --print-reply /com/deepglint/delinux/test com.deepglint.delinux.test.Method2


#----busctl
#----method
#busctl --user call com.deepglint.delinux.test  /com/deepglint/delinux/test com.deepglint.delinux.test Method2

#----introspect
#busctl --user introspect com.deepglint.delinux.test /com/deepglint/delinux/test


#----property
#busctl --user get-property  com.deepglint.delinux.test /com/deepglint/delinux/test com.deepglint.delinux.test testInt
#busctl --user set-property  com.deepglint.delinux.test /com/deepglint/delinux/test com.deepglint.delinux.test testInt "i" 1

#----emit
#busctl emit /com/deepglint/delinux/dfumand com.deepglint.delinux.dfumand UpgradeProgress "ss" 0.1 "123"
