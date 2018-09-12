#!/usr/bin/env bash
#編譯+部署order站點

#需要配置如下參數
# 項目路徑, 在Execute Shell中配置項目路徑, pwd 就可以獲得該項目路徑
# export PROJ_PATH=這個jenkins任務在部署機器上的路徑

# 輸入你的環境上tomcat的全路徑
# export TOMCAT_APP_PATH=tomcat在部署機器上的路徑

### base 函數
killTomcat()
{
    pid=`ps -ef|grep tomcat|grep java|awk '{print $2}'`
    echo "tomcat Id list :$pid"
    if [ "$pid" = "" ]
    then
      echo "no tomcat pid alive"
    else
      kill -9 $pid
    fi
}
cd $PROJ_PATH/order
mvn clean install

# 停tomcat
killTomcat

# 刪除原有工程
rm -rf $TOMCAT_APP_PATH/webapps/ROOT
rm -f $TOMCAT_APP_PATH/webapps/ROOT.war
rm -f $TOMCAT_APP_PATH/webapps/order.war

# 複製新的工程
cp $PROJ_PATH/order/target/order.war $TOMCAT_APP_PATH/webapps/

cd $TOMCAT_APP_PATH/webapps/
mv order.war ROOT.war

# 啟動Tomcat
cd $TOMCAT_APP_PATH/
sh bin/startup.sh



