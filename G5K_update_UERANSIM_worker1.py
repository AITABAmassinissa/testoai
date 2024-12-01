import os

namespace='oai-tutorial'
ip_adress="10.244.0.2"
nb_pods=10
network="cni1"


os.system("sudo ifconfig "+network+":"+str(1)+" "+str(ip_adress)+" up")
#update OAI-gnb file for UERANSIM 
with open(r'OAI-gnb.yaml', 'r') as file:
    data = file.read()
    file.close()
data = data.replace("xxx", str(ip_adress))
data = data.replace("0x000000010", "0x000000020")
#data = data.replace("yyy", str(amf_ip))
with open(r'UERANSIM/build/OAI-gnb.yaml', 'w') as file:
    file.write(data)
    file.close()
#update OAI-ue file for UERANSIM 
with open(r'OAI-ue.yaml', 'r') as file:
    data = file.read()
    file.close()
data = data.replace("xxx", str(ip_adress))
data = data.replace("yyy", namespace)
with open(r'UERANSIM/build/OAI-ue.yaml', 'w') as file:
    file.write(data)
    file.close()
