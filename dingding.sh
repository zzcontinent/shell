#! /bin/env bash
#
# dingding.sh
# Copyright (C) 2020 remilia <remilia@koumakan-company>
#
# Distributed under terms of the MIT license.
#
# 需要adb, 需要手机没有锁屏密码
# 坐标在开发者选项-输入-指针位置, 然后触摸屏幕, 会显示触摸点坐标
#



DEVICE='28D6R17306001223'
WORK_POINT='788 2475'
CHECK_PAGE_POINT='1400 1900'
CHECK_AM_POINT='800 800'
CHECK_PM_POINT='800 1200'
CHECK_CONFIRM_POINT='800 2400'
MAIL_COMMAND='echo "打卡截图" | mutt -x -s "DingDingChecker" hongzhichen@deepglint.com -a /tmp/dingding.png'

#DELAY=$(($RANDOM%600))
#echo "随机等待 $DELAY 秒"
#sleep $DELAY

retry() {
    $1
    if [ $? -ne 0 ]; then
        $2
    else
        return 0
    fi
    sleep 1
    $1
    if [ $? -ne 0 ]; then
        $2
    else
        return 0
    fi
    sleep 1
    $1
    if [ $? -ne 0 ]; then
        $2
    else
        return 0
    fi
    exit -1
}

is_dingding() {
    echo "检查钉钉"
    adb -s $DEVICE shell dumpsys activity top | grep ACTIVITY | grep 'com.alibaba.android.rimet/.biz.LaunchHomeActivity'
}

is_checking() {
    echo "检查打卡页面"
    adb -s $DEVICE shell dumpsys activity top | grep ACTIVITY | grep 'com.alibaba.android.rimet/com.alibaba.lightapp.runtime.activity.CommonWebViewActivity'
}

is_lighting() {
    echo "检查屏幕"
    adb -s $DEVICE shell dumpsys window policy | grep mScreen | grep true
}

unlock() {
    is_lighting
    if [ $? -ne 0 ]; then
        echo "屏幕未点亮，点亮屏幕"
        adb -s $DEVICE shell input keyevent 26
    fi
    sleep 1
    echo "尝试解锁"
    adb -s $DEVICE shell input keyevent 82
}

start_dingding() {
    echo "启动钉钉"
    adb -s $DEVICE shell am start -n 'com.alibaba.android.rimet/.biz.LaunchHomeActivity'
}

check() {
    is_checking
    if [ $? -ne 0 ]; then
        echo "进入工作台"
        adb -s $DEVICE shell input tap $WORK_POINT
        sleep 5
        echo "进入打卡"
        adb -s $DEVICE shell input tap $CHECK_PAGE_POINT
        sleep 5
    else
        exit -1
    fi

    is_checking
    if [ $? -ne 0 ]; then
        exit -1
    else
        echo "开始打卡"
    fi

    LC_ALL=en date +%r | grep PM
    if [ $? -ne 0 ]; then
        echo "打上午卡"
        adb -s $DEVICE shell input tap $CHECK_AM_POINT
    else
        echo "打下午卡"
        adb -s $DEVICE shell input tap $CHECK_PM_POINT
    fi
    sleep 5
    echo "确认打卡"
    adb -s $DEVICE shell input tap $CHECK_CONFIRM_POINT
    sleep 5
    adb -s ${DEVICE} shell input keyevent 4
    sleep 5
    echo "截屏"
    adb -s $DEVICE shell screencap -p > /tmp/dingding.png
    echo "发送邮件"
    bash -c "$MAIL_COMMAND"
    rm /tmp/dingding.png
}

back() {
    echo "返回"
    adb -s ${DEVICE} shell input keyevent 4
}

lock() {
    echo "锁屏"
    adb -s ${DEVICE} shell input keyevent 26
}



run() {
    unlock
    sleep 3
    retry is_dingding start_dingding
    sleep 3
    check
    sleep 3
    back
    sleep 1
    back
    sleep 1
    back
    sleep 1
    back
    sleep 1
    back
    sleep 3
    lock
    return 0
}

run
