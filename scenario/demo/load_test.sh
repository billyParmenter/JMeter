slave_array=(10.244.0.72 10.244.1.103 10.244.1.226 10.244.1.5 10.244.1.98); index=5 && while [ ${index} -gt 0 ]; do for slave in ${slave_array[@]}; do if echo 'test open port' 2>/dev/null > /dev/tcp/${slave}/1099; then echo ${slave}' ready' && slave_array=(${slave_array[@]/${slave}/}); index=$((index-1)); else echo ${slave}' not ready'; fi; done; echo 'Waiting for slave readiness'; sleep 2; done
echo "Installing needed plugins for master"
cd /opt/jmeter/apache-jmeter/bin
sh PluginsManagerCMD.sh install-for-jmx demo.jmx
jmeter -Ghost=google.com -Gport=443 -Gprotocol=https -Gthreads=10 -Gduration=60 -Grampup=6  --logfile /report/demo.jmx_2022-01-10_184214.jtl --nongui --testfile demo.jmx -Dserver.rmi.ssl.disable=true --remoteexit --remotestart 10.244.0.72,10.244.1.103,10.244.1.226,10.244.1.5,10.244.1.98 >> jmeter-master.out 2>> jmeter-master.err &
trap 'kill -10 1' EXIT INT TERM
java -jar /opt/jmeter/apache-jmeter/lib/jolokia-java-agent.jar start JMeter >> jmeter-master.out 2>> jmeter-master.err
wait
